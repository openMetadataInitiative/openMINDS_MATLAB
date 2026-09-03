classdef NarrowPrefixMockResolver < openminds.interface.LinkResolver
%NarrowPrefixMockResolver Handles identifiers under one path of a host
%
%   Its prefix lies inside that of BroadPrefixMockResolver, so both can
%   resolve the identifiers this one is registered for.

    properties (Constant)
        IRIPrefix = "https://overlap.mock/narrow/"
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
            tf = startsWith(IRI, ommtest.helper.mock.NarrowPrefixMockResolver.IRIPrefix);
        end
    end
end
