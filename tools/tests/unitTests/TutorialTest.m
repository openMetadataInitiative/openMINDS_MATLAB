classdef TutorialTest <  matlab.unittest.TestCase
% TutorialTest - Unit test for testing the openMINDS tutorials.

    properties
        RootDirectory = openminds.internal.rootpath();
    end

    properties (TestParameter)
        % TutorialFile - A cell array where each cell is the name of a
        % tutorial file. testTutorial will run on each file individually
        tutorialFile = listTutorialFiles();
    end

    properties (Constant)
        SkippedTutorials = {};
    end

    methods (TestClassSetup)
        function setupClass(testCase) %#ok<*MANU>
            openminds.startup("latest")
        end
    end

    methods (TestClassTeardown)
        function tearDownClass(testCase)
            % Pass. No class teardown routines needed
        end
    end

    methods (TestMethodSetup)
        function setupMethod(testCase)
            % Pass. No method setup routines needed
        end
    end
    
    methods (Test)
        function testTutorial(testCase, tutorialFile)
            run(tutorialFile)
        end
    end
end

function tutorialFilePaths = listTutorialFiles()
% listTutorialFiles - List names of all tutorial files (exclude skipped files)
    rootPath = openminds.internal.rootpath();
    L = dir(fullfile(rootPath, 'livescripts', '*.mlx'));
    tutorialNames = setdiff({L.name}, TutorialTest.SkippedTutorials);

    tutorialFilePaths = fullfile(rootPath, 'livescripts', tutorialNames);
    tutorialFilePaths{end+1} = fullfile(rootPath, 'gettingStarted.mlx');
end
