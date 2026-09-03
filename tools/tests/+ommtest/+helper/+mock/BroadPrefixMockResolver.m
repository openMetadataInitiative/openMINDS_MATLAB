classdef BroadPrefixMockResolver < openminds.interface.LinkResolver
%BroadPrefixMockResolver Handles every identifier under one host
%
%   Paired with NarrowPrefixMockResolver, whose prefix lies inside this
%   one, to exercise resolver selection when prefixes overlap.

    properties (Constant)
        IRIPrefix = "https://overlap.mock/"
    end

    methods
        function instance = resolveNode(~, instance)
            % Selection is what is under test; the node is left as it is.
        end

        function tf = canResolve(~, IRI)
            arguments
                ~
                IRI (1,1) string
            end
            tf = startsWith(IRI, ommtest.helper.mock.BroadPrefixMockResolver.IRIPrefix);
        end
    end
end
