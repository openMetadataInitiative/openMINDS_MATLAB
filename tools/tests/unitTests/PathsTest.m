classdef PathsTest < matlab.unittest.TestCase
% PathsTest - Unit tests for the folders the toolbox reads from and writes to

    properties (TestParameter)
        % The folders that sit under MATLAB's user folder
        userFolderPath = {"UserPath", "SourceSchemaFolder", "LocalInstanceFolder"}
    end

    methods (Test)
        function testUserFolderPathIsAbsolute(testCase, userFolderPath)
        % A folder built under an empty userpath comes out relative, and a
        % relative folder stops naming the same place as soon as anything
        % changes the working directory. These are resolved when they are
        % first asked for, by which point there is a user folder to build
        % them under.

            folderPath = openminds.internal.constants.Paths.(userFolderPath);

            testCase.verifyTrue(isAbsolutePath(folderPath), sprintf( ...
                'Expected "%s" to be absolute, got "%s".', ...
                userFolderPath, folderPath))
        end

        function testUserFolderPathsAgreeOnTheirRoot(testCase)
        % The downloads live under one root, so that pointing the toolbox
        % somewhere else moves all of them together.

            import openminds.internal.constants.Paths

            testCase.verifyTrue( ...
                startsWith(Paths.SourceSchemaFolder, Paths.UserPath))
            testCase.verifyTrue( ...
                startsWith(Paths.LocalInstanceFolder, Paths.UserPath))
        end

        function testUserFolderPathIsResolvedOnce(testCase, userFolderPath)
        % Resolved once and kept, rather than on every call: a folder that
        % answered differently later would move the instance library out
        % from under whoever was reading it.

            first = openminds.internal.constants.Paths.(userFolderPath);
            second = openminds.internal.constants.Paths.(userFolderPath);

            testCase.verifyEqual(second, first)
        end

        function testGeneratedFolderIsInsideTheToolbox(testCase)
        % This one does not depend on the user folder. It is where the
        % generated type classes were written, inside the toolbox itself.

            testCase.verifyTrue(startsWith( ...
                openminds.internal.constants.Paths.GeneratedFolder, ...
                openminds.toolboxdir()))
        end
    end
end

function tf = isAbsolutePath(pathString)
    if ispc
        tf = ~isempty( regexp(pathString, '^([A-Za-z]:[\\/]|\\\\)', 'once') );
    else
        tf = startsWith(pathString, filesep);
    end
end
