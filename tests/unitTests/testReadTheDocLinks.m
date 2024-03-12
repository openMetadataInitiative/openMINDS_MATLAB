classdef testReadTheDocLinks < matlab.unittest.TestCase

    methods (Test)

        function testPass(testCase)
            fprintf('Test passed\n')
        end

        function testFail(testCase)
            error('Test failed')
        end
    end
end
