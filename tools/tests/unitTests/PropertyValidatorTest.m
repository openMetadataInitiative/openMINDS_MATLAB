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
    end
end
