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
