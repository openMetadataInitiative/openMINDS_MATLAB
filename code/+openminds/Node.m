classdef (Abstract) Node < handle & matlab.mixin.SetGet & ...
                  openminds.internal.mixin.StructAdapter & ...
                  openminds.internal.mixin.CustomInstanceDisplay
% Node - Base class shared by every openMINDS metadata type
%
%   A node of a metadata graph. It carries an identifier, the properties
%   its type declares, and the edges to other nodes that those properties
%   represent. Every generated type class derives from this.
%
%   Methods:
%       isReference - Whether this stands for a node rather than being one
%       resolve     - Replace unresolved references with the nodes they name
%       serialize   - Serialize this node and the graph below it
%       save        - Write this node to a metadata store
%
%   Inherited, and no less part of this class:
%       string, char  - The instance's display label
%       DisplayString - The same label, as a property
%       toStruct      - The instance as a struct
%       fromStruct    - Populate the instance from a struct
%       toTable       - The instance as a table
%       fromTable     - Populate the instance from a table
%
%   Events:
%       InstanceChanged                   - a plain property was assigned
%       PropertyWithLinkedInstanceChanged - a linked or embedded property
%                                           was assigned
%
%   See also openminds.Collection, openminds.introspection.MetaType

% Todo:
%   [ ] Validate schema. I.e are all required variables filled out
%   [ ] Should controlled term instances be coded as enumeration classes?
%   [ ] Implement ismember and other methods doing "logic" on sets?

    properties (Constant, Hidden) % Move to instance/serializer
        VOCAB = "https://openminds.ebrains.eu/vocab/"
    end

    properties (Hidden)
        % id - The identifier of the node. Settable after construction,
        % as the tutorials do, because the constructor's id argument is
        % the only other way to give a node an identifier of your own.
        id string = ""
    end

    properties (Abstract, Access = protected)
        Required
    end
    
    properties (Abstract, Constant, Hidden)
        X_TYPE (1,1) string
    end

    properties (Abstract, Constant, Hidden)
        LINKED_PROPERTIES struct
        EMBEDDED_PROPERTIES struct
    end

    properties (Hidden)
        % IsReference - Whether this instance stands for a node that is
        % not here, rather than being a node.
        %
        %   Set at construction with IsReference=true together with an id
        %   and nothing else, or by the deserializer for a stub read from
        %   a document. Cleared when the reference is resolved. Hidden,
        %   and public only so the generated type constructors accept it
        %   as a name-value argument; it is not meant to be set afterwards.
        IsReference (1,1) logical = false
    end
    
    events
        % InstanceChanged - A property of this instance was assigned.
        %
        %   Raised after the assignment, on the instance that owns the
        %   property. Not raised for linked or embedded properties; those
        %   raise PropertyWithLinkedInstanceChanged instead.
        %
        %   The listener is passed event data carrying these four
        %   properties, which are the contract:
        %       NewValue         - the value the property now holds
        %       OldValue         - the value it replaced
        %       IsLinkedProperty - false for this event
        %       IsPropertyOf     - the instance the property belongs to
        %
        %   Read the fields rather than testing the class of the event
        %   data; the class itself is an implementation detail.
        InstanceChanged

        % PropertyWithLinkedInstanceChanged - A linked or embedded property
        % of this instance was assigned.
        %
        %   An assignment made through the property to a linked instance,
        %   such as dataset.author.givenName = "...", is raised as
        %   InstanceChanged by that linked instance. MATLAB then assigns
        %   the mixed type set back to the property, so this event is
        %   raised here as well, with the set as both OldValue and
        %   NewValue.
        %
        %   Carries the same four properties as InstanceChanged, with
        %   IsLinkedProperty true.
        PropertyWithLinkedInstanceChanged
    end

    methods % Constructor
        function obj = Node(instance, name, value)
            arguments
                instance (1,:) {mustBeA(instance, "struct")} = struct.empty     % Use mustBeA instead of type specification (e.g., 'instance struct') to avoid MATLAB's forced conversion of input arguments to 'struct'. Using 'mustBeA' only validates the type without attempting conversion, which prevents unexpected behavior if a non-struct is passed.
            end
            arguments (Repeating)
                name (1,1) string
                value
            end

            obj.id = obj.generateInstanceId();
            obj.listenForPropertyChanges()

            if isempty(instance)
                % IsReference is not a property of the type. It marks the
                % instance as standing for a node that is not here, and is
                % only accepted with an id and nothing else.
                [name, value, isReference] = extractIsReference(name, value);
                nvPairs = [name; value];
                if ~isempty(nvPairs)
                    obj.set(nvPairs{:});
                end
                obj.IsReference = isReference;
            else
                if ~isscalar(instance) % Preallocate object array
                    obj(1, numel(instance)) = feval( class(obj) );
                end
                for i = 1:numel( instance )
                    % Todo: Separate method to handle reference structure.
                    obj(i) = obj(i).fromStruct(instance(i)); %#ok<AGROW>
                    fields = fieldnames(instance(i));
                    if isscalar(fields) && ismember(fields, ["x_id", "at_id"])
                        obj(i).IsReference = true; %#ok<AGROW>
                    end
                end
                % Initializing from struct and name-value pairs should be
                % mutually exclusive. Warn if name-value pairs were given.
                obj.warnIfPropValuesSupplied(name)
            end

            for i = 1:numel(obj)
                if isempty(char(obj(i).id)) % Might be an embedded node
                    obj(i).id = obj(i).generateInstanceId(); %#ok<AGROW> % Generate a blank node id
                end
            end
        end
    end

    methods % Methods accepting visitors
        function instance = resolve(obj, options)
        % resolve - Resolve a reference node/instance based on it's identifier (IRI)
        %
        % Syntax:
        %   instance = instance.resolve(Name, Value)
        %
        % Input Arguments:
        %  - instance (openminds.Node) - 
        %    an openMINDS typed metadata instance
        %
        % Output Arguments:
        %  - instance - the resolved instance or instances. Resolving a
        %    reference whose type was not known produces an instance of a
        %    different class, so the result is returned rather than
        %    assigned in place. If an array resolves to more than one
        %    class, the result is a cell array.
        %
        %  - options (name-value pairs) -
        %    Optional name-value pairs. Available options:
        %
        %    - NumLinksToResolve (numeric) -
        %      Number of links to resolve (Default = 0)
        %
        %    - Resolver (resolver) - 
        %      An instance of a Resolver. By default, a resolver is
        %      selected from a registry of link resolvers based on the IRI
        %      of the instance to be resolved.
        %
        % See also: openminds.registerLinkResolver

            arguments
                obj (1,:) openminds.Node
                options.NumLinksToResolve = 0
                options.LinkResolver openminds.interface.LinkResolver
                % options.IsEmbedded = false - Todo?
            end

            if isempty(obj)
                instance = obj; % Nothing to resolve; keep the class of the empty array
                return
            end

            visitorOptions = {"RemainingLinkDepth", options.NumLinksToResolve};
            if isfield(options, 'LinkResolver')
                visitorOptions = [visitorOptions, {"LinkResolver", options.LinkResolver}];
            end

            % Results are collected in a cell array rather than assigned
            % back into obj, because resolving a reference whose type was
            % unknown produces an instance of a different class, which
            % cannot be stored in an array of the original class.
            resolved = cell(1, numel(obj));
            for i = 1:numel(obj)
                % A fresh visitor per element, so the visited registry of
                % one element does not stop a shared node from being
                % resolved for the next.
                visitor = openminds.internal.resolver.ResolvingVisitor(visitorOptions{:});
                resolved{i} = visitor.visit(obj(i));
            end

            resolvedClasses = cellfun(@class, resolved, 'UniformOutput', false);
            if isscalar(unique(resolvedClasses))
                instance = [resolved{:}];
            else
                % Instances of different types cannot form an object array
                instance = resolved;
            end
        end

        function str = serialize(obj, options)
        % serialize - Serialize this node and the graph below it
        %
        %   Syntax:
        %       str = serialize(instance)
        %       str = serialize(instance, Name=Value)
        %       str = serialize(instance, Serializer=serializer)
        %
        %   Description:
        %       With no arguments the instance is serialized to JSON-LD with
        %       default settings. Name-value arguments configure that default
        %       serializer; the options are RecursionDepth, PropertyNameSyntax,
        %       IncludeIdentifier, IncludeEmptyProperties, PropertyFilter,
        %       EnableCaching, EnableValidation, OutputEncoding, PrettyPrint
        %       and OutputMode.
        %
        %       Pass Serializer to use one built elsewhere, such as for a
        %       different format. A serializer already carries its own
        %       configuration, so it cannot be combined with the options
        %       above.
        %
        %   Example:
        %       % Emit only the properties being changed
        %       str = subject.serialize(PropertyFilter=["lookupLabel" "species"]);
            arguments
                obj
                options.Serializer openminds.base.Serializer {mustBeScalarOrEmpty} = ...
                    openminds.internal.serializer.JsonLdSerializer.empty
                options.?openminds.internal.serializer.SerializationConfig
            end

            configOptions = rmfield(options, "Serializer");

            if isempty(options.Serializer)
                nvPairs = namedargs2cell(configOptions);
                serializer = openminds.internal.serializer.JsonLdSerializer(nvPairs{:});
            else
                if ~isempty(fieldnames(configOptions))
                    error("openMINDS:Node:SerializerAndOptions", ...
                        ['A serializer carries its own configuration, so it ', ...
                         'cannot be combined with serialization options. ', ...
                         'Configure the serializer when constructing it, or ', ...
                         'omit Serializer and pass the options here.'])
                end
                serializer = options.Serializer;
            end

            str = serializer.serialize(obj);
        end
    
        function savedIdentifier = save(obj, metadataStore, options)
            arguments
                obj (1,:) openminds.Node
                metadataStore openminds.interface.MetadataStore
                options.IsEmbedded (1,1) logical = false
            end
            savedIdentifier = strings(size(obj));
            for i = 1:numel(obj)
                savedIdentifier(i) = metadataStore.save(obj(i), "IsEmbedded", options.IsEmbedded);
                if ~strcmp(obj(i).id, savedIdentifier(i))
                    obj(i).id = savedIdentifier(i); % Update identifier of object
                end
            end
        end
    end

    methods

        function tf = isReference(obj)
        % isReference - Whether this instance stands for a node rather than being one
        %
        %   Syntax:
        %       tf = isReference(instance)
        %
        %   Description:
        %       A reference carries an identifier and nothing else, and names
        %       a node that is not present: a stub read from a document, a
        %       placeholder created with only an IRI, or a link that has not
        %       been resolved. A node that merely has no properties set is
        %       not a reference. A reference is never written as a document
        %       of its own and is not counted as a node of a collection.
        %
        %       Returns one logical per element, so it works on an array.
        %
        %   See also openminds.Node/resolve

            tf = false(1, numel(obj));
            for i = 1:numel(obj)
                tf(i) = obj(i).IsReference;
            end
        end
    end

    methods (Access = public, Hidden)

        function typeName = getTypeName(obj)
            typeName = openminds.internal.utility.getTypeName(class(obj));
        end

        function tf = isUnresolved(obj)
        % isUnresolved - Deprecated, use isReference
        %
        %   Kept so existing callers keep working. Warns once per session.

            persistent hasWarned
            if isempty(hasWarned)
                hasWarned = true;
                warning('openMINDS:Schema:IsUnresolvedDeprecated', ...
                    ['isUnresolved is deprecated and will be removed in a ', ...
                    'future release. Use isReference instead.'])
            end

            tf = obj.isReference();
        end
    end

    methods (Access = public, Hidden) % Todo: Access = ?visitor
        function linkedInstances = getLinkedInstances(obj)
        % getLinkedInstances - Get all linked instances as a cell array

            arguments
                obj (1,1) openminds.Node % Currently only support scalar
            end

            linkedInstances = {};
            linkedPropertyNames = fieldnames(obj.LINKED_PROPERTIES);
            
            for propName = string( row(linkedPropertyNames) )
                propValue = obj.(propName);
                if ~isempty( propValue ) % Todo: Add method for checking if node is empty
                    % Concatenate instances in a cell array
                    if openminds.utility.isMixedInstance(propValue)
                        linkedInstances = [linkedInstances, propValue.Instances]; %#ok<AGROW>
                    elseif openminds.utility.isInstance(propValue)
                        linkedInstances = [linkedInstances, num2cell(propValue)]; %#ok<AGROW>
                    end
                end
            end
        end

        function embeddedInstances = getEmbeddedInstances(obj)
        % getEmbeddedInstances - Get all embedded instances as a cell array
           
            arguments
                obj (1,1) openminds.Node % Currently only support scalar
            end

            embeddedInstances = {};
            embeddedPropertyNames = fieldnames(obj.EMBEDDED_PROPERTIES);
            
            for propName = string( row(embeddedPropertyNames) )
                propValue = obj.(propName);
                if ~isempty( propValue )
                    if openminds.utility.isMixedInstance(propValue)
                        embeddedInstances = [embeddedInstances, propValue.Instances]; %#ok<AGROW>
                    elseif openminds.utility.isInstance(propValue)
                        embeddedInstances = [embeddedInstances, num2cell(propValue)]; %#ok<AGROW>
                    end
                end
            end
        end
    
        function linkedIdentifiers = getUnresolvedLinkIdentifiers(obj)
        % getUnresolvedLinkIdentifiers - Retrieve identifiers of unresolved links
        %
        % Syntax:
        %   linkedIdentifiers = getUnresolvedLinkIdentifiers(obj) retrieves the identifiers 
        %   of instances that are not resolved.
        %
        % Input Arguments:
        %   obj - An object containing linked instances to be checked for 
        %   resolution status.
        %
        % Output Arguments:
        %   linkedIdentifiers - A cell array (1xN) containing identifiers of
        %   unresolved linked instances.

            arguments
                obj (1,1) openminds.Node % Currently only support scalar
            end

            linkedInstances = obj.getLinkedInstances();
            
            numInstances = numel(linkedInstances);
            isUnresolved = false(1, numInstances);
            for i = 1:numInstances
                isUnresolved(i) = linkedInstances{i}.isReference();
            end

            unresolvedInstances = linkedInstances(isUnresolved);
            numUnresolvedInstances = numel(unresolvedInstances);
            linkedIdentifiers = cell(1, numUnresolvedInstances);
            for i = 1:numUnresolvedInstances
                linkedIdentifiers{i} = unresolvedInstances{i}.id;
            end
        end
        
    end

    methods (Hidden) % Todo: remove?
        function str = char(obj)
            str = obj.getDisplayLabel();
        end
    end

    properties (Access = private, Transient, Hidden)
        % ValueBeforeAssignment - What a property held before the assignment
        % in progress, recorded by the PreSet listener for the PostSet
        % listener to report as OldValue.
        ValueBeforeAssignment
    end

    methods (Access = private) % Change events
        function listenForPropertyChanges(obj)
        % listenForPropertyChanges - Raise a change event when a property
        % of the type is assigned
        %
        %   The generated properties are SetObservable. One PreSet listener
        %   records the value being replaced and one PostSet listener
        %   raises the event with both values. The callbacks reach the
        %   instance through the event rather than by capturing it, so the
        %   listeners do not keep the instance alive.

            observableProperties = obj.getObservableProperties();
            if isempty(observableProperties)
                return
            end
            addlistener(obj, observableProperties, 'PreSet', ...
                @(metaProperty, eventData) ...
                eventData.AffectedObject.recordValueBeforeAssignment(metaProperty));
            addlistener(obj, observableProperties, 'PostSet', ...
                @(metaProperty, eventData) ...
                eventData.AffectedObject.raisePropertyChangedEvent(metaProperty));
        end

        function recordValueBeforeAssignment(obj, metaProperty)
            % Reading a mixed type property is not free, so the value is
            % only recorded when someone is listening.
            if obj.hasChangeListener()
                obj.ValueBeforeAssignment = obj.(metaProperty.Name);
            end
        end

        function raisePropertyChangedEvent(obj, metaProperty)
            import openminds.internal.event.PropertyValueChangedEventData

            if ~obj.hasChangeListener()
                return
            end

            propertyName = metaProperty.Name;
            isLinkedProperty = isfield(obj.LINKED_PROPERTIES, propertyName) ...
                || isfield(obj.EMBEDDED_PROPERTIES, propertyName);
            if isLinkedProperty
                eventName = 'PropertyWithLinkedInstanceChanged';
            else
                eventName = 'InstanceChanged';
            end

            eventData = PropertyValueChangedEventData( ...
                obj.(propertyName), obj.ValueBeforeAssignment, isLinkedProperty, obj);
            obj.ValueBeforeAssignment = [];
            obj.notify(eventName, eventData)
        end

        function tf = hasChangeListener(obj)
            tf = event.hasListener(obj, 'InstanceChanged') ...
                || event.hasListener(obj, 'PropertyWithLinkedInstanceChanged');
        end

        function observableProperties = getObservableProperties(obj)
        % getObservableProperties - The SetObservable properties of the
        % class, as meta.property objects
        %
        %   Handing addlistener the meta.property objects rather than
        %   names makes attaching the listeners an order of magnitude
        %   cheaper, which matters when a collection of thousands of
        %   nodes is built. They are looked up afresh for every instance:
        %   the lookup is cheap, and a cached meta.property goes stale
        %   when the class is reloaded, as happens when the toolbox is
        %   started again.

            propertyList = metaclass(obj).PropertyList;
            observableProperties = propertyList([propertyList.SetObservable]);
        end
    end

    methods (Access = protected) % Methods related to setting new values
        function instanceId = generateInstanceId(obj) %#ok<MANU>
        %generateInstanceId Generate a unique instance id.

        % Todo/idea: Specify custom identifier generator
            
            uuidStr = openminds.internal.utility.string.getUUID();
            
            % Use type prefix (currently inactive)
            % schemaName = obj.getTypeName( class(obj) );
            % instanceId = sprintf('%s/%s', schemaName, uuidStr);
            
            % Use blank node identifier prefix
            instanceId = "_:" + uuidStr;
        end
    
        function warnIfPropValuesSupplied(~, name)
            if ~isempty(name)
                nameStr = strjoin("  - " + string(name), newline);
                warning('openMINDS:InstanceConstructor:NameValuePairsIgnored', ...
                    ['The following name-value pairs were ignored when ', ...
                    'creating an instance using a struct:\n%s'], nameStr)
            end
        end
    end

    methods (Access = protected) % Methods related to object display
        function displayLabel = getDisplayLabel(obj)
            %schemaShortName = obj.getTypeName(class(obj));

            % Use regexp to extract to schema name and the first part
            % of the uuid
            str = regexp(obj.id, '^\w*-\w*(?=-)', 'match', 'once');
            displayLabel = sprintf("%s", str);
        end

        function str = createLabelForMissingLabelDefinition(obj)
            % Note: Currently not in use.
            classNames = split( class(obj), '.');
            str = sprintf('<Unlabeled %s>', classNames{end});
        end

        function annotation = getAnnotation(obj, ~)
        % getAnnotation - Get annotation for type
            import openminds.internal.utility.getTypeDocLink
            annotation = getTypeDocLink( class(obj) );
        end

        function requiredProperties = getRequiredProperties(obj)
            requiredProperties = obj.Required;
        end
    end

    methods (Access = ?openminds.internal.mixin.StructAdapter)
        function assignInstanceId(obj, id)
            obj.id = id;
        end
    end

    methods % Property set methods
        function set.IsReference(obj, value)
            % A reference is an id and nothing else. Marking a populated
            % node as a reference would make a collection skip it, so the
            % next save would drop it without a word. That is refused.
            if value && obj.hasPropertyValues()
                error('openMINDS:Schema:ReferenceWithProperties', ...
                    ['A populated instance cannot be marked as a reference. ', ...
                    'A reference is an id and nothing else.'])
            end
            obj.IsReference = value;
        end
    end

    methods (Access = private)
        function tf = hasPropertyValues(obj)
        % hasPropertyValues - Whether any property of the type holds a value
        %
        %   The id is not a property of the type and does not count.

            tf = false;
            propertyNames = setdiff(string(obj.PropertyNames), "id");
            for i = 1:numel(propertyNames)
                if hasValue(obj.(propertyNames(i)))
                    tf = true;
                    return
                end
            end
        end
    end

    methods (Access = ?openminds.internal.resolver.ResolvingVisitor)
        function markResolved(obj)
        % markResolved - Record that this node is no longer a reference
            obj.IsReference = false;
        end
    end

    methods
        function typeIRI = getTypeIRI(obj)
        % getTypeIRI - IRI of this node's openMINDS type

            % Using eval to ensure it also works for empty objects:
            typeIRI = eval(sprintf('%s.X_TYPE', class(obj)));
        end
    end

    methods (Access = ?openminds.internal.mixin.CustomInstanceDisplay)
        function iri = getHeaderIRI(obj)
            iri = obj.getTypeIRI();
        end
    end
    
end

function x = row(x)
    assert(isrow(x) || iscolumn(x), 'Input must be a vector')
    if ~isrow(x)
        x = transpose(x);
    end
end

function [name, value, isReference] = extractIsReference(name, value)
% Split the IsReference flag from the property name-value pairs.
%
%   A reference carries an identifier and nothing else, so the flag is
%   accepted only together with an id and no other property. Without the
%   flag an instance is a node, whatever its id looks like.

    isFlag = cellfun(@(n) n == "IsReference", name);
    isReference = false;

    if ~any(isFlag)
        return
    end

    flagValue = value{isFlag};
    if ~(islogical(flagValue) && isscalar(flagValue))
        error('openMINDS:Schema:InvalidIsReference', ...
            'IsReference must be a scalar logical.')
    end
    isReference = flagValue;
    name(isFlag) = [];
    value(isFlag) = [];

    if isReference
        isId = cellfun(@(n) n == "id", name);
        if ~any(isId) || ~all(isId)
            error('openMINDS:Schema:ReferenceWithProperties', ...
                ['A reference is created from an id and nothing else. ', ...
                'Give IsReference=true together with an id and no other property.'])
        end
    end
end

function tf = hasValue(propertyValue)
% Whether a property value is set, by the same rule the serializer uses
% to decide what to write.

    if isempty(propertyValue)
        tf = false;
    elseif isstring(propertyValue) && isscalar(propertyValue)
        tf = ~(propertyValue == "" || ismissing(propertyValue));
    elseif isdatetime(propertyValue)
        tf = ~all(isnat(propertyValue));
    else
        tf = true;
    end
end
