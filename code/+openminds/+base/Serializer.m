classdef (Abstract) Serializer < openminds.base.Transformer
% Serializer - Abstract base class for openMINDS serialization
%
%   This class provides the core serialization logic for openMINDS
%   instances, handling linked and embedded types according to openMINDS
%   specifications. Concrete subclasses implement format-specific output.
%
%   Serialization is a fold over the instance graph: each instance is
%   mapped to a document representation, and the representations of its
%   children are composed into it. That protocol lives in
%   openminds.base.Transformer; this class adds the openMINDS
%   rules on top of it.
%
%   Linked instances are always written as references and queued to be
%   emitted as documents of their own, subject to the configured recursion
%   depth. Embedded instances are written inline and carry no identifier.
%
%   USAGE:
%   ------
%   % Subclass must implement formatOutput method
%   classdef JsonLdSerializer < openminds.base.Serializer
%       methods
%           function result = formatOutput(obj, processedStruct, config)
%               result = jsonencode(processedStruct);
%           end
%       end
%   end
%
%   ABSTRACT METHODS:
%   -----------------
%   formatOutput - Convert processed struct to final output format

    properties (Access = protected, Dependent)
        NamespaceIRI
        DefaultVocabularyIRI
    end

    properties (Abstract, Access = public, Constant)
        DefaultFileExtension string  % Default file extension when storing this format (e.g., ".jsonld")
    end

    properties (Access = protected)
        SerializationConfiguration openminds.internal.serializer.SerializationConfig
    end

    methods (Abstract, Access = protected) % Subclass must implement
        result = formatOutput(obj, processedStruct)
        % formatOutput Convert processed struct to final output format
        %
        %   result = formatOutput(obj, processedStruct, config)
        %   converts the processed struct (with openMINDS-specific
        %   fields added) to the final output format.
        %
        %   PARAMETERS:
        %   -----------
        %   processedStruct : struct or cell array of structs
        %       Struct(s) with openMINDS fields (@type, @id, etc.) added
        %   config : SerializationConfig
        %       Configuration object for serialization
        %
        %   RETURNS:
        %   --------
        %   result : any
        %       Final serialized output in the target format
    end

    methods (Access = protected) % Subclass can implement
        function allStructs = postProcessDocuments(obj, allStructs) %#ok<INUSD>
            % Subclass can implement
        end
    end
    
    methods % Constructor
        function obj = Serializer(config)
            arguments
                config.?openminds.internal.serializer.SerializationConfig
            end

            obj.SerializationConfiguration = ...
                openminds.internal.serializer.SerializationConfig.fromStruct(config);
        end
    end

    methods
        function result = serialize(obj, instances)
        %serialize Main entry point for serialization
        %
        %   result = serialize(obj, instances, config) serializes one or
        %   more openMINDS instances according to the provided configuration
        %
        %   PARAMETERS:
        %   -----------
        %   instances : openminds.Node or cell array
        %       Instance(s) to serialize
        %
        %   RETURNS:
        %   --------
        %   result : any
        %       Serialized output in the format specified by the subclass
            
            arguments
                obj (1,1) openminds.base.Serializer
                instances % openminds.Node or cell array
            end
            
            % Process instances to add openMINDS-specific fields and collect
            % linked instances
            processedStructs = obj.buildDocuments(instances);
            
            processedStructs = obj.postProcessDocuments(processedStructs);
            
            % Delegate to subclass for format-specific output
            result = obj.formatOutput(processedStructs);
        end
    end

    methods (Access = protected) % Subclass can override
        function S = addOpenMindsType(~, S, instance)
        % addOpenMindsType - Add type to structure representation
            arguments
                ~ % This method does not use obj
                S (1,1) struct
                instance (1,1) openminds.Node
            end
            S.at_type = instance.X_TYPE; % Add @type (always required)
        end

        function S = addInstanceIdentifier(~, S, instance)
        % addInstanceIdentifier - Add identifier to structure representation
            arguments
                ~ % This method does not use obj
                S (1,1) struct
                instance (1,1) openminds.Node
            end
            S.at_id = instance.id;
        end

        function references = createReferences(~, instances)
        %createReferences Create reference structs for instances
        %
        %   references = createReferences(obj, instances)
        %   creates structs containing only @id fields for the instances

            arguments
                ~ % This method does not use obj
                instances (1,:) openminds.Node
            end

            references = arrayfun(@(instance) struct('at_id', instance.id), ...
                instances, 'UniformOutput', false);
        end
    end

    methods (Sealed, Access = protected) % Subclass can not override
        function tf = isEmptyPropertyValue(~, propertyValue)
            tf = false;
            if isempty(propertyValue)
                tf = true;
            elseif isstring(propertyValue) && isscalar(propertyValue)
                if propertyValue=="" || ismissing(propertyValue)
                    tf = true;
                end
            elseif isdatetime(propertyValue) && isnat(propertyValue)
                tf = true;
            end
        end
    end

    properties (Access = private)
        % Instances that were referenced and still have to be emitted as
        % documents of their own, with the depth at which they were found.
        PendingDocuments cell = {}

        % Identifiers of instances already emitted, so an instance
        % referenced from several places is written once. Created when
        % serialization starts rather than as a default value, because a
        % handle default would be shared by every instance.
        EmittedIdentifiers

        % Depth of the document currently being built.
        CurrentDepth (1,1) double = 0
    end

    methods (Access = protected) % Transformer implementation
        function result = setPropertyValue(~, result, node, propertyName, values)
        % openMINDS writes a property by its cardinality: a property that
        % holds at most one value is written as a single object, and a
        % property that can hold several is written as a list even when
        % it holds one. The schema declares the cardinality, the generated
        % classes carry it as a scalar validator, and the reference
        % implementation and the official instance library both follow it.

            metaType = openminds.meta.fromInstance(node);

            isSingleValue = metaType.isPropertyValueScalar(propertyName) ...
                && isscalar(values);

            if isSingleValue
                result.(propertyName) = values{1};
            else
                result.(propertyName) = values;
            end
        end

        function S = beginNode(obj, instance)
        % Start from the instance's own property values.

            S = instance.toStruct();
            S = obj.formatDateTimeProperties(S, instance);
            S = obj.listMultiValuedPrimitives(S, instance);

            if ~obj.SerializationConfiguration.IncludeEmptyProperties
                S = obj.removeEmptyProperties(S);
            end

            S = obj.addOpenMindsType(S, instance);

            if obj.SerializationConfiguration.IncludeIdentifier
                S = obj.addInstanceIdentifier(S, instance);
            end
        end

        function S = formatDateTimeProperties(~, S, instance)
        % A datetime is written as ISO 8601 text, as a date or a date-time
        % according to the schema. Left to itself, encoding would use the
        % datetime display format, which the reference implementation
        % cannot read and which drops the time zone.

            metaType = openminds.meta.fromInstance(instance);

            for propertyName = string(fieldnames(S))'
                value = S.(propertyName);
                if ~isdatetime(value) || isempty(value) || all(isnat(value))
                    continue
                end

                S.(propertyName) = openminds.internal.utility.formatIsoDateTime( ...
                    value, DateOnly=metaType.isPropertyDateOnly(propertyName));
            end
        end

        function S = listMultiValuedPrimitives(~, S, instance)
        % A property that can hold several values is written as a list
        % even when it holds one, as the reference implementation and the
        % instance library do. Linked and embedded values get this from
        % setPropertyValue; a primitive value comes straight from the
        % instance and would otherwise encode as a scalar.

            metaType = openminds.meta.fromInstance(instance);

            for propertyName = string(fieldnames(S))'
                value = S.(propertyName);
                isPrimitive = isstring(value) || isnumeric(value) || islogical(value);
                if ~isPrimitive || ~isscalar(value)
                    continue
                end

                if ~metaType.isPropertyValueScalar(propertyName)
                    S.(propertyName) = {value}; % A cell encodes as a list
                end
            end
        end

        function values = doForLinkedEdge(obj, ~, ~, children)
        % A linked instance is always a reference. The instance itself is
        % queued so it can be emitted as a document of its own.

            % Each child is referenced on its own rather than through one
            % concatenated array, because a property may hold instances of
            % several types and those cannot be concatenated.
            values = cell(1, numel(children));

            for i = 1:numel(children)
                reference = obj.createReferences(children{i});
                values{i} = reference{1};
                obj.enqueueDocument(children{i});
            end
        end

        function values = doForEmbeddedEdge(obj, ~, ~, children)
        % An embedded instance is written inline and has no identifier of
        % its own, because it is part of its parent rather than a node.

            values = cell(1, numel(children));
            for i = 1:numel(children)
                values{i} = obj.transform(children{i});
                if isfield(values{i}, 'at_id')
                    values{i} = rmfield(values{i}, 'at_id');
                end
            end
        end
    end

    methods (Access = private)
        function processedStructs = buildDocuments(obj, instances)
        % Build a document for each instance, then for everything they
        % reference, as far as the configured recursion depth allows.

            if ~iscell(instances)
                instances = num2cell(instances);
            end

            obj.reset()
            obj.PendingDocuments = {};
            obj.EmittedIdentifiers = containers.Map( ...
                'KeyType', 'char', 'ValueType', 'logical');

            processedStructs = cell(1, numel(instances));
            for i = 1:numel(instances)
                obj.CurrentDepth = 0;
                obj.EmittedIdentifiers(char(instances{i}.id)) = true;
                processedStructs{i} = obj.transform(instances{i});
            end

            processedStructs = [processedStructs, obj.drainPendingDocuments()];
        end

        function linkedStructs = drainPendingDocuments(obj)
        % Emit a document for each queued instance. Building one may queue
        % more, so the queue is drained rather than iterated.

            linkedStructs = {};

            while ~isempty(obj.PendingDocuments)
                pending = obj.PendingDocuments{1};
                obj.PendingDocuments(1) = [];

                identifier = char(pending.Instance.id);
                if obj.EmittedIdentifiers.isKey(identifier)
                    continue
                end
                obj.EmittedIdentifiers(identifier) = true;

                obj.CurrentDepth = pending.Depth;
                linkedStructs{end+1} = obj.transform(pending.Instance); %#ok<AGROW>
            end
        end

        function enqueueDocument(obj, instance)
        % Queue a referenced instance for emission as its own document.

            childDepth = obj.CurrentDepth + 1;
            if childDepth > obj.SerializationConfiguration.RecursionDepth
                return
            end

            if obj.EmittedIdentifiers.isKey(char(instance.id))
                return
            end

            obj.PendingDocuments{end+1} = struct( ...
                'Instance', instance, 'Depth', childDepth);
        end

        function S = removeEmptyProperties(obj, S)
            propNames = fieldnames(S);
            propValues = struct2cell(S);

            propNamesIgnore = false(size(propNames));
            for i = 1:numel(propValues)
                if obj.isEmptyPropertyValue(propValues{i})
                    propNamesIgnore(i) = true;
                end
            end
            S = rmfield(S, propNames(propNamesIgnore));
        end
    end

    methods
        function iri = get.NamespaceIRI(~)
            iri = openminds.constant.BaseIRI();
        end

        function iri = get.DefaultVocabularyIRI(~)
            baseIRI = openminds.constant.BaseIRI();
            if startsWith(baseIRI, "https://openminds.ebrains.eu")
                iri = sprintf("%s/vocab/", baseIRI);
            else
                iri = sprintf("%s/props/", baseIRI);
            end
            assert(endsWith(iri, '/'), 'Vocabulary IRI should end with "/"')
        end
    end
end
