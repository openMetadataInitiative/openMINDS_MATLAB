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

        function testParseInstanceIRIRejectsANonInstanceIRI(testCase)
        % A caller holding an arbitrary IRI has to be able to tell this
        % apart from a genuine failure, which a bare assert did not allow.

            testCase.verifyError(...
                @() openminds.utility.parseInstanceIRI("https://openminds.om-i.org/types/Species"), ...
                'openMINDS:ParseInstanceIRI:NotAnInstanceIRI')
        end

        function testParseInstanceIRIRejectsAnIRIWithoutAPath(testCase)
        % The path is empty for an IRI with a host and nothing else. It
        % may not be indexed, so this used to fail on the index rather
        % than report what was wrong.

            testCase.verifyError(...
                @() openminds.utility.parseInstanceIRI("https://openminds.om-i.org"), ...
                'openMINDS:ParseInstanceIRI:NotAnInstanceIRI')
        end
    end
end
