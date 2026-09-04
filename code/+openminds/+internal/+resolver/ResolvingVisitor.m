classdef ResolvingVisitor < openminds.base.Visitor
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

    properties (Access = private)
        % Link depth each visited node's edges were last expanded with,
        % keyed by identifier. A node reached again with more depth than
        % this has links that were skipped the first time. Created in the
        % constructor rather than as a default value, because a default
        % handle would be one map shared by every visitor.
        ExpandedWithDepth containers.Map
    end

    methods
        function obj = ResolvingVisitor(options)
            arguments
                options.RemainingLinkDepth (1,1) double {mustBeNonnegative, mustBeInteger} = 0
                options.LinkResolver = []
            end
            obj.ExpandedWithDepth = containers.Map('KeyType', 'char', 'ValueType', 'double');
            obj.RemainingLinkDepth = options.RemainingLinkDepth;
            obj.LinkResolver = options.LinkResolver;
        end

        function reset(obj)
            reset@openminds.internal.graph.TraversalCore(obj)
            obj.ExpandedWithDepth = containers.Map('KeyType', 'char', 'ValueType', 'double');
        end
    end

    methods (Access = protected)
        function node = onVisitNode(obj, node)
        % Resolve the node when it is an unresolved reference.

            obj.ExpandedWithDepth(obj.nodeKey(node)) = obj.RemainingLinkDepth;

            if ~node.isReference()
                return
            end

            referenceId = string(node.id);
            resolver = obj.selectResolver(node);
            node = resolver.resolveNode(node);

            % A resolver may return a new instance when the type of the
            % reference was not known. The new instance stands for the same
            % node, so it must carry the identifier of the reference: every
            % link to it is written with that identifier. A resolver that
            % drops it has a bug, and restoring the identifier here would
            % hide the bug rather than report it where it happens.
            if string(node.id) ~= referenceId
                error('openMINDS:LinkResolver:IdentityChanged', ...
                    ['Resolver "%s" returned an instance with identifier "%s" for ', ...
                     'the reference "%s". A resolver that builds a new instance ', ...
                     'must give it the identifier of the reference it resolves.'], ...
                    class(resolver), node.id, referenceId)
            end
            markResolved(node)
        end

        function node = onRevisitNode(obj, node)
        % Expand a node again when it is reached with more link depth than
        % it was expanded with, so links skipped for lack of depth along
        % one path are followed when another path has depth to spare.

            node = onRevisitNode@openminds.base.Visitor(obj, node);

            key = obj.nodeKey(node);
            if obj.RemainingLinkDepth > obj.ExpandedWithDepth(key)
                obj.ExpandedWithDepth(key) = obj.RemainingLinkDepth;
                obj.expandEdges(node);
            end
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
