classdef (Abstract) BaseDeserializer < handle
% BaseDeserializer - Turns serialized data into linked openMINDS instances
%
%   The counterpart to BaseSerializer. Subclasses implement parseToStructs
%   for one serialization format; this class provides the parts that do
%   not depend on the format: dispatching each node to its type, building
%   the instances, and wiring the references between them.
%
%   USAGE:
%   ------
%   Subclasses implement one method:
%
%       classdef MyDeserializer < openminds.internal.serializer.BaseDeserializer
%           methods (Access = protected)
%               function rawStructs = parseToStructs(obj, data)
%                   ...
%               end
%           end
%       end
%
%   See also openminds.internal.serializer.BaseSerializer,
%   openminds.internal.serializer.LinkWiringVisitor

    properties (Access = protected)
        % What to do with nodes that cannot be turned into instances. Every
        % such node is collected while the document is read and reported
        % once at the end. "warning" then returns the readable nodes;
        % "error" throws, so the caller gets nothing rather than a partial
        % document.
        UnreadableNodePolicy (1,1) string ...
            {mustBeMember(UnreadableNodePolicy, ["warning", "error"])} = "warning"
    end

    methods
        function instances = deserialize(obj, data)
        % deserialize - Build linked instances from serialized data
        %
        %   Returns a cell array of openMINDS instances. Nodes that cannot
        %   be read are left out and reported.

            rawStructs = obj.parseToStructs(data);
            [instances, unreadable] = obj.instantiateAll(rawStructs);

            obj.reportUnreadableNodes(unreadable);

            if isempty(instances)
                return
            end

            visitor = openminds.internal.serializer.LinkWiringVisitor(instances);
            for i = 1:numel(instances)
                visitor.visit(instances{i});
            end
        end
    end

    methods (Abstract, Access = protected)
        rawStructs = parseToStructs(obj, data)
        % parseToStructs - Format-specific parse into a cell array of structs
    end

    methods (Access = protected)
        function [instances, unreadable] = instantiateAll(~, rawStructs)
        % instantiateAll - Build one instance per node of the document

            instances = cell(1, numel(rawStructs));
            unreadable = struct('Identifier', {}, 'Reason', {});

            for i = 1:numel(rawStructs)
                node = rawStructs{i};

                if ~isfield(node, 'at_type')
                    unreadable(end+1) = struct( ...
                        'Identifier', nodeIdentifier(node), ...
                        'Reason', "the node has no @type"); %#ok<AGROW>
                    continue
                end

                % Resolving the type is deliberately outside the try. A
                % type in an unknown namespace means the whole document
                % was written for a different model version, which is a
                % document-level problem rather than one bad node, and
                % reporting it as a skipped node would leave the caller
                % with an empty result and a warning.
                typeEnum = openminds.enum.Types.fromAtType(node.at_type);

                try
                    instances{i} = feval(typeEnum.ClassName, node);
                catch ME
                    unreadable(end+1) = struct( ...
                        'Identifier', nodeIdentifier(node), ...
                        'Reason', string(ME.message)); %#ok<AGROW>
                end
            end

            instances = instances(~cellfun(@isempty, instances));
        end

        function reportUnreadableNodes(obj, unreadable)
        % reportUnreadableNodes - Report every node that had to be skipped
        %
        %   Reporting once, with the identifier of each node, makes it
        %   possible to tell how much of a document was lost. Reporting
        %   each node separately as it failed buried that.

            if isempty(unreadable)
                return
            end

            details = arrayfun( ...
                @(entry) sprintf('  %s: %s', entry.Identifier, entry.Reason), ...
                unreadable, 'UniformOutput', false);

            message = sprintf('%d of the nodes in the data could not be read:\n%s', ...
                numel(unreadable), strjoin(details, newline));

            if obj.UnreadableNodePolicy == "error"
                error('openMINDS:Deserializer:UnreadableNodes', '%s', message)
            else
                warning('openMINDS:Deserializer:UnreadableNodes', '%s', message)
            end
        end
    end
end

function identifier = nodeIdentifier(node)
% Best available name for a node that could not be read.

    identifier = openminds.internal.utility.getStructIdentifier(node);
    if identifier == ""
        identifier = "<node without an identifier>";
    end
end
