classdef InstanceLibraryTest < matlab.unittest.TestCase
% InstanceLibraryTest - Unit tests for the openMINDS instance library
%
%   These read a small library kept with the tests, through
%   ommtest.helper.InstanceLibraryFixture, so they need no download and
%   check known instances. What can only be checked against the
%   downloaded library is in InstanceLibraryIntegrationTest.

    properties
        Fixture
    end

    methods (TestMethodSetup)
        function readTheTestLibrary(testCase)
            testCase.Fixture = ...
                testCase.applyFixture(ommtest.helper.InstanceLibraryFixture);
        end
    end

    methods (Test)
        function testInstancesAreTypedByWhatTheyDeclare(testCase)
        % Every instance in the test library is typed by the "@type" its
        % document declares, and its module follows from the type. The
        % folder names differ from the type names, in the plural and in
        % case, so nothing here can be read off a folder.

            expected = table( ...
                ["adult"; "youngAdult"; "male"; "MIT"; "text_plain"; "BA-human_BA32"], ...
                ["AgeCategory"; "AgeCategory"; "BiologicalSex"; "License"; ...
                    "ContentType"; "ParcellationEntity"], ...
                ["controlledTerms"; "controlledTerms"; "controlledTerms"; "core"; ...
                    "core"; "SANDS"], ...
                'VariableNames', ["InstanceName", "Type", "Module"]);

            actual = testCase.Fixture.Library.InstanceTable( ...
                :, ["InstanceName", "Type", "Module"]);

            testCase.verifyEqual(sortrows(actual), sortrows(expected))
        end

        function testInstancesGroupedInASubfolderCarryTheSubgroup(testCase)
        % Parcellation entities are grouped per atlas, here in
        % parcellationEntities/BA-human. That grouping is the subgroup.

            entity = testCase.instanceNamed("BA-human_BA32");

            testCase.verifyEqual(entity.Subgroup, "BA-human")
        end

        function testATypeFolderIsNotReportedAsASubgroup(testCase)
        % Controlled terms are stored one type per folder under
        % terminologies. That folder names the type, not a subgroup, and
        % the two are told apart by whether sibling folders share a type:
        % ageCategory and biologicalSex do not.

            term = testCase.instanceNamed("adult");

            testCase.verifyTrue(ismissing(term.Subgroup), ...
                'A folder that names a type must not be read as a subgroup.')
        end

        function testPluralIRISegmentResolvesToItsType(testCase)
        % A few instance IRIs name their type in the plural. openMINDS
        % publishes no plural to singular mapping, so the segments are
        % collected from the instances themselves.

            library = testCase.Fixture.Library;

            testCase.verifyEqual(library.getTypeFromIRISegment("licenses"), ...
                openminds.enum.Types("License"))
            testCase.verifyEqual(library.getTypeFromIRISegment("contentTypes"), ...
                openminds.enum.Types("ContentType"))
        end

        function testSingularIRISegmentResolvesToItsType(testCase)
            library = testCase.Fixture.Library;

            testCase.verifyEqual(library.getTypeFromIRISegment("ageCategory"), ...
                openminds.enum.Types("AgeCategory"))
            testCase.verifyEqual(library.getTypeFromIRISegment("parcellationEntity"), ...
                openminds.enum.Types("ParcellationEntity"))
        end

        function testUnknownIRISegmentIsRejected(testCase)
        % A segment that names no type in the library must raise this
        % specific error, so that a caller can tell a bad IRI from a
        % missing library.

            testCase.verifyError( ...
                @() testCase.Fixture.Library.getTypeFromIRISegment("notASegment"), ...
                'OPENMINDS:InstanceLibrary:UnknownIRISegment')
        end

        function testADocumentWithoutATypeIsReported(testCase)
        % A document whose "@type" cannot be read leaves its folder
        % untyped. That is reported, naming the document, rather than
        % skipped in silence like a folder that was never there.

            folder = testCase.Fixture.Folder;
            damagedFolder = fullfile(folder, "latest", "damaged");
            mkdir(damagedFolder)
            fileId = fopen(fullfile(damagedFolder, "broken.jsonld"), "w");
            fprintf(fileId, "{ not a document");
            fclose(fileId);

            library = testCase.verifyWarning( ...
                @() openminds.internal.InstanceLibrary.getSingleton(folder, "Reset", true), ...
                'OPENMINDS:InstanceLibrary:UnreadableInstance');

            broken = library.InstanceTable(library.InstanceTable.InstanceName == "broken", :);
            testCase.verifyEqual(broken.Type, "", ...
                'The damaged document must be listed without a type.')
            testCase.verifyEqual(nnz(library.InstanceTable.Type ~= ""), 6, ...
                'The other documents must be typed as before.')
        end

        function testAVersionWithoutInstancesIsReported(testCase)
        % A version folder that holds no instance files reads as an empty
        % library, with its columns in place, and warns rather than
        % errors. Selecting a model version rebuilds the library the same
        % way, and a library that cannot be read must not stop the
        % selection.

            folder = testCase.Fixture.Folder;
            rmdir(fullfile(folder, "latest"), "s")
            mkdir(fullfile(folder, "latest"))

            library = testCase.verifyWarning( ...
                @() openminds.internal.InstanceLibrary.getSingleton(folder, "Reset", true), ...
                'OPENMINDS:InstanceLibrary:InstancesNotFound');

            testCase.verifyEqual(height(library.InstanceTable), 0)
            testCase.verifyEqual( ...
                string(library.InstanceTable.Properties.VariableNames), ...
                ["InstanceName", "Type", "Module", "Subgroup", "Filepath"])
        end

        function testAMissingLocationIsRejectedByName(testCase)
        % The library is downloaded into its default location only, so a
        % location a caller names has to exist already. It is rejected
        % before the library in use is touched, so that library survives
        % the mistake.

            fixture = testCase.Fixture;

            testCase.verifyError( ...
                @() openminds.internal.InstanceLibrary.getSingleton( ...
                    fullfile(tempdir, "not-an-instance-library")), ...
                'OPENMINDS:InstanceLibrary:LocationNotFound')

            testCase.verifySameHandle( ...
                openminds.internal.InstanceLibrary.getSingleton(fixture.Folder), ...
                fixture.Library)
        end

        function testAFolderWithoutVersionsIsRejectedByName(testCase)
        % A folder that exists but holds no version folder is not a
        % library. Accepting it would replace the library in use with an
        % empty one, silently, and delete the handle the caller had.

            import matlab.unittest.fixtures.TemporaryFolderFixture

            fixture = testCase.Fixture;
            emptyFolder = testCase.applyFixture(TemporaryFolderFixture).Folder;

            testCase.verifyError( ...
                @() openminds.internal.InstanceLibrary.getSingleton(emptyFolder), ...
                'OPENMINDS:InstanceLibrary:LocationNotFound')

            testCase.verifySameHandle( ...
                openminds.internal.InstanceLibrary.getSingleton(fixture.Folder), ...
                fixture.Library)
        end

        function testLibraryLocationSurvivesAWorkingDirectoryChange(testCase)
        % The location is built under userpath. On a CI runner userpath is
        % empty, because $HOME/Documents does not exist, and a path built
        % under an empty userpath is relative. The library is read again on
        % every model version change, so the location must stay valid after
        % the working directory changes.

            library = testCase.Fixture.Library;
            testCase.assertTrue(isfolder(library.InstanceLibraryLocation))

            testCase.applyFixture( ...
                matlab.unittest.fixtures.WorkingFolderFixture)

            testCase.verifyTrue(isfolder(library.InstanceLibraryLocation), ...
                'The location must still name the library from another folder.')
        end
    end

    methods (Access = private)
        function row = instanceNamed(testCase, instanceName)
            instanceTable = testCase.Fixture.Library.InstanceTable;
            row = instanceTable(instanceTable.InstanceName == instanceName, :);
            testCase.assertEqual(height(row), 1, ...
                sprintf('Expected one instance named "%s" in the test library.', instanceName))
        end
    end
end
