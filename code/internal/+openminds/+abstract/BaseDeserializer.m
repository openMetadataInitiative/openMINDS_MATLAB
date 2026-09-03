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
%       classdef MyDeserializer < openminds.abstract.BaseDeserializer
%           methods (Access = protected)
%               function rawStructs = parseToStructs(obj, data)
%                   ...
%               end
%           end
%       end
%
%   See also openminds.abstract.BaseSerializer,
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
            [instances, unreadable, dropped] = obj.instantiateAll(rawStructs);

            obj.reportUnreadableNodes(unreadable);
            obj.reportDroppedProperties(dropped);

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
        function [instances, unreadable, dropped] = instantiateAll(~, rawStructs)
        % instantiateAll - Build one instance per node of the document
        %
        %   Also returns the nodes that could not be read, and the nodes
        %   that carried properties the active model does not have. A node
        %   whose identifier an earlier node already carries is not read:
        %   two nodes cannot both be the target of one link, and the
        %   earlier one is kept.

            instances = cell(1, numel(rawStructs));
            unreadable = struct('Identifier', {}, 'Reason', {});
            dropped = struct('Identifier', {}, 'Properties', {});
            seenIdentifiers = strings(1, 0);

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
                identifier = openminds.internal.utility.getStructIdentifier(node);
                if identifier ~= "" && any(seenIdentifiers == identifier)
                    unreadable(end+1) = struct( ...
                        'Identifier', identifier, ...
                        'Reason', "an earlier node carries the same identifier and is the one kept"); %#ok<AGROW>
                    continue
                end

                typeEnum = openminds.enum.Types.fromAtType(node.at_type);

                try
                    instances{i} = feval(typeEnum.ClassName, node);
                    seenIdentifiers(end+1) = identifier; %#ok<AGROW>
                    droppedNames = droppedPropertyNames(node, instances{i});
                    if ~isempty(droppedNames)
                        dropped(end+1) = struct( ...
                            'Identifier', nodeIdentifier(node), ...
                            'Properties', {droppedNames}); %#ok<AGROW>
                    end
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

        function reportDroppedProperties(~, dropped)
        % reportDroppedProperties - Report properties the active model does not have
        %
        %   A document written for another model version can carry
        %   properties this version lacks. They cannot be kept, and losing
        %   them silently would hide that the document was not read in
        %   full, so they are reported once, by node. This is a warning
        %   whatever the unreadable-node policy: the nodes themselves were
        %   read.

            if isempty(dropped)
                return
            end

            details = arrayfun( ...
                @(entry) sprintf('  %s: %s', entry.Identifier, strjoin(entry.Properties, ', ')), ...
                dropped, 'UniformOutput', false);

            warning('openMINDS:Deserializer:DroppedProperties', ...
                ['%d of the nodes in the data carry properties that version "%s" ', ...
                'of the openMINDS model does not have. They were dropped:\n%s'], ...
                numel(dropped), openminds.getModelVersion(), strjoin(details, newline))
        end
    end
end

function names = droppedPropertyNames(node, instance)
% Fields of a decoded node that the instance's type does not declare.
%
%   fromStruct keeps the fields that name a property of the type and
%   drops the rest without a report. This mirrors that filter so the
%   deserializer can say what was lost. Only the node itself is checked;
%   fields dropped inside embedded values are not detected.

    fields = string(fieldnames(node))';
    known = [string(instance.PropertyNames), ...
        openminds.internal.utility.jsonLdKeywordFields()];
    names = setdiff(fields, known, 'stable');
end

function identifier = nodeIdentifier(node)
% Best available name for a node that could not be read.

    identifier = openminds.internal.utility.getStructIdentifier(node);
    if identifier == ""
        identifier = "<node without an identifier>";
    end
end
