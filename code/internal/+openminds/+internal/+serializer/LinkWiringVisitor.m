classdef LinkWiringVisitor < openminds.base.Visitor
% LinkWiringVisitor - Replaces reference stubs with the instances they name
%
%   After a document is parsed, each node is built on its own and its
%   linked properties hold stubs carrying an identifier and nothing else.
%   This visitor walks the instances and swaps each stub for the instance
%   with that identifier, so the separate nodes of a document become one
%   connected graph.
%
%   A stub naming a controlled instance that is not part of the document
%   is resolved from the local instance library instead.
%
%   See also openminds.base.Deserializer

    properties (Access = private)
        % Identifier to instance, for everything in the document
        InstancesById containers.Map
    end

    methods
        function obj = LinkWiringVisitor(instances)
            arguments
                instances cell
            end

            obj.InstancesById = containers.Map( ...
                'KeyType', 'char', 'ValueType', 'any');

            for i = 1:numel(instances)
                obj.InstancesById(char(instances{i}.id)) = instances{i};
            end
        end
    end

    methods (Access = protected)
        function children = doForLinkedEdge(obj, ~, ~, children)
            for i = 1:numel(children)
                children{i} = obj.wireChild(children{i});
                children{i} = obj.visit(children{i});
            end
        end

        function children = doForEmbeddedEdge(obj, ~, ~, children)
        % An embedded instance is written inline, so it is never a stub.
        % It can still hold stubs of its own.

            for i = 1:numel(children)
                children{i} = obj.visit(children{i});
            end
        end
    end

    methods (Access = private)
        function child = wireChild(obj, child)
        % wireChild - Swap a stub for the instance it names

            if ~child.isReference()
                return
            end

            identifier = char(child.id);

            if obj.InstancesById.isKey(identifier)
                child = obj.InstancesById(identifier);
                return
            end

            % Not part of the document. A controlled instance can still be
            % resolved from the local library; anything else stays a stub
            % for the caller to resolve.
            if openminds.utility.isInstanceIRI(child.id)
                child = openminds.instanceFromIRI(child.id);
            end
        end
    end
end
