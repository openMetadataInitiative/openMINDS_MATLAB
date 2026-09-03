classdef ContentTypeMockResolver < openminds.interface.LinkResolver
%ContentTypeMockResolver Populates ContentType references with a fixed name
%
%   ContentType links to its own type through isBasedOn, so a graph of any
%   shape can be built from one type and resolved with this resolver.

    properties (Constant)
        IRIPrefix = "https://contenttype.mock/"
    end

    methods
        function instance = resolveNode(~, instance)
            if isa(instance, 'openminds.core.data.ContentType')
                instance.name = "resolved";
            end
        end

        function tf = canResolve(~, IRI)
            arguments
                ~
                IRI (1,1) string
            end
            tf = startsWith(IRI, ommtest.helper.mock.ContentTypeMockResolver.IRIPrefix);
        end
    end
end
