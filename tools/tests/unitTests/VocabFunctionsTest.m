classdef VocabFunctionsTest < matlab.unittest.TestCase
    % VocabFunctionsTest - Unit tests for functions in the vocab namespace

    methods (Test)
        function testGetTypeNameFromAliasValidAlias(testCase)
            % Test getTypeNameFromAlias with a valid alias
            typeName = openminds.internal.vocab.getTypeNameFromAlias("person");
            testCase.verifyEqual(typeName, "Person");
        end

        function testGetTypeNameFromAliasInvalidAlias(testCase)
            % Test getTypeNameFromAlias with an invalid alias
            testCase.verifyError(@() openminds.internal.vocab.getTypeNameFromAlias("invalidAlias"), ...
                'OPENMINDS:TypeNameNotFound');
        end

        function testLoadVocabJsonValidFile(testCase)
            % Test loadVocabJson with a valid file
            S = openminds.internal.vocab.loadVocabJson("types");
            testCase.verifyNotEmpty(S);
        end

        function testLoadVocabJsonMissingFile(testCase)
            % Test loadVocabJson with a missing file
            % Assuming "missingType" is not a valid type
            testCase.verifyError(...
                @() openminds.internal.vocab.loadVocabJson("missingType"), ...
                'MATLAB:validation:UnableToConvert');
        end
    end
end
