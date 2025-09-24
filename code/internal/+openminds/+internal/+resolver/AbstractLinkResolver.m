classdef (Abstract) AbstractLinkResolver < handle & matlab.mixin.Heterogeneous
% AbstractLinkResolver - Abstract pattern for a LinkResolver class
%
%   Concrete implementations must implement these methods
%       - canResolve - Whether the class can resolve a given IRI
%       - resolve - Return an resolved instance given an IRI

    properties (Constant, Abstract)
        IRIPrefix (1,1) string
    end

    methods (Static, Abstract)
        instance = resolve(IRI, options)

        tf = canResolve(IRI)
    end

    methods(Sealed)
        function tf = eq(obj, resolver)
            if isempty(obj)
                tf = isempty(resolver);
            else
                tf = arrayfun(@(x) isequal(x, resolver), obj) | ...
                        strcmp([obj.IRIPrefix], resolver.IRIPrefix);
            end
        end
    end
end
