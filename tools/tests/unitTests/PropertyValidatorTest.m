classdef PropertyValidatorTest < matlab.unittest.TestCase
    % PropertyValidatorTest - Unit tests for property validator functions
    
    methods (Test)
        function testMustBeListOfUniqueItemsForMixedTypes(testCase)

            org = organizationWithTwoIds(); % From oneOffs
            
            % Should pass for property value of unique a mixed types
            mustBeListOfUniqueItems(org.digitalIdentifier)

            nonUniqueIdentifiers = [org.digitalIdentifier, org.digitalIdentifier(1)];
            testCase.verifyError(...
                @() mustBeListOfUniqueItems(nonUniqueIdentifiers), ...
                'OPENMINDS_MATLAB:PropertyValidator:MixedTypeInstancesMustBeUnique')
        end

        function testMustBeListOfUniqueItemsForStrings(testCase)

            % Should pass for list of unique string
            mustBeListOfUniqueItems({'a', 'b'})

            mustBeListOfUniqueItems(["a", "b"])

            testCase.verifyError(...
                @() mustBeListOfUniqueItems({'a', 'a'}), ...
                'OPENMINDS_MATLAB:PropertyValidator:ValuesMustBeUnique')

            testCase.verifyError(...
                @() mustBeListOfUniqueItems(["a", "a"]), ...
                'OPENMINDS_MATLAB:PropertyValidator:ValuesMustBeUnique')

            testCase.verifyError(...
                @() mustBeListOfUniqueItems(["a", "b", "a"]), ...
                'OPENMINDS_MATLAB:PropertyValidator:ValuesMustBeUnique')
        end

        function testMustBeListOfUniqueItemsForInstances(testCase)
            subjectA = openminds.core.Subject();
            subjectB = openminds.core.Subject();

            % Should pass for unique items
            mustBeListOfUniqueItems([subjectA, subjectB])

            testCase.verifyError(...
                @() mustBeListOfUniqueItems([subjectA, subjectA]), ...
                'OPENMINDS_MATLAB:PropertyValidator:ValuesMustBeUnique')
        end

        function testMustBeOneOf(testCase)
            % Verify that validator works for the different alias names
            mustBeOneOf(openminds.core.Person(), 'openminds.Person')
            mustBeOneOf(openminds.core.Person(), 'openminds.core.Person')
            mustBeOneOf(openminds.core.Person(), 'openminds.core.actors.Person')

            % Verify that validator works for lists of types 
            mustBeOneOf(...
                {openminds.core.Person(), openminds.core.Organization}, ...
                {'openminds.Person', 'openminds.Organization'})
            
            % Verify that validator fails is mismatch of given types and allowed types 
            testCase.verifyError( ...
                @() mustBeOneOf({openminds.core.Person(), openminds.core.Organization}, {'openminds.Person'}), ...
                'OPENMINDS_MATLAB:PropertyValidators:MustBeTypeOf')
        end

        function testMustBeSpecifiedLength(testCase)
            testValue = 1:5;
            
            % Test function when value exactly matches the required length
            mustBeSpecifiedLength(testValue, 1, 5)
            
            % Test function when value is inside the required length
            % interval
            mustBeSpecifiedLength(testValue, 0, 6)

            % Test function when value is too long
            testCase.verifyError(...
                @() mustBeSpecifiedLength(testValue, 1, 4), ...
                'OPENMINDS_MATLAB:PropertyValidators:ListIsTooLong')

            % Test function when value is too long
            testCase.verifyError(...
                @() mustBeSpecifiedLength(testValue, 10, 15), ...
                'OPENMINDS_MATLAB:PropertyValidators:ListIsTooShort')
        end

        function testMustBeValidEmail(testCase)
            mustBeValidEmail('eivihe@uio.no')

            testCase.verifyError(...
                @() mustBeValidEmail('eivihe@uio'), ...
                'OPENMINDS_MATLAB:PropertyValidators:InvalidEmail')
        end

        function testMustBeValidStringLength(testCase)
            testValue = "hello";
            
            % Test function when value exactly matches the required length
            mustBeValidStringLength(testValue, 1, 5)
            
            % Test function when value is inside the required length
            % interval
            mustBeValidStringLength(testValue, 0, 6)

            % Test function when value is too long
            testCase.verifyError(...
                @() mustBeValidStringLength(testValue, 1, 4), ...
                'OPENMINDS_MATLAB:PropertyValidators:InvalidStringLength')

            % Test function when value is too long
            testCase.verifyError(...
                @() mustBeValidStringLength(testValue, 10, 15), ...
                'OPENMINDS_MATLAB:PropertyValidators:InvalidStringLength')
        end

        function testMustBeValidTime(testCase)

            validTime = datetime(0,0,0,18,30,10);
            inValidTime =  datetime(2024,1,1,18,30,10);
            inValidTimeNoTime =  datetime(2024,1,1,0,0,0);


            % Test function when value is a valid time
            mustBeValidTime(validTime)

            % Test function when datetime contains a year
            testCase.verifyWarning(...
                @() mustBeValidTime(inValidTime), ...
                'OPENMINDS_MATLAB:PropertyValidators:InvalidTime')

            % Test function when there is no time info
            testCase.verifyWarning(...
                @() mustBeValidTime(inValidTimeNoTime), ...
                'OPENMINDS_MATLAB:PropertyValidators:InvalidTime')
        end
    end
end
