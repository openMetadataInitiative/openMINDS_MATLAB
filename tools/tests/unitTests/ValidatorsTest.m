classdef ValidatorsTest < matlab.unittest.TestCase
    % ValidatorsTest - Unit tests for validator functions
    
    methods (Test)
        function testMustBeValidOpenMINDSIRI(testCase)
            % Verify that validation of valid IRI succeeds
            validIRI = 'https://openminds.ebrains.eu/instances/biologicalSex/male';
            openminds.mustBeValidOpenMINDSIRI(validIRI)
            
            % Verify that validation of invalid IRI throws error
            invalidIRI = 'https://github.com/openMetadataInitiative/openMINDS_instances/blob/main/instances/v3.0/terminologies/biologicalSex/male.jsonld';
            testCase.verifyError(...
                @() openminds.mustBeValidOpenMINDSIRI(invalidIRI), ...
                'OPENMINDS_MATLAB:Validators:InvalidOpenMINDSIRI')
        end
    end
end
