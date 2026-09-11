classdef PathsTest < matlab.unittest.TestCase
% PathsTest - Unit tests for the folders the toolbox reads from and writes to

    properties (TestParameter)
        % The folders that sit under MATLAB's user folder
        userFolderPath = {"UserPath", "SourceSchemaFolder", "LocalInstanceFolder"}
    end

    methods (Test)
        function testUserFolderPathIsAbsolute(testCase, userFolderPath)
        % A folder built under an empty userpath is a relative path, which
        % points somewhere else once the working directory changes. The
        % folders are resolved on first call, after ensureUserpath has set
        % a user folder, so they must come out absolute.

            folderPath = openminds.internal.constants.Paths.(userFolderPath);

            testCase.verifyTrue(isAbsolutePath(folderPath), sprintf( ...
                'Expected "%s" to be absolute, got "%s".', ...
                userFolderPath, folderPath))
        end

        function testUserFolderPathsAgreeOnTheirRoot(testCase)
        % All downloads live under UserPath, so that changing the user
        % folder moves all of them together.

            import openminds.internal.constants.Paths

            testCase.verifyTrue( ...
                startsWith(Paths.SourceSchemaFolder, Paths.UserPath))
            testCase.verifyTrue( ...
                startsWith(Paths.LocalInstanceFolder, Paths.UserPath))
        end

        function testUserFolderPathIsResolvedOnce(testCase, userFolderPath)
        % The folders are resolved once and cached. A folder that changed
        % between calls would move the instance library out from under code
        % that is reading it.

            first = openminds.internal.constants.Paths.(userFolderPath);
            second = openminds.internal.constants.Paths.(userFolderPath);

            testCase.verifyEqual(second, first)
        end

        function testGeneratedFolderIsInsideTheToolbox(testCase)
        % GeneratedFolder does not depend on the user folder. The generated
        % type classes are written inside the toolbox.

            testCase.verifyTrue(startsWith( ...
                openminds.internal.constants.Paths.GeneratedFolder, ...
                openminds.toolboxdir()))
        end
    end
end

function tf = isAbsolutePath(pathString)
% Independent of the implementation under test, so that the two cannot
% share a mistake.
    tf = java.io.File(char(pathString)).isAbsolute();
end
