classdef CyclicMockLinkResolver < openminds.interface.LinkResolver
%CyclicMockLinkResolver Resolves two ContentType references that link to each other
%
%   Resolving the node "a" links it to a reference "b", and resolving "b"
%   links it back to a reference "a". The cycle exists only as references
%   and is closed by resolution.

    properties (Constant)
        IRIPrefix = "https://cycle.mock/"
    end

    methods
        function instance = resolveNode(obj, instance)
            name = extractAfter(string(instance.id), obj.IRIPrefix);
            if name == "a"
                partner = "b";
            else
                partner = "a";
            end
            instance.name = name;
            instance.isBasedOn = openminds.core.data.ContentType('id', obj.IRIPrefix + partner);
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
