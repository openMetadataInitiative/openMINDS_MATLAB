classdef InternalFunctionsTest < matlab.unittest.TestCase

    methods(TestClassSetup)
        % Shared setup for the entire test class
    end
    
    methods(TestMethodSetup)
        % Setup for each test
    end
    
    methods(Test)

        function testListFiles(testCase)
            codeFolder = openminds.toolboxdir();
            [filePath, filename] = openminds.internal.utility.dir.listFiles(codeFolder);
            testCase.verifyClass(filePath, 'cell');
            testCase.verifyClass(filename, 'cell');
        end
    end
end