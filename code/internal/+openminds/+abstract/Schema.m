classdef Schema < handle & openminds.internal.extern.uiw.mixin.AssignPVPairs & ...
                  openminds.internal.mixin.CustomInstanceDisplay & openminds.internal.mixin.StructAdapter
% Schema Abstract base class shared by all concrete Schema classes

% Todo:
%   [ ] Validate schema. I.e are all required variables filled out
%   [ ] Do some classes have to inherit from a mixin.Heterogeneous class?
%   [ ] Should controlled term instances be coded as enumeration classes?
%   [ ] Distinguish embedded from linked types.
%   [ ] Implement ismember and other methods doing "logic" on sets?

    properties (Constant, Hidden) % Move to instance/serializer
        VOCAB = "https://openminds.ebrains.eu/vocab/"
    end

    properties (SetAccess = protected, Hidden) % Todo: SetAccess = immutable
        id char = ''
    end

    properties (Abstract, Access = protected)
        Required
    end
    
    properties (Abstract, Constant, Hidden)
        X_TYPE (1,1) string
    end

    properties (Abstract, Constant, Hidden)
        LINKED_PROPERTIES struct %todo: name and classname, not openminds uri
        EMBEDDED_PROPERTIES struct
    end

    events % Todo: Remove??
        InstanceChanged
        PropertyWithLinkedInstanceChanged
    end

    methods % Constructor
        
        function obj = Schema(varargin)

            % Todo: Assign in subclass constructors?
            if ~isa(obj, 'openminds.abstract.ControlledTerm')
                obj.id = obj.generateInstanceId();
            end

            if numel(varargin)==1 && isstruct(varargin{1}) % Create scalar
                obj = obj.fromStruct(varargin{1});
            elseif numel(varargin)==1 && iscell(varargin{1}) % Create non-scalar
                for i = 1:numel( varargin{1} )
                    obj(i) = feval( class(obj) ); %#ok<AGROW>
                    obj(i) = obj(i).fromStruct(varargin{1}{i}); %#ok<AGROW>
                end
            elseif numel(varargin)==1
                error('Not implemented for input arguments of type %s.', class(varargin{1}))
            else
                [varargin, id] = obj.removeArg('id', varargin{:});
                if ~isempty(id)
                    obj.id = id; % Assign provided id
                end
                obj.assignPVPairs(varargin{:})
            end
        end
    end

    methods (Access = public, Hidden)
        function linkedTypeList = getLinkedTypes(obj)
            linkedTypeList = {};
            linkedPropertyNames = fieldnames(obj.LINKED_PROPERTIES);
            
            for propName = string( row(linkedPropertyNames) )
                propValue = obj.(propName);
                if ~isempty( propValue )
                    % Concatenate instances in a cell array
                    if openminds.utility.isMixedInstance(propValue)
                        linkedTypeList = [linkedTypeList, {propValue.Instance}]; %#ok<AGROW>
                    elseif openminds.utility.isInstance(propValue)
                        linkedTypeList = [linkedTypeList, num2cell(propValue)]; %#ok<AGROW>
                    end
                end
            end
        end

        function embeddedTypeList = getEmbeddedTypes(obj)
            embeddedTypeList = {};
            embeddedPropertyNames = fieldnames(obj.EMBEDDED_PROPERTIES);
            
            for propName = string( row(embeddedPropertyNames) )
                propValue = obj.(propName);
                if ~isempty( propValue )
                    if openminds.utility.isMixedInstance(propValue)
                        embeddedTypeList = [embeddedTypeList, {propValue.Instance}]; %#ok<AGROW>
                    elseif openminds.utility.isInstance(propValue)
                        embeddedTypeList = [embeddedTypeList, num2cell(propValue)]; %#ok<AGROW>
                    end
                end
            end
        end
    end

    methods (Access = public, Hidden)
        
        function tf = isPropertyWithLinkedType(obj, propertyName)
            % Return true if property value is a linked type.
            propertyNamesWithLinkedType = fieldnames(obj.LINKED_PROPERTIES);
            tf = any( strcmp(propertyNamesWithLinkedType, propertyName) );
        end

        function linkedTypesForProperty = getLinkedTypesForProperty(obj, propertyName)
            % Return linked types that are allowed for given property.
            if obj.isPropertyWithLinkedType(propertyName)
                linkedTypesForProperty = obj.LINKED_PROPERTIES.(propertyName);
            else
                error('Property %s does not have linked types', propertyName);
            end
        end

        function tf = isLinkedTypeOfProperty(obj, type)
        %isLinkedTypeOfProperty ???
            tf = false;
            
            propertyNames = fieldnames( obj.LINKED_PROPERTIES );

            for i = 1:numel(propertyNames)
                types = obj.LINKED_PROPERTIES.(propertyNames{i});

                for j = 1:numel(types)
                    thisType = types{j};

                    tf = strcmp(thisType, type);
                    if tf; return; end

                    thisTypeSplit = strsplit(thisType, '/');
                    tf = strcmp(thisTypeSplit{end}, type);
                    if tf; return; end
                end
            end
        end

        function propertyName = linkedTypeOfProperty(obj, type)
            % Get property name which can be linked to given type
            propertyName = obj.linkedTypeOfPropertyStatic(type, obj.LINKED_PROPERTIES);
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

                if numel(subs) == 1
                    propName = subs(1).subs;
                    className = class(obj.(propName));
                
                    % Get the actual instance from a linkset subclass.
                    if contains(className, 'openminds.internal.mixedtype')
                        try
                            % Place the openMINDS instance object in a linkset
                            % wrapper class
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
                    if numel(subs) == 1
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
                                % Old value was not assigned, expanding
                                % array
                                obj = builtin('subsasgn', obj, subs, value);
                        end
                    end
                else
                    oldValue = [];
                end
                
                obj = builtin('subsasgn', obj, subs, value);

                if numel(obj) >= 1
                    if obj.isSubsForPublicPropertyValue(subs)
                        evtData = PropertyValueChangedEventData(value, oldValue, false); % false for unlinked prop
                        obj.notify('InstanceChanged', evtData)
                        % fprintf('Set unlinked property of %s\n', class(obj))
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
                    builtin('subsref', obj, subs)
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
            if numel( unique(instanceType) ) == 1
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
        function instanceId = generateInstanceId(obj)
        %generateInstanceId Generate a unique instance id.
            schemaName = obj.getSchemaShortName( class(obj) );
            uuidStr = openminds.internal.utility.string.getuuid();
            instanceId = sprintf('%s/%s', schemaName, uuidStr);
        end
    end

    methods (Access = protected)
        function displayLabel = getDisplayLabel(obj)
            %schemaShortName = obj.getSchemaShortName(class(obj));

            % Use regexp to extract to schema name and the first part
            % of the uuid
            str = regexp(obj.id, '^\w*-\w*(?=-)', 'match', 'once');
            displayLabel = sprintf("%s", str);
        end

        function str = createLabelForMissingLabelDefinition(obj)
            classNames = split( class(obj), '.');
            str = sprintf('<Unlabeled %s>', classNames{end});
        end

        function annotation = getAnnotation(obj)

            import openminds.internal.utility.getSchemaDocLink

            % annotation = obj.getSchemaShortName(class(obj));
            annotation = getSchemaDocLink( class(obj) );
        end

        function requiredProperties = getRequiredProperties(obj)
            requiredProperties = obj.Required;
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

    methods (Static, Hidden)
        
        function propertyName = linkedTypeOfPropertyStatic(type, linkedTypeProperties)
            propertyName = "";
            propertyNamesWithLinkedType = fieldnames( linkedTypeProperties );

            for i = 1:numel(propertyNamesWithLinkedType)
                types = linkedTypeProperties.(propertyNamesWithLinkedType{i});

                for j = 1:numel(types)
                    thisType = types{j};

                    tf = strcmp(thisType, type);
                    if tf
                        propertyName = propertyNamesWithLinkedType{i};
                        return
                    end

                    thisTypeSplit = strsplit(thisType, '/');
                    tf = strcmp(thisTypeSplit{end}, type);
                    if tf
                        propertyName = propertyNamesWithLinkedType{i};
                        return
                    end
                end
            end
        end
    end
end

function x = row(x)
    assert(isrow(x) || iscolumn(x), 'Input must be a vector')
    if ~isrow(x)
        x = transpose(x);
    end
end
