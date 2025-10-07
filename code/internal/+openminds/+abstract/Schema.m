classdef Schema < handle & matlab.mixin.SetGet & ...
                  openminds.internal.mixin.StructAdapter & ...
                  openminds.internal.mixin.CustomInstanceDisplay

% Schema Abstract base class shared by all concrete Schema classes

% Todo:
%   [ ] Validate schema. I.e are all required variables filled out
%   [ ] Should controlled term instances be coded as enumeration classes?
%   [ ] Implement ismember and other methods doing "logic" on sets?

    properties (Constant, Hidden) % Move to instance/serializer
        VOCAB = "https://openminds.ebrains.eu/vocab/"
    end

    properties (SetAccess = protected, Hidden) % Todo: SetAccess = immutable
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

    properties (Access = private)
        IsReference (1,1) logical = false
    end
    
    events % Todo: Remove??
        InstanceChanged
        PropertyWithLinkedInstanceChanged
    end

    methods % Constructor
        function obj = Schema(instance, name, value)
            arguments
                instance (1,:) {mustBeA(instance, "struct")} = struct.empty     % Use mustBeA instead of type specification (e.g., 'instance struct') to avoid MATLAB's forced conversion of input arguments to 'struct'. Using 'mustBeA' only validates the type without attempting conversion, which prevents unexpected behavior if a non-struct is passed.
            end
            arguments (Repeating)
                name (1,1) string
                value
            end

            obj.id = obj.generateInstanceId();

            if isempty(instance)
                nvPairs = [name; value];
                if ~isempty(nvPairs)
                    obj.set(nvPairs{:});
                end
                if isscalar(name) && string(name) == "id" && startsWith(string(value), "https://")
                    % Only IRI was set, assume this is a node reference
                    % Todo: Should support general IRI
                    obj.IsReference = true;
                end
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
        %  - instance (openminds.abstract.Schema) - 
        %    an openMINDS typed metadata instance
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
                obj (1,:) openminds.abstract.Schema
                options.NumLinksToResolve = 0
                options.LinkResolver openminds.internal.resolver.AbstractLinkResolver
                % options.IsEmbedded = false - Todo?
            end

            instance = obj; % Initialize output
            for i = 1:numel(obj)
                if ~obj(i).IsReference % Instance is resolved (not a reference)
                    if options.NumLinksToResolve == 0
                        fprintf('Instance is already resolved.\n')
                        instance(i) = obj(i);
                        return
                    else
                        options.NumLinksToResolve = options.NumLinksToResolve-1;
                        nvPairs = namedargs2cell(options);
                        linkedInstances = obj(i).getLinkedInstances();
                        for j = 1:numel(linkedInstances)
                            linkedInstances{j}.resolve(nvPairs{:});
                        end
                        embeddedInstances = obj(i).getEmbeddedInstances();
                        for j = 1:numel(embeddedInstances)
                            embeddedInstances{j}.resolve(nvPairs{:});
                        end
                    end
                else
                    if isfield(options, 'LinkResolver')
                        resolver = options.LinkResolver;
                    else
                        resolver = openminds.internal.getLinkResolver([obj(i).id]);
                    end

                    if isempty(resolver)
                        error(...
                            'openMINDS:LinkResolver:NotFound', ...
                             'No link resolver found for object with id "%s".', obj(i).id);
                    end

                    obj(i) = resolver.resolve(obj(i), "NumLinksToResolve", options.NumLinksToResolve);
                    obj(i).IsReference = false; % Update state: mark as resolved
                end
            end
            instance = obj; % Set output
        end

        function str = serialize(obj, options)
        % serialize - Serialize the object
            arguments
                obj
                options.Serializer = openminds.internal.serializer.JsonLdSerializer()
                options.RecursionDepth (1,1) uint8 = 1 % Todo: remove - should be defined in serializer - or the serializer should be created from options...
                options.IncludeIdentifier (1,1) logical = true % Todo: remove - should be defined in serializer
            end

            % Create default serializer if not provided.
            % Accept more serializer options as inputs here.

            str = options.Serializer.serialize(obj);
        end
    
        function savedIdentifier = save(obj, metadataStore, options)
            arguments
                obj (1,:) openminds.abstract.Schema
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

    methods (Access = public, Hidden)

        function typeName = getTypeName(obj)
            classNameSplit = split(class(obj), '.');
            typeName = classNameSplit{end};
        end
    end

    methods (Access = public, Hidden) % Todo: Access = ?visitor
        function linkedInstances = getLinkedInstances(obj)
        % getLinkedInstances - Get all linked instances as a cell array
            linkedInstances = {};
            linkedPropertyNames = fieldnames(obj.LINKED_PROPERTIES);
            
            for propName = string( row(linkedPropertyNames) )
                propValue = obj.(propName);
                if ~isempty( propValue )
                    % Concatenate instances in a cell array
                    if openminds.utility.isMixedInstance(propValue)
                        linkedInstances = [linkedInstances, {propValue.Instance}]; %#ok<AGROW>
                    elseif openminds.utility.isInstance(propValue)
                        linkedInstances = [linkedInstances, num2cell(propValue)]; %#ok<AGROW>
                    end
                end
            end
        end

        function embeddedInstances = getEmbeddedInstances(obj)
        % getEmbeddedInstances - Get all embedded instances as a cell array
            embeddedInstances = {};
            embeddedPropertyNames = fieldnames(obj.EMBEDDED_PROPERTIES);
            
            for propName = string( row(embeddedPropertyNames) )
                propValue = obj.(propName);
                if ~isempty( propValue )
                    if openminds.utility.isMixedInstance(propValue)
                        embeddedInstances = [embeddedInstances, {propValue.Instance}]; %#ok<AGROW>
                    elseif openminds.utility.isInstance(propValue)
                        embeddedInstances = [embeddedInstances, num2cell(propValue)]; %#ok<AGROW>
                    end
                end
            end
        end
    end

    methods (Hidden) % Todo: remove?
        function str = char(obj)
            str = obj.getDisplayLabel();
        end
    end

    methods (Hidden) % Overrides subsref & subsasgn (seal?)

        function obj = subsasgn(obj, subs, value)
            
            import openminds.internal.event.PropertyValueChangedEventData
            import openminds.internal.utility.getSchemaDocLink

            if isequal(obj, [])
                % As far as I understand, this only occurs during property
                % initialization of properties with a defined class, in
                % which case the obj has to be assigned with an instance of
                % the correct class.
                obj = eval(sprintf('%s.empty', class(value)));
            end

            if obj.isSubsForLinkedProperty(subs) || obj.isSubsForEmbeddedProperty(subs)
                propName = subs(1).subs;

                if isscalar(subs)
                    propName = subs(1).subs;
                    className = class(obj.(propName));
                
                    % Get the actual instance from a MixedTypeSet subclass.
                    if contains(className, 'openminds.internal.mixedtype')
                        try
                            % Place the openMINDS instance object in a
                            % MixedTypeSet wrapper class
                            classFcn = str2func(className);
                            value = classFcn(value);
                        catch MECause
                            msg = sprintf("Error setting instance of linked type '%s' of class '%s'. ", propName, class(obj));
                            errorStruct.identifier = 'LinkedProperty:CouldNotRetrieveInstance';
                            errorStruct.message = msg + MECause.message;
                            errorStruct.stack = struct('file', '', 'name', class(obj), 'line', 0);
                            error(errorStruct)
                        end
                    end
                elseif numel(subs) > 1
                    % Pass for now.
                    % This case should be handled below? What if multiple
                    % instances should be placed in the mixedtype wrapper?
                end

                try
                    if isscalar(subs)
                        % Assigning a linked property
                        oldValue = obj.subsref(subs);

                        obj = builtin('subsasgn', obj, subs, value);

                        % Assign new value and trigger event
                        evtData = PropertyValueChangedEventData(value, oldValue, true); % true for linked prop
                        obj.notify('PropertyWithLinkedInstanceChanged', evtData)

                    elseif numel(subs) > 1 && strcmp(subs(2).type, '.')
                        % Modifying a linked property
                        
                        linkedObj = obj.subsref(subs(1));
                        if isa(linkedObj, 'cell')
                            className = class(obj.(subs(1).subs));
                            if contains(className, 'openminds.internal.mixedtype')
                                % Todo: Check if instances in cell array
                                % are of different types.
                                error('Can not use indexing assignment for instances of different types')
                            else
                                error('Unexpected error occurred, please report')
                            end
                        end
                        oldValue = linkedObj.subsref(subs(2:end));

                        % Assign new value and trigger event
                        linkedObj.subsasgn(subs(2:end), value);
                        evtData = PropertyValueChangedEventData(value, oldValue, true); % true for linked prop
                        obj.notify('PropertyWithLinkedInstanceChanged', evtData)

                    elseif numel(subs) > 1 && strcmp(subs(2).type, '()')
                        try
                            % linkedObj = obj.subsref(subs(1:2));
                            obj = builtin('subsasgn', obj, subs, value);

                        catch MECause

                            switch MECause.identifier
                                case 'MATLAB:badsubscript'
                                    % Bad subscript might occur when
                                    % someone tries to assign a value to a
                                    % part of the array that does not exist
                                    % yet. Use builtin subasgn to deal with
                                    % this... This should be improved, as
                                    % empty values default to empty double,
                                    % but should be empty object of correct
                                    % instance type.
                                    try
                                        if obj.isSubsForMixedTypePropertyValue(subs)
                                            className = class( obj.(subs(1).subs) );
                                            value = feval(className, value);
                                        end
                                        obj = builtin('subsasgn', obj, subs, value);
                                    catch ME
                                        errorStruct.identifier = ME.identifier;
                                        errorStruct.message = ME.message;
                                        errorStruct.stack = struct('file', '', 'name', class(obj), 'line', 0);
                                        error(errorStruct)
                                    end

                                    % obj.subsasgn(subs, value);
                                otherwise
                                    ME = MException('OPENMINDS_MATLAB:UnhandledIndexAssignment', ...
                                        'Unhandled index assignment, please report');
                                    ME.addCause(MECause)
                                    throw(ME)
                            end
                        end

                    else
                        error('Unhandled indexing assignment')
                    end
                catch ME
                    errorStruct.identifier = 'LinkedProperty:InvalidType';
                    if contains(ME.message, 'Error setting property')
                        errorStruct.message = ME.message;
                    else
                        classDocLink = getSchemaDocLink(class(obj), 'Help popup'); % Todo: Dataset or openminds.core.Dataset?
                        msg = sprintf("Error setting property '%s' of class '%s'. ", propName, classDocLink);
                        errorStruct.message = msg + ME.message;
                    end
                    errorStruct.stack = struct('file', '', 'name', class(obj), 'line', 0);
                    error(errorStruct)
                end
                
                % fprintf('set linked property of %s\n', class(obj))
            else
                if ~isempty(obj)
                    try
                        oldValue = builtin('subsref', obj, subs);
                    catch MECause
                        switch MECause.identifier
                            case 'MATLAB:badsubscript'
                                % Old value was not assigned, expanding array
                                obj = builtin('subsasgn', obj, subs, value);
                        end
                    end
                else
                    oldValue = [];
                end
                
                obj = builtin('subsasgn', obj, subs, value);

                if numel(obj) >= 1
                    if obj.isSubsForPublicPropertyValue(subs)
                        evtData = PropertyValueChangedEventData(value, oldValue, false); % false for property which is not embedded or linked
                        obj.notify('InstanceChanged', evtData)
                        % fprintf('Set "primitive" property type of %s\n', class(obj))
                    end
                end
            end

            if ~nargout
                clear obj
            end
        end

        function varargout = subsref(obj, subs)
        % subsref - Overrides subsref for customized indexing on properties

            numOutputs = nargout;
            varargout = cell(1, numOutputs);
                            
% %             if numel(obj) > 1
% %                 if obj.isSubsForProperty(subs)
% %                     varargout = cell(numel(obj), 1);
% %                     for i = 1:numel(obj)
% %                         varargout{i} = obj(i).subsref(subs);
% %                     end
% %                     return
% %                 end
% %             end

            if obj.isSubsForLinkedProperty(subs) || obj.isSubsForEmbeddedProperty(subs)
                
                if numel(obj) > 1
                    linkedTypeValues = cell(size(obj));
                    for ii = 1:numel(obj)
                        linkedTypeValues{ii} = builtin('subsref', obj(ii), subs(1));
                    end
                    try
                        linkedTypeValues = [linkedTypeValues{:}];
                    catch
                        assert(isa(resolvedInstances, 'cell'), ...
                            'Expected linked instances to be a cell array')
                    end
                else
                    linkedTypeValues = builtin('subsref', obj, subs(1));
                end

                if openminds.utility.isMixedInstance(linkedTypeValues)

                    % Specify special handling when calling methods of a
                    % mixed type instance.

                    % method fallback
                    if numel(subs) >= 2
                        if strcmp( subs(2).type, '.' ) && ismethod(linkedTypeValues, subs(2).subs)
                            if nargout == 0
                                % Todo: need try/catch in case method does not return
                                res = builtin('subsref', linkedTypeValues, subs(2:end));
                                varargout = {res};
                            else
                                [varargout{:}] = builtin('subsref', linkedTypeValues, subs(2:end));
                            end
                            return
                        end
                    end

                    % Todo: Is this necessary, resolve is a method, and this
                    % should not be reached. Is there any situation, where we
                    % call resolve and should moved on with further subsref of
                    % resolved instances, i.e support chained indexing?
                    if strcmp( subs(end).subs, 'resolve')
                        if numel(subs) == 2
                            if strcmp(subs(end).type, '.') && strcmp(subs(end).subs, 'resolve')
                                linkedTypeValues.resolve()
                                subs(end) = [];
                                % return
                            end
                        elseif numel(subs) == 3
                            if strcmp(subs(end).type, '.') && strcmp(subs(end).subs, 'resolve')
                                linkedTypeValues = builtin('subsref', linkedTypeValues, subs(2));
                                linkedTypeValues.resolve()
                                subs(end) = [];
                                % return
                            end
                        elseif numel(subs) == 4
                            error('Internal error: Not implemented')
                        end
                    end

                    % linkedTypeValues is an array of mixed types. The
                    % actual object(s) need to be retrieved from an
                    % "Instance" property.
                    mixedTypeCellArray = {linkedTypeValues.Instance};
                    instanceType = cellfun(@(c) class(c), mixedTypeCellArray, 'uni', false);

                    if numel(subs) > 1 && numel( unique(instanceType) ) > 1
                        % If nested indexing is performed, proceed with the
                        % cell array of mixed types.
                        values = mixedTypeCellArray;
                    else
                        % Otherwise, resolve "unmixed" or "mixed" type
                        % output now.
                        mixedTypeClassName = class(linkedTypeValues);
                        values = obj.resolveMixedTypeOutput(mixedTypeCellArray, mixedTypeClassName);
                    end
                else
                    values = linkedTypeValues;
                end
                
                if numel(subs) > 1
                    % Todo: Remove as this appears to be unused
                    if strcmp( subs(2).type, '()' ) && iscell(values)
                        % subs(2).type = '{}';
                    end

                    if numOutputs > 0
% % %                         if isequal(subs(2).type, '()') || isequal(subs(2).type, '{}')
% % %                             numInstances = numel(values);
% % %                             if ~ismember([subs(2).subs{:}], 1:numInstances)
% % %                                 [varargout{:}] = deal([]);
% % %                             else
% % %                                 [varargout{:}] = builtin('subsref', values, subs(2:end));
% % %                             end
% % %                         else
% % %
% % %                         end
                        if openminds.utility.isInstance(values)
                            % TODO: Does this work if values is an array.
                            if numel(values) == numOutputs
                                for i = 1:numel(values)
                                    varargout{i} = values(i).subsref(subs(2:end));
                                end
                            else
                                varargout = cell(1, numOutputs);
                                [varargout{:}] = values.subsref(subs(2:end));
                            end
                        else
                            varargout = cell(1, numOutputs);
                            [varargout{:}] = builtin('subsref', values, subs(2:end));
                        end
                    else
                        if openminds.utility.isMixedInstance(linkedTypeValues)
                            % Takes care of nested indexing into a property
                            % with mixed types.
                            res = builtin('subsref', values, subs(2:end));
                            outValue = obj.resolveMixedTypeOutput(res, class(linkedTypeValues));
                            varargout = {outValue};
                        else
                            builtin('subsref', values, subs(2:end))
                        end
                    end
                else
                    if numOutputs > 0
                        if numel(values) == numOutputs
                            for i = 1:numel(values)
                                varargout{i} = values(i);
                            end
                        else
                            varargout = cell(1, numOutputs);
                            [varargout{:}] = values;
                        end
                    else
                        varargout = values;
                    end
                end
            else
                if numOutputs > 0
                    varargout = cell(1, numOutputs);
                    [varargout{:}] = builtin('subsref', obj, subs);
                else
                    try
                        % First we try to collect output(s) using builtin assign
                        varargout = builtin('subsref', obj, subs);
                        if ~iscell(varargout)
                            varargout = {varargout};
                        end
                    catch ME
                        % If the assignment/method does not have any return
                        % arguments, we fall back to using builtin without
                        % collecting / requiring any outputs.
                        if strcmp(ME.identifier, 'MATLAB:TooManyOutputs')
                            builtin('subsref', obj, subs);
                        else
                            % If assignment failed for any other reason, we
                            % rethrow the exception.
                            rethrow(ME)
                        end
                    end
                end
            end
        end

        function n = numArgumentsFromSubscript(obj, s, indexingContext)
            if (obj(1).isSubsForLinkedProperty(s) || obj(1).isSubsForEmbeddedProperty(s)) && numel(s) > 1
                
                % if strcmp(s(1).type, '.') && strcmp(s(2).type, '()')
                %     %linkedTypeValues = builtin('subsref', obj, s(1:2));
                %     linkedTypeValues = obj.subsref(s(1:2));
                %
                % elseif strcmp(s(1).type, '.')
                %     linkedTypeValues = builtin('subsref', obj, s(1));
                % end

                linkedTypeValues = builtin('subsref', obj, s(1));

                if openminds.utility.isMixedInstance(linkedTypeValues)
                    linkedTypeValues = {linkedTypeValues.Instance};
                end

                if strcmp( s(2).type, '()' ) && iscell(linkedTypeValues)
                    s(2).type = '{}';
                end
                try
                    n = builtin('numArgumentsFromSubscript', [linkedTypeValues{:}], s(2:end), indexingContext);
                catch
                    n = builtin('numArgumentsFromSubscript', linkedTypeValues, s(2:end), indexingContext);
                end
            else
                n = builtin('numArgumentsFromSubscript', obj, s, indexingContext);
            end
        end
    end

    methods (Access = private) % Introspective utility methods
        
        function tf = isSubsForProperty(obj, subs)
            tf = strcmp( subs(1).type, '.' ) && isprop(obj(1), subs(1).subs);
        end

        function tf = isSubsForLinkedProperty(obj, subs)
        % Return true if subs represent dot-indexing on a linked property
            
            if numel(obj) >= 1
                tf = strcmp( subs(1).type, '.' ) && isfield(obj(1).LINKED_PROPERTIES, subs(1).subs);
            else
                linkedProps = eval( sprintf( '%s.LINKED_PROPERTIES', class(obj) ));
                tf = strcmp( subs(1).type, '.' ) && isfield(linkedProps, subs(1).subs);
            end
        end

        function tf = isSubsForEmbeddedProperty(obj, subs)
        % Return true if subs represent dot-indexing on a linked property
            
            if numel(obj)>=1
                tf = strcmp( subs(1).type, '.' ) && isfield(obj(1).EMBEDDED_PROPERTIES, subs(1).subs);
            else
                embeddedProps = eval( sprintf( '%s.EMBEDDED_PROPERTIES', class(obj) ));
                tf = strcmp( subs(1).type, '.' ) && isfield(embeddedProps, subs(1).subs);
            end
        end

        function tf = isSubsForMixedTypePropertyValue(obj, subs)
            
            tf = false;
            if strcmp( subs(1).type, '.' )
                if contains( class( obj.(subs(1).subs) ), 'mixedtype' )
                    tf = true;
                end
            end
        end

        function tf = isSubsForPublicPropertyValue(obj, subs)
        % Return true if subs represent dot-indexing on a public property
            
            tf = false;
    
            if strcmp( subs(1).type, '.' )
                propNames = properties(obj);
                tf = any( strcmp(subs(1).subs, propNames) );
            end
        end

        function getLinkedPropertyInstance(obj, subs) %#ok<INUSD>
            % Todo
        end

        function assignLinkedInstance(obj) %#ok<MANU>
            % Todo: Use this from subsasgn
        end
    end

    methods (Access = ?openminds.internal.mixin.StructAdapter)
        function assignInstanceId(obj, id)
            obj.id = id;
        end
    end

    methods (Access = private)
                      
        function outValues = resolveMixedTypeOutput(~, values, mixedTypeClassName)
        % resolveMixedTypeOutput - Resolve how to output mixed type array
        %
        %   Inputs:
        %       values             : cell array of instances
        %       mixedTypeClassName : name of the mixed type class for
        %                            elements of values
        %
        %   If all instances have the same type, the output will be an
        %   array of objects of that type, otherwise return instances as a
        %   mixed type array

            if isa(values, 'cell')
                instanceType = cellfun(@(c) class(c), values, 'uni', false);
            else
                instanceType = string(class(values));
            end
            if isscalar( unique(instanceType) )
                if iscell(values)
                    outValues = [values{:}];
                else
                    outValues = values;
                end
            else
                outValues = feval(mixedTypeClassName, values);
            end
        end
    end

    methods (Access = protected) % Methods related to setting new values
        function instanceId = generateInstanceId(obj) %#ok<MANU>
        %generateInstanceId Generate a unique instance id.

        % Todo/idea: Specify custom identifier generator
            
            uuidStr = openminds.internal.utility.string.getuuid();
            
            % Use type prefix (currently inactive)
            % schemaName = obj.getSchemaShortName( class(obj) );
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
        function tf = isReference(obj)
            tf = obj.IsReference;
        end
        
        function displayLabel = getDisplayLabel(obj)
            %schemaShortName = obj.getSchemaShortName(class(obj));

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
            import openminds.internal.utility.getSchemaDocLink
            annotation = getSchemaDocLink( class(obj) );
        end

        function requiredProperties = getRequiredProperties(obj)
            requiredProperties = obj.Required;
        end
    end

    methods (Access = ?openminds.internal.mixin.CustomInstanceDisplay)
        function semanticName = getSemanticName(obj)
            % Using eval to ensure it also works for empty objects:
            semanticName = eval(sprintf('%s.X_TYPE', class(obj)));
        end
    end
    
    methods (Static, Access = protected, Hidden)
        
        function shortSchemaName = getSchemaShortName(fullSchemaName)
        %getSchemaShortName Get short schema name from full schema name
        %
        %   shortSchemaName = getSchemaShortName(fullSchemaName)
        %
        %   Example:
        %   fullSchemaName = 'openminds.core.research.Subject';
        %   shortSchemaName = openminds.abstract.Schema.getSchemaShortName(fullSchemaName)
        %   shortSchemaName =
        %
        %     'Subject'

            import openminds.internal.utility.getSchemaName
            shortSchemaName = getSchemaName(fullSchemaName);
        end
    end
end

function x = row(x)
    assert(isrow(x) || iscolumn(x), 'Input must be a vector')
    if ~isrow(x)
        x = transpose(x);
    end
end
