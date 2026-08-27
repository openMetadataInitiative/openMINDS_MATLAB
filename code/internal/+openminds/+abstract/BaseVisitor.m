classdef (Abstract) BaseVisitor < openminds.internal.graph.TraversalCore
% BaseVisitor - Walk an instance graph and act on each node
%
%   Subclass this for operations that inspect or modify an instance graph
%   in place: resolving references, wiring up links after deserialization,
%   validating. Each node is visited at most once per traversal, so a
%   circular graph terminates.
%
%   USAGE:
%   ------
%   Implement the two edge methods. Each receives the parent node, the
%   name of the property the edge belongs to, and the child instances on
%   it, and returns the child instances to keep:
%
%       classdef MyVisitor < openminds.abstract.BaseVisitor
%           methods (Access = protected)
%               function children = doForLinkedEdge(obj, parentNode, propertyName, children)
%                   for i = 1:numel(children)
%                       children{i} = obj.visit(children{i});
%                   end
%               end
%               function children = doForEmbeddedEdge(obj, parentNode, propertyName, children)
%                   ...
%               end
%           end
%       end
%
%   Edges rather than nodes are the unit of work because a child cannot
%   always be updated in place. A reference whose type is not known until
%   it is probed has to be replaced by a new instance of the discovered
%   type, and replacing it needs the parent, the property and the position
%   in the property. Returning the child list also keeps the remaining
%   children in their original positions.
%
%   See also openminds.internal.graph.TraversalCore

    methods (Sealed)
        function node = visit(obj, node)
        % visit - Traverse a node and everything reachable from it
        %
        %   The node is returned because visiting it may replace it. A
        %   caller holding the node directly, rather than through a
        %   property of a parent, has to take the returned value.

            arguments
                obj (1,1) openminds.abstract.BaseVisitor
                node (1,1) openminds.abstract.Schema
            end

            if obj.wasVisited(node)
                return
            end
            obj.markVisited(node);

            node = obj.onVisitNode(node);

            obj.traverseEdges(node, obj.getLinkedEdges(node), @obj.doForLinkedEdge);
            obj.traverseEdges(node, obj.getEmbeddedEdges(node), @obj.doForEmbeddedEdge);

            obj.onLeaveNode(node);
        end
    end

    methods (Abstract, Access = protected)
        children = doForLinkedEdge(obj, parentNode, propertyName, children)
        % doForLinkedEdge - Act on the children of a linked property

        children = doForEmbeddedEdge(obj, parentNode, propertyName, children)
        % doForEmbeddedEdge - Act on the children of an embedded property
    end

    methods (Access = protected) % Optional hooks
        function node = onVisitNode(~, node)
        % onVisitNode - Act on a node before its edges are traversed
        %
        %   Return a different instance to replace the node.
        end

        function onLeaveNode(~, ~)
        % onLeaveNode - Act on a node after its edges have been traversed
        end
    end

    methods (Access = private)
        function traverseEdges(obj, node, edges, edgeFunction)
        % traverseEdges - Apply an edge method to each edge and store the result

            for i = 1:numel(edges)
                propertyName = edges(i).PropertyName;
                children = edgeFunction(node, propertyName, edges(i).Children);
                obj.setEdgeChildren(node, propertyName, children);
            end
        end
    end
end
