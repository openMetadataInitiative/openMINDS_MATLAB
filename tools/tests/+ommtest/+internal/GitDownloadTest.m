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

            testCase.verifyTrue(openminds.internal.utility.git.hasLatestCommit())
        end
    end
end
