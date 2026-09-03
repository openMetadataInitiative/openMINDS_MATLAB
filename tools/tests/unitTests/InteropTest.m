classdef InteropTest < matlab.unittest.TestCase
%InteropTest Interoperability with the Python reference implementation
%
%   The same collection is built natively by this toolbox and by the
%   Python reference implementation from one fixture specification, and
%   the two exports are compared structurally. Each export is also passed
%   through the other implementation and back, to check that nothing is
%   lost in reading.
%
%   The Python side is tools/tests/interop/openminds_interop.py. Set the
%   environment variable OPENMINDS_PYTHON to a Python interpreter that can
%   import the openminds package to run this test; it is skipped otherwise.

    properties (Access = private)
        Python (1,1) string
        Helper (1,1) string
        Spec (1,1) string
    end

    methods (TestClassSetup)
        function locatePython(testCase)
            python = string(getenv("OPENMINDS_PYTHON"));
            testCase.assumeTrue(strlength(python) > 0, ...
                "Set OPENMINDS_PYTHON to a Python interpreter with the " + ...
                "openminds package to run the interoperability test.")

            % An interpreter that is set but cannot import the package is
            % a broken setup rather than a reason to skip
            [status, output] = system(sprintf('"%s" -c "import openminds"', python));
            testCase.assertEqual(status, 0, ...
                "OPENMINDS_PYTHON is set but cannot import openminds: " + output)

            testsFolder = fileparts(fileparts(mfilename('fullpath')));
            testCase.Python = python;
            testCase.Helper = fullfile(testsFolder, "interop", "openminds_interop.py");
            testCase.Spec = fullfile(ommtest.helper.fixturePath(), "interop_collection.json");
        end
    end

    methods (TestMethodSetup)
        function useTemporaryFolder(testCase)
            testCase.applyFixture(matlab.unittest.fixtures.WorkingFolderFixture)
        end
    end

    methods (Test)
        function testNativeExportsAreTheSame(testCase)
            % Both implementations write the same document for the same
            % collection, apart from blank node labels and ordering.
            matlabExport = testCase.exportFromMatlab("matlab.jsonld");
            pythonExport = testCase.runPython("build", testCase.Spec, "python.jsonld");

            testCase.verifySameDocument(matlabExport, pythonExport)
        end

        function testPythonExportSurvivesMatlab(testCase)
            % A Python export read by this toolbox and written back is
            % read by Python as the same collection it wrote.
            pythonExport = testCase.runPython("build", testCase.Spec, "python.jsonld");
            viaMatlab = testCase.passThroughMatlab(pythonExport, "via_matlab.jsonld");
            backInPython = testCase.runPython("roundtrip", viaMatlab, "python_again.jsonld");

            testCase.verifySameDocument(pythonExport, backInPython)
        end

        function testMatlabExportSurvivesPython(testCase)
            % A MATLAB export read by Python and written back is read by
            % this toolbox as the same collection it wrote.
            matlabExport = testCase.exportFromMatlab("matlab.jsonld");
            viaPython = testCase.runPython("roundtrip", matlabExport, "via_python.jsonld");
            backInMatlab = testCase.passThroughMatlab(viaPython, "matlab_again.jsonld");

            testCase.verifySameDocument(matlabExport, backInMatlab)
        end
    end

    methods (Access = private)
        function filePath = exportFromMatlab(testCase, fileName)
            collection = ommtest.helper.buildInteropCollection(testCase.Spec);
            filePath = string(fullfile(pwd, fileName));
            collection.save(filePath);
        end

        function filePath = passThroughMatlab(~, inputPath, fileName)
            collection = openminds.Collection(inputPath);
            filePath = string(fullfile(pwd, fileName));
            collection.save(filePath);
        end

        function outputPath = runPython(testCase, command, inputPath, outputName)
            outputPath = string(fullfile(pwd, outputName));
            [status, output] = testCase.callHelper(command, inputPath, outputPath);
            testCase.assertEqual(status, 0, ...
                sprintf("Python helper failed on '%s':%s%s", command, newline, output))
        end

        function verifySameDocument(testCase, expectedPath, actualPath)
            [status, output] = testCase.callHelper("compare", expectedPath, actualPath);
            testCase.verifyEqual(status, 0, ...
                sprintf("The documents differ:%s%s", newline, output))
        end

        function [status, output] = callHelper(testCase, varargin)
            quoted = cellfun(@(arg) sprintf('"%s"', arg), ...
                [{testCase.Python, testCase.Helper}, varargin], 'UniformOutput', false);
            [status, output] = system(strjoin(quoted, " "));
        end
    end
end
