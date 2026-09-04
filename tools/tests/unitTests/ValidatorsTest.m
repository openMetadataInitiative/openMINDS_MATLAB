classdef ValidatorsTest < matlab.unittest.TestCase
    % ValidatorsTest - Unit tests for validator functions
    
    methods (Test)
        function testMustBeOpenMINDSIRI(testCase)
            % Verify that validation of valid IRI succeeds
            validIRI = 'https://openminds.ebrains.eu/instances/biologicalSex/male';
            openminds.mustBeOpenMINDSIRI(validIRI)
            
            % Verify that validation of invalid IRI throws error
            invalidIRI = 'https://github.com/openMetadataInitiative/openMINDS_instances/blob/main/instances/v3.0/terminologies/biologicalSex/male.jsonld';
            testCase.verifyError(...
                @() openminds.mustBeOpenMINDSIRI(invalidIRI), ...
                'OPENMINDS_MATLAB:Validators:InvalidOpenMINDSIRI')
        end
    end
end
