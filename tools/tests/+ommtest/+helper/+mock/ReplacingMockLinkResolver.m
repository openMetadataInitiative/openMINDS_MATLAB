classdef ReplacingMockLinkResolver < openminds.interface.LinkResolver
%ReplacingMockLinkResolver Resolver that replaces rather than populates
%
%   Mirrors the case where the type behind an identifier is not known
%   until it is probed. Such a reference cannot be populated in place,
%   because an instance cannot change its class, so the resolver builds an
%   instance of the discovered type and returns that instead.

    properties (Constant)
        IRIPrefix = "https://replacing.mock/"
    end

    properties (SetAccess = private)
        % Identifiers this resolver was asked to resolve, in order.
        ResolvedIdentifiers (1,:) string = string.empty
    end

    methods
        function instance = resolveNode(obj, instance)
            obj.ResolvedIdentifiers(end+1) = string(instance.id);

            % Built from a record carrying the reference's identifier, as a
            % resolver reading a store would do, so the replacement stands
            % for the same node.
            instance = openminds.core.Person(struct( ...
                'at_id', char(instance.id), ...
                'givenName', "Replaced", ...
                'familyName', "Instance"));
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
