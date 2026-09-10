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
        % Instance folders are named after pluralized type names, which
        % upstream renames whenever a type is renamed. Typing instances by
        % folder name therefore went stale silently and left whole modules
        % of the library untyped, so no instance may be left without one.

            untyped = testCase.InstanceTable(testCase.InstanceTable.Type == "", :);

            testCase.verifyEmpty(untyped, sprintf( ...
                'Instances of %d folder(s) were left without a type, e.g. "%s".', ...
                numel(unique(fileparts(untyped.Filepath))), ...
                strjoin(unique(fileparts(untyped.Filepath))', '", "')))
        end

        function testTypeIsTakenFromTheInstanceAndNotTheFolderName(testCase)
        % License instances are stored in a folder named "licenses", so the
        % folder name does not name the type and no capitalization of it
        % ever will. The type the instance declares is the only source that
        % survives an upstream rename.

            licenses = testCase.instancesOfType("License");
            testCase.assumeNotEmpty(licenses)

            [~, folderNames] = fileparts(fileparts(licenses.Filepath));

            testCase.verifyTrue(all(folderNames == "licenses"), ...
                'Expected License instances to be stored in the "licenses" folder.')
        end

        function testModuleIsResolvedForEveryInstance(testCase)
        % The module used to be assigned alongside the type from the same
        % folder classification, so it went stale for the same reason.

            testCase.verifyEmpty( ...
                testCase.InstanceTable(testCase.InstanceTable.Module == "", :))
        end

        function testInstancesGroupedInASubfolderCarryTheSubgroup(testCase)
        % Parcellation entities are grouped per atlas, e.g. in
        % parcellationEntities/BA-human. That grouping is the subgroup.

            entities = testCase.instancesOfType("ParcellationEntity");
            testCase.assumeNotEmpty(entities)

            testCase.verifyFalse(any(ismissing(entities.Subgroup)), ...
                'Instances grouped in a subfolder must carry that subgroup.')
        end

        function testATypeFolderIsNotReportedAsASubgroup(testCase)
        % Controlled terms are stored one type per folder under
        % terminologies. That folder names the type, not a subgroup, and
        % the two are told apart by whether sibling folders share a type.

            ageCategories = testCase.instancesOfType("AgeCategory");
            testCase.assumeNotEmpty(ageCategories)

            testCase.verifyTrue(all(ismissing(ageCategories.Subgroup)), ...
                'A folder that names a type must not be read as a subgroup.')
        end

        function testPluralIRISegmentResolvesToItsType(testCase)
        % A few instance IRIs name their type in the plural. openMINDS
        % publishes no plural to singular mapping, so the segments are
        % collected from the instances themselves.

            typeEnum = testCase.InstanceLibrary.getTypeFromIRISegment("licenses");

            testCase.verifyEqual(typeEnum, openminds.enum.Types("License"))
        end

        function testSingularIRISegmentResolvesToItsType(testCase)
            typeEnum = ...
                testCase.InstanceLibrary.getTypeFromIRISegment("parcellationEntity");

            testCase.verifyEqual(typeEnum, openminds.enum.Types("ParcellationEntity"))
        end

        function testSelectingAModelVersionRebuildsTheLibrary(testCase)
        % Instances are typed against the model version that was on the
        % path when the library was read, so selecting another version has
        % to rebuild the library that is already in memory, in place, for
        % the sake of code holding on to it.

            library = testCase.InstanceLibrary;
            testCase.assertEqual(library.ModelVersion, openminds.version())

            testCase.applyFixture(ommtest.helper.ModelVersionFixture("v3.0"))

            testCase.verifyEqual(library.ModelVersion, "v3.0", ...
                'Selecting a model version must rebuild the library in memory.')

            % The version is recorded the way openminds.version reports it,
            % so the next use recognizes the library as current instead of
            % rebuilding it a second time.
            testCase.verifySameHandle( ...
                openminds.internal.InstanceLibrary.getSingleton(), library)
        end

        function testLibraryVersionFollowsTheModelVersion(testCase)
        % The library publishes one set of instances per model version, and
        % reading one version's instances against another version's types
        % is what leaves instances untyped. The two are therefore not
        % chosen separately.

            library = testCase.InstanceLibrary;
            testCase.assumeTrue(ismember("v3.0", library.AvailableVersions))

            testCase.applyFixture(ommtest.helper.ModelVersionFixture("v3.0"))

            testCase.verifyEqual(library.LibraryVersion, "v3.0")

            % Read from that version's instances, not merely labelled with
            % it. Whether every one of them then resolves to a type also
            % depends on the model classes having been reloaded, which a
            % session that still holds instances of them cannot do, so it
            % is not what is checked here.
            readFromVersion = contains(library.InstanceTable.Filepath, ...
                fullfile(filesep, "v3.0", filesep));

            testCase.verifyTrue(all(readFromVersion), ...
                'The library must read the instances of the selected version.')
        end

        function testModelVersionWithoutInstancesIsReported(testCase)
        % Versions 1 and 2 of the model predate the type names the instance
        % library is written against, so no version of the library can
        % stand in for them. That has to be said rather than left to look
        % like a library that happens to be empty.

            previousModelVersion = openminds.version();
            testCase.addTeardown(@openminds.version, previousModelVersion);

            testCase.verifyWarning(@() openminds.version("v1.0"), ...
                'OPENMINDS:InstanceLibrary:NoInstancesForModelVersion')

            library = testCase.InstanceLibrary;
            testCase.verifyTrue(ismissing(library.LibraryVersion), ...
                'No library version can be read for this model version.')

            % The table keeps its columns with nothing in it, so filtering
            % it answers with no instances rather than erroring on a table
            % that has nothing to filter on.
            testCase.verifyEqual(height(library.InstanceTable), 0)
            testCase.verifyEqual( ...
                string(library.InstanceTable.Properties.VariableNames), ...
                ["InstanceName", "Type", "Module", "Subgroup", "Filepath"])
        end

        function testUnknownIRISegmentIsRejected(testCase)
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
