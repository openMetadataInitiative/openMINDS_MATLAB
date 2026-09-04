classdef (Abstract) TraversalCore < handle
% TraversalCore - Shared graph traversal primitives for openMINDS visitors
%
%   Provides the machinery every traversal of an instance graph needs:
%   enumerating the linked and embedded edges of a node, unwrapping mixed
%   type values, writing child values back to a property, and tracking
%   which nodes have been seen.
%
%   This exists because the same traversal was written three times, in the
%   serializer, in Schema.resolve and in loadInstances, each with its own
%   handling of mixed types and only one of them with cycle detection.
%
%   Subclasses define the traversal protocol on top of these primitives.
%   See openminds.base.Visitor for the side-effecting protocol and
%   openminds.base.Transformer for the accumulating one.

    properties (Access = private)
        % The node seen for each identifier so far, keyed by identifier.
        % What "seen" means is decided by the protocol built on top: a
        % visitor marks a node for the whole traversal, a transformer marks
        % it only while its own subtree is being processed. The node is
        % stored, not just its identifier, so a later reference to the same
        % identifier can be pointed at the object already visited for it.
        % Created in the constructor rather than as a default value,
        % because a default handle would be one map shared by every
        % instance.
        VisitedNodes containers.Map
    end

    methods
        function obj = TraversalCore()
            obj.VisitedNodes = containers.Map( ...
                'KeyType', 'char', 'ValueType', 'any');
        end

        function reset(obj)
        % reset - Forget which nodes have been seen
        %
        %   Call between independent traversals that share a visitor.

            obj.VisitedNodes = containers.Map( ...
                'KeyType', 'char', 'ValueType', 'any');
        end
    end

    methods (Access = protected)
        function edges = getLinkedEdges(obj, node)
        % getLinkedEdges - Edges of a node that point to linked instances
        %
        %   Returns a struct array with fields PropertyName and Children,
        %   where Children is a cell array of openMINDS instances.

            edges = obj.getEdges(node, fieldnames(node.LINKED_PROPERTIES));
        end

        function edges = getEmbeddedEdges(obj, node)
        % getEmbeddedEdges - Edges of a node that point to embedded instances

            edges = obj.getEdges(node, fieldnames(node.EMBEDDED_PROPERTIES));
        end

        function setEdgeChildren(~, node, propertyName, children)
        % setEdgeChildren - Write child instances back to a property
        %
        %   Assigning the property once, with the complete list, is what
        %   lets a traversal replace a child rather than only mutate it,
        %   and it keeps the remaining children in their original
        %   positions.

            arguments
                ~
                node (1,1) openminds.Node
                propertyName (1,1) string
                children cell
            end

            if isempty(children)
                node.(propertyName) = [];
                return
            end

            % Instances of one type go back as an object array. A mix of
            % types has to stay a cell array, which is what the mixed type
            % wrapper for the property expects.
            childClasses = cellfun(@class, children, 'UniformOutput', false);
            if isscalar(unique(childClasses))
                node.(propertyName) = [children{:}];
            else
                node.(propertyName) = children;
            end
        end

        function tf = wasVisited(obj, node)
            tf = obj.VisitedNodes.isKey(obj.nodeKey(node));
        end

        function markVisited(obj, node)
        % markVisited - Record node as the object standing for its identifier
            obj.VisitedNodes(obj.nodeKey(node)) = node;
        end

        function node = visitedNode(obj, node)
        % visitedNode - The object already visited for this node's identifier
            node = obj.VisitedNodes(obj.nodeKey(node));
        end

        function unmarkVisited(obj, node)
            key = obj.nodeKey(node);
            if obj.VisitedNodes.isKey(key)
                obj.VisitedNodes.remove(key);
            end
        end
    end

    methods (Access = private)
        function edges = getEdges(obj, node, propertyNames)
        % getEdges - Collect the non-empty edges for a set of properties

            edges = struct('PropertyName', {}, 'Children', {});

            for i = 1:numel(propertyNames)
                propertyName = string(propertyNames{i});
                children = obj.getChildren(node, propertyName);
                if isempty(children)
                    continue
                end
                edges(end+1) = struct( ...
                    'PropertyName', propertyName, ...
                    'Children', {children}); %#ok<AGROW>
            end
        end

        function children = getChildren(~, node, propertyName)
        % getChildren - Property value as a cell array of instances
        %
        %   Mixed type values are containers rather than instances, so the
        %   instance is taken out of each element.

            children = {};
            value = node.(propertyName);

            if isempty(value)
                return
            end

            if openminds.utility.isMixedInstance(value)
                children = arrayfun(@(element) element.Instance, value, ...
                    'UniformOutput', false);
            elseif openminds.utility.isInstance(value)
                children = num2cell(value);
            end
        end
    end

    methods (Static, Access = protected)
        function key = nodeKey(node)
            key = char(node.id);
        end
    end
end
