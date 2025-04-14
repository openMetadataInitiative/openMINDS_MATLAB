classdef GitDownloadTest < matlab.unittest.TestCase

    methods (TestMethodSetup)
        function useTemporaryWorkingDirectory(testCase)
            import matlab.unittest.fixtures.WorkingFolderFixture
            testCase.applyFixture(WorkingFolderFixture)
        end
    end

    methods (Test)
        function testDownloadRepo(testCase)
            openminds.internal.utility.git.downloadRepository("TargetDirectory", pwd)

            testCase.verifyTrue(openminds.internal.utility.git.isLatest())
        end
    end
end