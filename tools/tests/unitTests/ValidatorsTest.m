classdef ValidatorsTest < matlab.unittest.TestCase
    % ValidatorsTest - Unit tests for validator functions

    properties (TestParameter)
        % Instance IRIs whose type segment is plural, with the type each
        % one names.
        pluralIRI = { ...
            {"https://openminds.om-i.org/instances/licenses/MIT", "License"}, ...
            {"https://openminds.om-i.org/instances/contentTypes/text_plain", "ContentType"} }
    end

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

        function testParseInstanceIRIResolvesASingularTypeSegment(testCase)
        % Nearly every instance IRI names its type in the singular, which
        % resolves without consulting the instance library.

            S = openminds.utility.parseInstanceIRI( ...
                "https://openminds.om-i.org/instances/biologicalSex/male");

            testCase.verifyEqual(S.Type, openminds.enum.Types("BiologicalSex"))
            testCase.verifyEqual(S.Name, "male")
        end

        function testParseInstanceIRIResolvesAPluralTypeSegment(testCase, pluralIRI)
        % A few instance IRIs name their type in the plural. openMINDS
        % publishes no plural to singular mapping, so these are resolved
        % through the instance library, which reads the type each instance
        % declares. Splitting the IRI alone used to fail here.

            S = openminds.utility.parseInstanceIRI(pluralIRI{1});

            testCase.verifyEqual(S.Type, openminds.enum.Types(pluralIRI{2}))
        end

        function testParseInstanceIRIRejectsAnUnknownTypeSegment(testCase)
        % A segment that names neither a type nor a folder of the instance
        % library has to be reported as such, rather than as a failure to
        % reach the library.

            testCase.verifyError(...
                @() openminds.utility.parseInstanceIRI( ...
                    "https://openminds.om-i.org/instances/notAType/anInstance"), ...
                'openMINDS:ParseInstanceIRI:UnresolvedType')
        end
    end
end
