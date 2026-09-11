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
        % Instances used to be typed by folder name. Folder names are
        % pluralized type names that upstream renames whenever a type is
        % renamed, so that typing went stale silently and left whole
        % modules of the library untyped. Every instance must have a type,
        % and only the downloaded library can show that this holds for
        % what upstream ships today.

            untyped = testCase.InstanceTable(testCase.InstanceTable.Type == "", :);

            testCase.verifyEmpty(untyped, sprintf( ...
                'Instances of %d folder(s) were left without a type, e.g. "%s".', ...
                numel(unique(fileparts(untyped.Filepath))), ...
                strjoin(unique(fileparts(untyped.Filepath))', '", "')))
        end

        function testModuleIsResolvedForEveryInstance(testCase)
        % The module used to be derived from the folder name together with
        % the type, so it went stale for the same reason.

            testCase.verifyEmpty( ...
                testCase.InstanceTable(testCase.InstanceTable.Module == "", :))
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
    end
end
