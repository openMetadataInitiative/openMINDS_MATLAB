classdef (Abstract) LinkResolver < handle
% LinkResolver - Turns a reference node into a populated instance
%
%   A resolver knows how to fetch the data behind one kind of identifier.
%   It does not walk the graph: traversal, link depth and cycle detection
%   belong to openminds.internal.resolver.ResolvingVisitor, which selects
%   a resolver for each reference it meets. That separation matters
%   because one graph can hold references from several sources, and no
%   single resolver can handle all of them.
%
%   Concrete implementations must provide:
%       - IRIPrefix   A constant naming the resolver in the registry,
%                     which keeps at most one resolver per prefix. It is
%                     not consulted when matching an identifier; that is
%                     what canResolve is for.
%       - canResolve  Whether it can handle one given identifier
%       - resolveNode Fetch or populate a single reference node
%
%   RESOLVING IN PLACE OR BY REPLACEMENT:
%   -------------------------------------
%   resolveNode returns the resolved instance, and callers must use the
%   returned value rather than assuming the argument was modified.
%
%   A reference whose type is known can be populated in place, and
%   returning it unchanged is correct. A reference whose type is not known
%   until it is probed cannot be, because an instance cannot change its
%   class: the resolver has to build an instance of the discovered type
%   and return that instead. Both are legitimate, and which one applies is
%   a property of the reference rather than of the resolver.
%
%   See also openminds.internal.resolver.ResolvingVisitor, openminds.registerLinkResolver

    properties (Constant, Abstract)
        IRIPrefix (1,1) string
    end

    methods (Abstract)
        instance = resolveNode(obj, instance)
        % resolveNode - Fetch or populate a single reference node

        tf = canResolve(obj, IRI)
        % canResolve - Whether this resolver handles the given identifier
        %
        %   IRI is one identifier, a scalar string, and tf a scalar logical.
    end
end
