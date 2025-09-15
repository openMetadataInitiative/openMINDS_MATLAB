classdef (Abstract) AbstractLinkResolver < handle
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
end
