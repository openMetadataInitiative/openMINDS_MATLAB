classdef (Abstract) BaseSerializer < handle
% BaseSerializer - Abstract base class for openMINDS serialization
%
%   This class provides the core serialization logic for openMINDS
%   instances, handling linked and embedded types according to openMINDS
%   specifications. Concrete subclasses implement format-specific output.
%
%   An instance of this class will act as a visitor for a metadata instance
%   via its `serialize` method, in accordance with the Visitor design pattern:
%   https://refactoring.guru/design-patterns/visitor
%
%   USAGE:
%   ------
%   % Subclass must implement formatOutput method
%   classdef JsonLdSerializer < BaseSerializer
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

    methods (Abstract, Access = protected)
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

    methods (Access = protected)
        function allStructs = postProcessInstances(obj, allStructs) %#ok<INUSD>
            % Subclass can implement
        end
    end
    
    methods % Constructor
        function obj = BaseSerializer(config)
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
        %   instances : openminds.abstract.Schema or cell array
        %       Instance(s) to serialize
        %
        %   RETURNS:
        %   --------
        %   result : any
        %       Serialized output in the format specified by the subclass
            
            arguments
                obj (1,1) openminds.internal.serializer.BaseSerializer
                instances % openminds.abstract.Schema or cell array
            end
            
            % Process instances to add openMINDS-specific fields and collect
            % linked instances
            processedStructs = obj.processInstances(instances);
            
            processedStructs = obj.postProcessInstances(processedStructs);
            
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
                instance (1,1) openminds.abstract.Schema
            end
            S.at_type = instance.X_TYPE; % Add @type (always required)
        end

        function S = addInstanceIdentifier(~, S, instance)
        % addInstanceIdentifier - Add identifier to structure representation
            arguments
                ~ % This method does not use obj
                S (1,1) struct
                instance (1,1) openminds.abstract.Schema
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
                instances (1,:) % Array of instances
            end

            numInstances = numel(instances);
            references = cell(1, numInstances);

            for i = 1:numInstances
                currentInstance = instances(i);
                
                if openminds.utility.isMixedInstance(currentInstance)
                    instanceIdentifier = currentInstance.Instance.id;
                
                elseif openminds.utility.isInstance(currentInstance)
                    instanceIdentifier = currentInstance.id;
                
                % Might already be a reference. Need to normalize
                elseif isstruct(currentInstance)
                    if isfield(currentInstance, 'at_id')
                        instanceIdentifier = currentInstance.at_id;
                    elseif isfield(currentInstance, 'x_id')
                        instanceIdentifier = currentInstance.x_id;
                    elseif isfield(currentInstance, 'id')
                        instanceIdentifier = currentInstance.id;
                    else
                        error('Cannot create reference: struct has no id field');
                    end
                
                else
                    error('Cannot create reference for type: %s', ...
                        class(currentInstance));
                end

                references{i} = struct('at_id', instanceIdentifier);
            end
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

    methods (Access = private)
        function processedStructs = processInstances(obj, instances)
        %processInstances Process instances and add openMINDS-specific fields
        %
        %   processedStructs = processInstances(obj, instances)
        %   converts instances to structs and adds openMINDS-specific
        %   fields like @type, @id, @context, and processes linked/embedded types.
        %   Returns both the main processed structs and any linked instances found.
            
            arguments
                obj (1,1) openminds.internal.serializer.BaseSerializer
                instances % openminds.abstract.Schema or cell array
            end
            
            % Ensure instances is a cell array
            if ~iscell(instances)
                instances = num2cell(instances);
            end

            config = obj.SerializationConfiguration;
            
            % Create serialization context with linked instance collection
            context = openminds.internal.serializer.SerializationContext(config);
            
            % Process each instance
            processedStructs = cell(size(instances));
            for i = 1:numel(instances)
                processedStructs{i} = obj.processInstance(instances{i}, context);
            end
            
            % Extract linked instances from context
            linkedInstances = context.getLinkedInstances();

            % Combine main instances with linked instances for output
            if ~isempty(linkedInstances)
                processedStructs = [processedStructs, linkedInstances];
            end
        end
        
        function processedStruct = processInstance(obj, instance, context)
        %processInstance Process a single instance
        %
        %   processedStruct = processInstance(obj, instance, context)
        %   converts a single instance to a struct with openMINDS fields
            
            arguments
                obj (1,1) openminds.internal.serializer.BaseSerializer
                instance (1,1) openminds.abstract.Schema
                context (1,1) openminds.internal.serializer.SerializationContext
            end
            
            % Check for circular reference
            if context.isVisited(string(instance.id))
                % Return just a reference for circular dependencies
                processedStruct = struct('at_id', instance.id);
                return
            end
            
            % Mark this instance as being processed
            context.markVisited(string(instance.id));
            
            try
                % Get basic struct from StructAdapter
                S = instance.toStruct();
                
                if ~obj.SerializationConfiguration.IncludeEmptyProperties
                    S = obj.removeEmptyProperties(S);
                end

                % Add openMINDS-specific fields
                S = obj.addOpenMindsType(S, instance);

                % Add @id if requested (todo: and not embedded)
                if context.Config.IncludeIdentifier
                    S = obj.addInstanceIdentifier(S, instance);
                end

                % Process linked properties (respect recursion depth)
                S = obj.processLinkedProperties(S, instance, context);
                
                % Process embedded properties (always inline, no @id)
                S = obj.processEmbeddedProperties(S, instance, context);
                
                processedStruct = S;
                
            catch ME
                % Unmark visited on error
                context.unmarkVisited(string(instance.id));
                rethrow(ME);
            end
            
            % Unmark visited after successful processing
            context.unmarkVisited(string(instance.id));
        end
        
        function S = removeEmptyProperties(obj, S)
            propNames = fieldnames(S);
            propValues = struct2cell(S);

            propNamesIgnore = false(size(propNames));
            for i = 1:numel(propValues)
                iPropertyValue = propValues{i};
                if obj.isEmptyPropertyValue(iPropertyValue)
                    propNamesIgnore(i) = true;
                end
            end
            S = rmfield(S, propNames(propNamesIgnore));
        end

        function S = processLinkedProperties(obj, S, instance, context)
        %processLinkedProperties Process properties with linked types
        %
        %   S = processLinkedProperties(obj, S, instance, context)
        %   processes properties that contain linked instances. Linked instances
        %   are ALWAYS represented as references (@id only) in the property,
        %   and the actual instances are collected separately for processing.
            
            arguments
                obj (1,1) openminds.internal.serializer.BaseSerializer
                S (1,1) struct
                instance (1,1) openminds.abstract.Schema
                context (1,1) openminds.internal.serializer.SerializationContext
            end
            
            % Get metadata about the instance type
            metaType = openminds.internal.meta.fromInstance(instance);
            
            % Get linked property names
            linkedPropertyNames = fieldnames(instance.LINKED_PROPERTIES);
            
            for i = 1:numel(linkedPropertyNames)
                propName = linkedPropertyNames{i};
                
                % Skip if property is not set or empty
                if ~isfield(S, propName) || isempty(S.(propName))
                    continue
                end
                
                % Get the linked instances
                linkedInstances = instance.(propName);
                
                % ALWAYS create references for linked properties
                S.(propName) = obj.createReferences(linkedInstances);
                
                % Collect linked instances for separate processing if recursion is enabled
                if context.canRecurse()
                    obj.collectLinkedInstances(linkedInstances, context);
                end
                
                % Ensure array format if property allows multiple values
                if ~metaType.isPropertyValueScalar(propName) && ~iscell(S.(propName))
                    S.(propName) = {S.(propName)};
                end
            end
        end
        
        function S = processEmbeddedProperties(obj, S, instance, context)
        %processEmbeddedProperties Process properties with embedded types
        %
        %   S = processEmbeddedProperties(obj, S, instance, context)
        %   processes properties that contain embedded instances. Embedded
        %   instances are always serialized inline regardless of recursion depth
            
            arguments
                obj (1,1) openminds.internal.serializer.BaseSerializer
                S (1,1) struct
                instance (1,1) openminds.abstract.Schema
                context (1,1) openminds.internal.serializer.SerializationContext
            end
            
            % Get metadata about the instance type
            metaType = openminds.internal.meta.fromInstance(instance);
            
            % Get embedded property names
            embeddedPropertyNames = fieldnames(instance.EMBEDDED_PROPERTIES);
            
            for i = 1:numel(embeddedPropertyNames)
                propName = embeddedPropertyNames{i};
                
                % Skip if property is not set or empty
                if ~isfield(S, propName) || isempty(S.(propName))
                    continue
                end
                
                % Get the embedded instances
                embeddedInstances = instance.(propName);
                
                % Always serialize embedded instances inline (no recursion depth limit)
                S.(propName) = obj.processEmbeddedInstanceArray(embeddedInstances, context);
                
                % Ensure array format if property allows multiple values
                if ~metaType.isPropertyValueScalar(propName) && ~iscell(S.(propName))
                    S.(propName) = {S.(propName)};
                end
            end
        end
        
        function collectLinkedInstances(obj, linkedInstances, context)
        %collectLinkedInstances Collect linked instances for separate processing
        %
        %   collectLinkedInstances(obj, linkedInstances, context)
        %   adds linked instances to the context for separate processing.
        %   This ensures linked instances become separate documents.
            
            arguments
                obj (1,1) openminds.internal.serializer.BaseSerializer
                linkedInstances % Array of linked instances
                context (1,1) openminds.internal.serializer.SerializationContext
            end
            
            if isempty(linkedInstances)
                return
            end
            
            % Process each linked instance
            for i = 1:numel(linkedInstances)
                obj.collectLinkedInstance(linkedInstances(i), context);
            end
        end
        
        function collectLinkedInstance(obj, linkedInstance, context)
        %collectLinkedInstance Collect a single linked instance
        %
        %   collectLinkedInstance(obj, linkedInstance, context)
        %   adds a single linked instance to the context for processing
            
            arguments
                obj (1,1) openminds.internal.serializer.BaseSerializer
                linkedInstance % Single linked instance
                context (1,1) openminds.internal.serializer.SerializationContext
            end
            
            % Handle mixed type instances
            if openminds.utility.isMixedInstance(linkedInstance)
                actualInstance = linkedInstance.Instance;
            else
                actualInstance = linkedInstance;
            end
            
            % Skip struct instances (already processed)
            if isstruct(actualInstance)
                return
            end
            
            % Process openMINDS instance
            if openminds.utility.isInstance(actualInstance)
                instanceId = string(actualInstance.id);
                
                % Only process if not already collected and not currently being processed
                if ~context.LinkedInstances.isKey(char(instanceId)) && ~context.isVisited(instanceId)
                    % Create child context for processing linked instance
                    % Child context shares the same LinkedInstances and VisitedInstances maps
                    % but has incremented recursion depth
                    childContext = context.createChildContext();
                    processedInstance = obj.processInstance(actualInstance, childContext);
                    
                    % Store in linked instances collection (shared with parent context)
                    context.LinkedInstances(char(instanceId)) = processedInstance;
                end
            else
                error('Unknown linked instance type: %s', class(actualInstance));
            end
        end
        
        function result = processEmbeddedInstanceArray(obj, embeddedInstances, context)
        %processEmbeddedInstanceArray Process an array of embedded instances
        %
        %   result = processEmbeddedInstanceArray(obj, embeddedInstances, context)
        %   processes multiple embedded instances, always inline without @id
            
            arguments
                obj (1,1) openminds.internal.serializer.BaseSerializer
                embeddedInstances % Array of embedded instances
                context (1,1) openminds.internal.serializer.SerializationContext
            end
            
            if isempty(embeddedInstances)
                result = {};
                return
            end
            
            % Handle single instance
            if isscalar(embeddedInstances)
                result = obj.processEmbeddedInstance(embeddedInstances, context);
                return
            end
            
            % Handle multiple instances
            result = cell(size(embeddedInstances));
            for i = 1:numel(embeddedInstances)
                result{i} = obj.processEmbeddedInstance(embeddedInstances(i), context);
            end
        end
        
        function result = processEmbeddedInstance(obj, embeddedInstance, context)
        %processEmbeddedInstance Process a single embedded instance
        %
        %   result = processEmbeddedInstance(obj, embeddedInstance, context)
        %   processes a single embedded instance, always inline without @id
            
            arguments
                obj (1,1) openminds.internal.serializer.BaseSerializer
                embeddedInstance % Single embedded instance
                context (1,1) openminds.internal.serializer.SerializationContext
            end
            
            % Handle mixed type instances
            if openminds.utility.isMixedInstance(embeddedInstance)
                actualInstance = embeddedInstance.Instance;
            else
                actualInstance = embeddedInstance;
            end
            
            % Process openMINDS instance
            if openminds.utility.isInstance(actualInstance)
                
                % Process using the same context to ensure linked instances are collected
                result = obj.processInstance(actualInstance, context);
                
                % Remove @id if it was added. Embedded nodes do not have
                % their own identifiers.
                if isfield(result, 'at_id')
                    result = rmfield(result, 'at_id');
                end
            else
                error('Unknown embedded instance type: %s', class(actualInstance));
            end
        end
    end

    methods
        function iri = get.NamespaceIRI(~)
            iri = openminds.constant.BaseURI();
        end

        function iri = get.DefaultVocabularyIRI(~)
            baseIRI = openminds.constant.BaseURI();
            if startsWith(baseIRI, "https://openminds.ebrains.eu")
                iri = sprintf("%s/vocab/", baseIRI);
            else
                iri = sprintf("%s/props/", baseIRI);
            end
            assert(endsWith(iri, '/'), 'Vocabulary IRI should end with "/"')
        end
    end
end
