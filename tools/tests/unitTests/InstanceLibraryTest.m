classdef InstanceLibraryTest < matlab.unittest.TestCase
% InstanceLibraryTest - Unit tests for the openMINDS instance library

    properties
        InstanceLibrary
        InstanceTable table
    end

    methods (TestClassSetup)
        function setupClass(testCase)
            testCase.InstanceLibrary = ...
                openminds.internal.InstanceLibrary.getSingleton();
            testCase.InstanceTable = testCase.InstanceLibrary.InstanceTable;

            testCase.assumeNotEmpty(testCase.InstanceTable, ...
                'The instance library is not available locally.')
        end
    end

    methods (Test)
        function testEveryInstanceIsTyped(testCase)
        % Instances used to be typed by folder name. Folder names are
        % pluralized type names that upstream renames whenever a type is
        % renamed, so that typing went stale silently and left whole
        % modules of the library untyped. Every instance must have a type.

            untyped = testCase.InstanceTable(testCase.InstanceTable.Type == "", :);

            testCase.verifyEmpty(untyped, sprintf( ...
                'Instances of %d folder(s) were left without a type, e.g. "%s".', ...
                numel(unique(fileparts(untyped.Filepath))), ...
                strjoin(unique(fileparts(untyped.Filepath))', '", "')))
        end

        function testTypeIsTakenFromTheInstanceAndNotTheFolderName(testCase)
        % License instances are stored in a folder named "licenses". No
        % capitalization of that folder name gives the type name "License",
        % so the type must come from the "@type" the instance declares.

            licenses = testCase.instancesOfType("License");
            testCase.assumeNotEmpty(licenses)

            [~, folderNames] = fileparts(fileparts(licenses.Filepath));

            testCase.verifyTrue(all(folderNames == "licenses"), ...
                'Expected License instances to be stored in the "licenses" folder.')
        end

        function testModuleIsResolvedForEveryInstance(testCase)
        % The module used to be derived from the folder name together with
        % the type, so it went stale for the same reason.

            testCase.verifyEmpty( ...
                testCase.InstanceTable(testCase.InstanceTable.Module == "", :))
        end

        function testInstancesGroupedInASubfolderCarryTheSubgroup(testCase)
        % Parcellation entities are split into one subfolder per atlas,
        % e.g. parcellationEntities/BA-human. The subfolder is the subgroup.

            entities = testCase.instancesOfType("ParcellationEntity");
            testCase.assumeNotEmpty(entities)

            testCase.verifyFalse(any(ismissing(entities.Subgroup)), ...
                'Instances grouped in a subfolder must carry that subgroup.')
        end

        function testATypeFolderIsNotReportedAsASubgroup(testCase)
        % Controlled terms are stored one type per subfolder under
        % terminologies, e.g. terminologies/ageCategory. That subfolder
        % names a type, not a subgroup. The two cases are told apart by
        % whether sibling folders hold the same type.

            ageCategories = testCase.instancesOfType("AgeCategory");
            testCase.assumeNotEmpty(ageCategories)

            testCase.verifyTrue(all(ismissing(ageCategories.Subgroup)), ...
                'A folder that names a type must not be read as a subgroup.')
        end

        function testPluralIRISegmentResolvesToItsType(testCase)
        % A few instance IRIs name their type in the plural. openMINDS
        % publishes no plural-to-singular mapping, so the library reads the
        % mapping from the instance documents.

            typeEnum = testCase.InstanceLibrary.getTypeFromIRISegment("licenses");

            testCase.verifyEqual(typeEnum, openminds.enum.Types("License"))
        end

        function testSingularIRISegmentResolvesToItsType(testCase)
            typeEnum = ...
                testCase.InstanceLibrary.getTypeFromIRISegment("parcellationEntity");

            testCase.verifyEqual(typeEnum, openminds.enum.Types("ParcellationEntity"))
        end

        function testSelectingAModelVersionRebuildsTheLibrary(testCase)
        % The instance table is typed against the model version on the path
        % when it was built, so selecting another version must rebuild the
        % library object already in memory. It must be rebuilt in place,
        % because other code may hold a reference to the object.

            library = testCase.InstanceLibrary;
            testCase.assertEqual(library.ModelVersion, openminds.version())

            testCase.applyFixture(ommtest.helper.ModelVersionFixture("v3.0"))

            testCase.verifyEqual(library.ModelVersion, "v3.0", ...
                'Selecting a model version must rebuild the library in memory.')

            % ModelVersion is stored in the format openminds.version
            % reports, so getSingleton must recognize the rebuilt library
            % as current and return the same handle instead of creating a
            % new one.
            testCase.verifySameHandle( ...
                openminds.internal.InstanceLibrary.getSingleton(), library)
        end

        function testLibraryVersionFollowsTheModelVersion(testCase)
        % The library publishes one set of instances per model version, and
        % reading one version's instances against another version's classes
        % leaves instances untyped, so the library version must equal the
        % model version.

            library = testCase.InstanceLibrary;
            testCase.assumeTrue(ismember("v3.0", library.AvailableVersions))

            testCase.applyFixture(ommtest.helper.ModelVersionFixture("v3.0"))

            testCase.verifyEqual(library.LibraryVersion, "v3.0")

            % The library is downloaded, and a copy may hold no instances
            % for this version. That is not a failure of the code under
            % test.
            testCase.assumeNotEmpty(library.InstanceTable, ...
                'The instance library holds no instances for this version.')

            % Check that the instances were read from the v3.0 folder, not
            % merely labelled v3.0. Whether every instance then resolves to
            % a type depends on the model classes having been reloaded,
            % which MATLAB cannot do while objects of those classes exist
            % in the session, so that is not checked here.
            readFromVersion = contains(library.InstanceTable.Filepath, ...
                fullfile(filesep, "v3.0", filesep));

            testCase.verifyTrue(all(readFromVersion), ...
                'The library must read the instances of the selected version.')
        end

        function testModelVersionWithoutInstancesIsReported(testCase)
        % Model versions 1 and 2 predate the type names the instance library
        % uses, so no library version can serve them. This must be reported
        % as a warning rather than look like a library that happens to be
        % empty.
        %
        % The version is switched directly rather than through
        % ModelVersionFixture because verifyWarning has to wrap the call
        % that raises the warning.

            previousModelVersion = openminds.version();
            testCase.addTeardown(@openminds.version, previousModelVersion);

            testCase.verifyWarning(@() openminds.version("v1.0"), ...
                'OPENMINDS:InstanceLibrary:NoInstancesForModelVersion')

            library = testCase.InstanceLibrary;
            testCase.verifyTrue(ismissing(library.LibraryVersion), ...
                'No library version can be read for this model version.')

            % The table keeps its columns, so filtering it returns no rows
            % instead of erroring.
            testCase.verifyEqual(height(library.InstanceTable), 0)
            testCase.verifyEqual( ...
                string(library.InstanceTable.Properties.VariableNames), ...
                ["InstanceName", "Type", "Module", "Subgroup", "Filepath"])
        end

        function testLibraryLocationSurvivesAWorkingDirectoryChange(testCase)
        % The location is built under userpath. On a CI runner userpath is
        % empty, because $HOME/Documents does not exist, and a path built
        % under an empty userpath is relative. The library is read again on
        % every model version change, so the location must stay valid after
        % the working directory changes.

            library = testCase.InstanceLibrary;
            testCase.assumeTrue(isfolder(library.InstanceLibraryLocation))

            testCase.applyFixture( ...
                matlab.unittest.fixtures.WorkingFolderFixture)

            testCase.verifyTrue(isfolder(library.InstanceLibraryLocation), ...
                'The location must still name the library from another folder.')
        end

        function testUnknownIRISegmentIsRejected(testCase)
        % A segment that names no type in the library must raise this
        % specific error, so that a caller can tell a bad IRI from a
        % missing library.

            testCase.verifyError( ...
                @() testCase.InstanceLibrary.getTypeFromIRISegment("notASegment"), ...
                'OPENMINDS:InstanceLibrary:UnknownIRISegment')
        end
    end

    methods (Access = private)
        function instances = instancesOfType(testCase, typeName)
            instances = testCase.InstanceTable( ...
                testCase.InstanceTable.Type == typeName, :);
        end
    end
end
