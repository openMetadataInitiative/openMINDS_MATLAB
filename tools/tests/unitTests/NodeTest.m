classdef NodeTest < matlab.unittest.TestCase
% NodeTest - Unit tests for the behaviour openminds.Node gives every type
%
%   The generated type classes are exercised by InstanceTest. This file
%   covers what Node itself does, using fixtures where no generated type
%   can produce the case.
%
%   See also openminds.Node, ommtest.helper.UntypedLinkNodeFixture

    methods (Test) % Indexing a linked property across an array

        function testLinkedValuesOfOneTypeConcatenate(testCase)
        % Indexing a linked property on an array of nodes returns the
        % values as one array, as it does for a plain property.

            nodes = [ ...
                ommtest.helper.UntypedLinkNodeFixture( ...
                    "link", openminds.core.Person("givenName", "Ada")), ...
                ommtest.helper.UntypedLinkNodeFixture( ...
                    "link", openminds.core.Person("givenName", "Grace"))];

            values = nodes.link;

            testCase.verifyClass(values, 'openminds.core.actors.Person')
            testCase.assertNumElements(values, 2)
            testCase.verifyEqual(values(1).givenName, "Ada")
            testCase.verifyEqual(values(2).givenName, "Grace")
        end

        function testLinkedValuesOfDifferentTypesIsAnError(testCase)
        % Values of different types cannot be concatenated into one
        % array. The error must say so, rather than fail on the way to
        % saying it.

            nodes = [ ...
                ommtest.helper.UntypedLinkNodeFixture( ...
                    "link", openminds.core.Person("givenName", "Ada")), ...
                ommtest.helper.UntypedLinkNodeFixture( ...
                    "link", openminds.core.ContactInformation("email", "ada@example.org"))];

            testCase.verifyError(@() nodes.link, ...
                'openMINDS:Node:HeterogeneousLinkedValues')
        end
    end
end
