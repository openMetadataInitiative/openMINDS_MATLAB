classdef InstanceLibraryIntegrationTest < matlab.unittest.TestCase
% InstanceLibraryIntegrationTest - Tests against the downloaded instance library
%
%   These read the library the toolbox downloads, so they need it to be
%   there and skip when it is not. What they check cannot be checked
%   against a library kept with the tests: that every instance upstream
%   ships resolves to a type in the model, and that the library follows
%   the model version across the versions upstream publishes.

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
        % Only the downloaded library can say whether that holds for what
        % upstream ships today.

            untyped = testCase.InstanceTable(testCase.InstanceTable.Type == "", :);

            testCase.verifyEmpty(untyped, sprintf( ...
                'Instances of %d folder(s) were left without a type, e.g. "%s".', ...
                numel(unique(fileparts(untyped.Filepath))), ...
                strjoin(unique(fileparts(untyped.Filepath))', '", "')))
        end

        function testModuleIsResolvedForEveryInstance(testCase)
        % The module used to be assigned alongside the type from the same
        % folder classification, so it went stale for the same reason.

            testCase.verifyEmpty( ...
                testCase.InstanceTable(testCase.InstanceTable.Module == "", :))
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

            % The library is downloaded, so a copy that is incomplete for
            % this version leaves nothing to check rather than something to
            % fail on.
            testCase.assumeNotEmpty(library.InstanceTable, ...
                'The instance library holds no instances for this version.')

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
        %
        % The version is switched by hand rather than through the fixture
        % the other tests use, because the warning is raised by the switch
        % itself and verifyWarning has to wrap that call.

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
    end
end
