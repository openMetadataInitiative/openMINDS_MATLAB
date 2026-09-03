classdef IdentityDroppingMockLinkResolver < openminds.interface.LinkResolver
%IdentityDroppingMockLinkResolver A resolver with a bug: its replacement has no identifier
%
%   Replaces a reference with a new instance that does not carry the
%   reference's identifier, which the resolving visitor must reject.

    properties (Constant)
        IRIPrefix = "https://dropping.mock/"
    end

    methods
        function instance = resolveNode(~, ~)
            instance = openminds.core.Person();
            instance.givenName = "Anonymous";
        end

        function tf = canResolve(obj, IRI)
            arguments
                obj
                IRI (1,1) string
            end
            tf = startsWith(IRI, obj.IRIPrefix);
        end
    end
end
