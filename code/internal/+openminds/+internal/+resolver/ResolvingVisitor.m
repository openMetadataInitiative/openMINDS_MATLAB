classdef ResolvingVisitor < openminds.abstract.BaseVisitor
% ResolvingVisitor - Resolves the reference nodes of an instance graph
%
%   Walks an instance graph and replaces reference nodes, which carry an
%   identifier and nothing else, with populated instances. A resolver is
%   selected for each reference from the resolver registry, so one graph
%   may hold references from several sources.
%
%   Following a link spends one unit of link depth. Descending into an
%   embedded instance does not, because an embedded instance is part of
%   its parent rather than a separate node.
%
%   See also openminds.interface.LinkResolver

    properties
        % Number of further links to follow.
        RemainingLinkDepth (1,1) double {mustBeNonnegative, mustBeInteger} = 0

        % Resolver to use instead of consulting the registry. Empty means
        % a resolver is selected per reference.
        LinkResolver = []
    end

    methods
        function obj = ResolvingVisitor(options)
            arguments
                options.RemainingLinkDepth (1,1) double {mustBeNonnegative, mustBeInteger} = 0
                options.LinkResolver = []
            end
            obj.RemainingLinkDepth = options.RemainingLinkDepth;
            obj.LinkResolver = options.LinkResolver;
        end
    end

    methods (Access = protected)
        function node = onVisitNode(obj, node)
        % Resolve the node when it is an unresolved reference.

            if ~node.isUnresolved()
                return
            end

            resolver = obj.selectResolver(node);
            node = resolver.resolveNode(node);
            markResolved(node)
        end

        function children = doForLinkedEdge(obj, ~, ~, children)
        % Following a link costs one unit of depth.

            if obj.RemainingLinkDepth == 0
                return
            end

            obj.RemainingLinkDepth = obj.RemainingLinkDepth - 1;
            depthCleanup = onCleanup(@() obj.restoreLinkDepth());

            for i = 1:numel(children)
                children{i} = obj.visit(children{i});
            end
        end

        function children = doForEmbeddedEdge(obj, ~, ~, children)
        % An embedded instance is part of its parent, so descending into it
        % does not spend link depth.

            for i = 1:numel(children)
                children{i} = obj.visit(children{i});
            end
        end
    end

    methods (Access = private)
        function resolver = selectResolver(obj, node)
            if ~isempty(obj.LinkResolver)
                resolver = obj.LinkResolver;
                return
            end
            resolver = openminds.internal.getLinkResolver(node.id);
        end

        function restoreLinkDepth(obj)
            obj.RemainingLinkDepth = obj.RemainingLinkDepth + 1;
        end
    end
end
