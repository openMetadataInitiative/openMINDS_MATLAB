classdef (Abstract) Transformer < openminds.internal.graph.TraversalCore
% Transformer - Map each node of an instance graph to an output value
%
%   Subclass this for operations that build something from a graph rather
%   than modify it: serializing, exporting, converting between formats.
%   Each node is mapped to a representation, and the representations of
%   its children are composed into it.
%
%   USAGE:
%   ------
%   Implement how a node begins and what its children contribute:
%
%       classdef MyTransformer < openminds.base.Transformer
%           methods (Access = protected)
%               function result = beginNode(obj, node)
%                   result = struct('type', node.X_TYPE);
%               end
%               function values = doForLinkedEdge(obj, parentNode, propertyName, children)
%                   values = cellfun(@(c) c.id, children, 'UniformOutput', false);
%               end
%               function values = doForEmbeddedEdge(obj, parentNode, propertyName, children)
%                   values = cellfun(@(c) obj.transform(c), children, 'UniformOutput', false);
%               end
%           end
%       end
%
%   CYCLE SEMANTICS:
%   ----------------
%   A node is marked while its own subtree is being built and unmarked
%   afterwards, so meeting it again during that subtree is a cycle and is
%   represented by representRevisit. Meeting it again later, in a
%   different subtree, is not a cycle and is transformed normally.
%
%   This differs from openminds.base.Visitor, where a node is
%   visited at most once for the whole traversal. A visitor acts on each
%   node once; a transformer has to produce a value everywhere a node
%   appears.
%
%   See also openminds.base.Visitor, openminds.internal.graph.TraversalCore

    methods (Sealed)
        function result = transform(obj, node)
        % transform - Build the representation of a node and its children

            arguments
                obj (1,1) openminds.base.Transformer
                node (1,1) openminds.Node
            end

            if obj.wasVisited(node)
                % Already on the current path, so this closes a cycle
                result = obj.representRevisit(node);
                return
            end
            obj.markVisited(node);
            visitCleanup = onCleanup(@() obj.unmarkVisited(node));

            result = obj.beginNode(node);

            result = obj.composeEdges(result, node, ...
                obj.getLinkedEdges(node), @obj.doForLinkedEdge);
            result = obj.composeEdges(result, node, ...
                obj.getEmbeddedEdges(node), @obj.doForEmbeddedEdge);

            result = obj.endNode(node, result);
        end
    end

    methods (Abstract, Access = protected)
        result = beginNode(obj, node)
        % beginNode - Representation of a node before its children

        values = doForLinkedEdge(obj, parentNode, propertyName, children)
        % doForLinkedEdge - Representations of the children of a linked property

        values = doForEmbeddedEdge(obj, parentNode, propertyName, children)
        % doForEmbeddedEdge - Representations of the children of an embedded property
    end

    methods (Access = protected) % Overridable defaults
        function result = endNode(~, ~, result)
        % endNode - Finalize a node's representation after its children
        end

        function result = representRevisit(~, node)
        % representRevisit - Representation of a node already on the path
            result = struct('at_id', node.id);
        end

        function result = setPropertyValue(~, result, ~, propertyName, values)
        % setPropertyValue - Place child representations into the parent
        %
        %   The default writes the children as a list whatever their
        %   number, because a transformer knows nothing about the
        %   cardinality of a property. A format that distinguishes a
        %   single value from a list of one, as openMINDS JSON-LD does,
        %   overrides this to apply its rule.

            result.(propertyName) = values;
        end
    end

    methods (Access = private)
        function result = composeEdges(obj, result, node, edges, edgeFunction)
            for i = 1:numel(edges)
                propertyName = edges(i).PropertyName;
                values = edgeFunction(node, propertyName, edges(i).Children);
                result = obj.setPropertyValue(result, node, propertyName, values);
            end
        end
    end
end
