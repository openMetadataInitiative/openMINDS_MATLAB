classdef VocabFunctionsTest < matlab.unittest.TestCase
    % VocabFunctionsTest - Unit tests for functions in the vocab namespace

    methods (Test)
        function testGetSchemaNameValidAlias(testCase)
            % Test getSchemaName with a valid alias
            schemaName = openminds.internal.vocab.getSchemaName("person");
            testCase.verifyEqual(schemaName, "Person");
        end

        function testGetSchemaNameInvalidAlias(testCase)
            % Test getSchemaName with an invalid alias
            testCase.verifyError(@() openminds.internal.vocab.getSchemaName("invalidAlias"), ...
                'OPENMINDS:SchemaNameNotFound');
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
