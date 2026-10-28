classdef GitDownloadTest < matlab.unittest.TestCase

    methods (TestMethodSetup)
        function useTemporaryWorkingDirectory(testCase)
            import matlab.unittest.fixtures.WorkingFolderFixture
            testCase.applyFixture(WorkingFolderFixture)
        end
    end

    methods (Test)
        function testDownloadRepo(testCase)

            % Download a repo without capturing output
            commandStr = sprintf([...
                'openminds.internal.utility.git.downloadRepository', ...
                '("TargetDirectory", "%s")'], pwd );
            evalc(commandStr);

            testCase.verifyTrue(openminds.internal.utility.git.isRecordedCommitCurrent())
        end

        function testArchiveReplacesThePreviousCopy(testCase)
        % The previous copy is replaced, not merged into, and nothing of
        % the staging folder remains.
            import openminds.internal.utility.git.extractRepositoryArchive

            targetDirectory = fullfile(pwd, "Repositories");
            writeRepositoryFolder(fullfile(targetDirectory, "repo-main"), "old.txt")
            zipFilePath = writeRepositoryArchive(pwd, "repo-main", "new.txt");

            repositoryFolder = extractRepositoryArchive(zipFilePath, targetDirectory);

            testCase.verifyEqual(repositoryFolder, fullfile(targetDirectory, "repo-main"))
            testCase.verifyTrue(isfile(fullfile(repositoryFolder, "new.txt")))
            testCase.verifyFalse(isfile(fullfile(repositoryFolder, "old.txt")), ...
                'The previous copy must be replaced, not merged into.')
            testCase.verifyEqual(folderNames(targetDirectory), "repo-main", ...
                'Nothing of the staging folder may remain.')
        end

        function testFailedExtractionLeavesThePreviousCopy(testCase)
        % An archive that cannot be read is reported, the previous copy is
        % untouched, and nothing of the staging folder remains.
            import openminds.internal.utility.git.extractRepositoryArchive

            targetDirectory = fullfile(pwd, "Repositories");
            writeRepositoryFolder(fullfile(targetDirectory, "repo-main"), "old.txt")
            zipFilePath = fullfile(pwd, "damaged.zip");
            writeTextFile(zipFilePath, "not an archive")

            testCase.verifyError( ...
                @() extractRepositoryArchive(zipFilePath, targetDirectory), ?MException)

            testCase.verifyTrue(isfile(fullfile(targetDirectory, "repo-main", "old.txt")), ...
                'The previous copy must survive a failed extraction.')
            testCase.verifyEqual(folderNames(targetDirectory), "repo-main", ...
                'Nothing of the staging folder may remain.')
        end

        function testAnArchiveNotHoldingOneFolderIsRejected(testCase)
        % A GitHub archive holds one folder. Anything else is reported by
        % identifier before the previous copy is touched.
            import openminds.internal.utility.git.extractRepositoryArchive

            targetDirectory = fullfile(pwd, "Repositories");
            writeRepositoryFolder(fullfile(targetDirectory, "repo-main"), "old.txt")
            sourceFolder = fullfile(pwd, "archive-source");
            writeRepositoryFolder(fullfile(sourceFolder, "repo-main"), "new.txt")
            writeTextFile(fullfile(sourceFolder, "stray.txt"), "x")
            zipFilePath = fullfile(pwd, "two-items.zip");
            zip(zipFilePath, ["repo-main", "stray.txt"], sourceFolder)

            testCase.verifyError( ...
                @() extractRepositoryArchive(zipFilePath, targetDirectory), ...
                'OPENMINDS:Git:UnexpectedArchiveLayout')

            testCase.verifyTrue(isfile(fullfile(targetDirectory, "repo-main", "old.txt")))
            testCase.verifyEqual(folderNames(targetDirectory), "repo-main")
        end
    end
end

function writeRepositoryFolder(folderPath, fileName)
    mkdir(folderPath)
    writeTextFile(fullfile(folderPath, fileName), "x")
end

function writeTextFile(filePath, text)
    fileId = fopen(filePath, "w");
    fwrite(fileId, text);
    fclose(fileId);
end

function zipFilePath = writeRepositoryArchive(rootFolder, folderName, fileName)
% An archive laid out like a GitHub archive: one folder at its top.
    sourceFolder = fullfile(rootFolder, "archive-source");
    writeRepositoryFolder(fullfile(sourceFolder, folderName), fileName)
    zipFilePath = fullfile(rootFolder, folderName + ".zip");
    zip(zipFilePath, folderName, sourceFolder)
end

function names = folderNames(folderPath)
    L = dir(folderPath);
    L(startsWith({L.name}, ".")) = [];
    names = string({L.name});
end
