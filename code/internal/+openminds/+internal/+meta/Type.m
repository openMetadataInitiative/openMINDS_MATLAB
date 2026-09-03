classdef Type < handle
% Type - Provides information about a type derived from an openMINDS metadata schema.
%
%   Provides utility methods for checking various property attributes of a
%   metadata type derived from an openMINDS metadata schema.
%
%   This class is meant to be used by internal/external applications that
%   need to infer schema constraints that are implicitly coded into the
%   generated type classes, but not necessarily explicitly expressed.

    properties (SetAccess = immutable)
        Name char                   % (Short) Name of openMINDS metadata type
        ClassName char              % Full MATLAB class name of of openMINDS metadata type
        PropertyNames (1,:) string  % List of property names for a metadata type
    end

    properties (Dependent)
        NumProperties
        MetaClassHandle meta.class
    end

    properties (Access = private)
        PropertyNamesAll (1,:) string
        CachedMetaClassHandle meta.class
    end

    methods % Constructor
        function obj = Type(varargin)
            
            if isa(varargin{1}, 'char') || isa(varargin{1}, 'string')
                obj.ClassName = varargin{1};
            elseif openminds.utility.isInstance(varargin{1})
                obj.ClassName = class(varargin{1});
            else
                error('Unsupported input type')
            end

            splitClassName = strsplit(obj.ClassName, '.');
            obj.Name = splitClassName{end};
            
            % obj.countProperties()
            obj.PropertyNames = obj.getPublicProperties();
            obj.PropertyNamesAll = string( {obj.MetaClassHandle.PropertyList.Name} );
            
            if ~nargout
                clear obj
            end
        end
    end

    methods
        function n = get.NumProperties(obj)
            n = numel(obj.PropertyNames);
        end

        function value = get.MetaClassHandle(obj)
            if isempty(obj.CachedMetaClassHandle) || ~isvalid(obj.CachedMetaClassHandle)
                obj.CachedMetaClassHandle = meta.class.fromName(obj.ClassName);
            end
            value = obj.CachedMetaClassHandle;
        end
    end

    methods (Static, Access = private)

        function tf = hasScalarValidator(metaProperty)
        % hasScalarValidator - Check for a mustBeScalarOrEmpty validator

            tf = false;
            if isempty(metaProperty.Validation)
                return
            end

            validatorFunctions = metaProperty.Validation.ValidatorFunctions;
            tf = any( cellfun(@(c) contains(func2str(c), 'mustBeScalarOrEmpty'), ...
                validatorFunctions) );
        end

        function tf = hasScalarSizeDeclaration(metaProperty)
        % hasScalarSizeDeclaration - Check for a size declaration of (1,1)

            tf = false;
            if isempty(metaProperty.Validation) || isempty(metaProperty.Validation.Size)
                return
            end

            columnDimension = metaProperty.Validation.Size(2);

            % Any dimension that is not fixed leaves the property
            % unrestricted in size, so it is not scalar.
            if isa(columnDimension, 'meta.FixedDimension')
                tf = columnDimension.Length == 1;
            end
        end

        function className = getDeclaredClassName(metaProperty)
        % getDeclaredClassName - Class a property is restricted to, if any
        %
        %   Returns an empty string for a property declared without a
        %   class, such as one whose type could not be resolved when the
        %   type classes were generated.

            className = "";
            if isempty(metaProperty.Validation) || isempty(metaProperty.Validation.Class)
                return
            end
            className = string(metaProperty.Validation.Class.Name);
        end
    end

    methods (Access = private)
        
        function metaProperty = getMetaProperty(obj, propertyName)
            propertyIndex = obj.PropertyNamesAll == string(propertyName);
            metaProperty = obj.MetaClassHandle.PropertyList(propertyIndex);
        end
        
        function propertyNames = getPublicProperties(obj)
            propertyNames = {obj.MetaClassHandle.PropertyList.Name};
            propSetAccess = {obj.MetaClassHandle.PropertyList.SetAccess};
            isPublic = cellfun(@(c) strcmp(c, 'public'), propSetAccess);
            isHidden = [obj.MetaClassHandle.PropertyList.Hidden];
            
            propertyNames = propertyNames(isPublic & ~isHidden);
        end
    end

    methods (Access = public)

        function tf = isPropertyValueScalar(obj, propertyName)
        % isPropertyValueScalar - Check if property value must be scalar

            metaProperty = obj.getMetaProperty(propertyName);

            % A property can be restricted to a scalar in two ways: a
            % mustBeScalarOrEmpty validator, or a fixed size declaration.
            % Linked and embedded properties are declared (1,:) and always
            % use the validator, but a property holding a primitive value
            % may use either, so both have to be checked for every
            % property.
            tf = obj.hasScalarValidator(metaProperty) || ...
                    obj.hasScalarSizeDeclaration(metaProperty);
        end

        function tf = isPropertyWithLinkedType(obj, propertyName)
        % isPropertyWithLinkedType - Check if property has linked types.
            
            mp = obj.getMetaProperty('LINKED_PROPERTIES');
            % DefaultValue is a struct where each field is corresponding to
            % one property
            tf = isfield( mp.DefaultValue, propertyName );
        end

        function tf = isPropertyWithEmbeddedType(obj, propertyName)
        % isPropertyWithEmbeddedType - Check if property has embedded types.
        
            mp = obj.getMetaProperty('EMBEDDED_PROPERTIES');
            
            % DefaultValue is a struct where each field is corresponding to
            % one property
            tf = isfield( mp.DefaultValue, propertyName );
        end
                
        function linkedTypesForProperty = listLinkedTypesForProperty(obj, propertyName)
        % listLinkedTypesForProperty - Return list of linked types that are allowed for given property.
            if obj.isPropertyWithLinkedType(propertyName)
                mp = obj.getMetaProperty('LINKED_PROPERTIES');
                linkedTypesForProperty =  mp.DefaultValue.(propertyName);
            else
                error('Property %s does not have linked types', propertyName);
            end
        end

        function embeddedTypesForProperty = listEmbeddedTypesForProperty(obj, propertyName)
        % listEmbeddedTypesForProperty - Return list of embedded types that are allowed for given property.
            if obj.isPropertyWithEmbeddedType(propertyName)
                mp = obj.getMetaProperty('EMBEDDED_PROPERTIES');
                embeddedTypesForProperty =  mp.DefaultValue.(propertyName);
            else
                error('Property %s does not have embedded types', propertyName);
            end
        end

        function tf = isPropertyMixedType(obj, propertyName)
        % isPropertyMixedType - Check if property has linked or embedded MixedTypeSets.
            metaProperty = obj.getMetaProperty(propertyName);
            declaredClass = obj.getDeclaredClassName(metaProperty);

            % A property without a declared class cannot be a mixed type.
            tf = declaredClass ~= "" && ...
                    startsWith(declaredClass, 'openminds.internal.mixedtype');
        end

        function className = getMixedTypeForProperty(obj, propertyName)
        % getMixedTypeForProperty - Get class name of MixedTypeSet for given property
            metaProperty = obj.getMetaProperty(propertyName);
            className = obj.getDeclaredClassName(metaProperty);

            if className == "" || ~startsWith(className, 'openminds.internal.mixedtype')
                error('OPENMINDS_MATLAB:MetaType:NotAMixedType', ...
                    'Property "%s" of "%s" is not a mixed type.', ...
                    propertyName, obj.Name)
            end
        end

        function tf = isLinkedTypeOfAnyProperty(obj, type)
        % isLinkedTypeOfAnyProperty - Check if a given type can be linked
        % from any property of this type

            arguments
                obj (1,1) openminds.internal.meta.Type
                type (1,1) openminds.enum.Types
            end

            tf = false;

            linkedTypeInfo = obj.getMetaProperty('LINKED_PROPERTIES').DefaultValue;

            propertyNames = fieldnames( linkedTypeInfo );

            for i = 1:numel(propertyNames)
                types = linkedTypeInfo.(propertyNames{i});

                for j = 1:numel(types)
                    thisType = types{j};

                    tf = strcmp(thisType, type.ClassName);
                    if tf; return; end
                end
            end
        end

        function propertyName = linkedTypeOfProperty(obj, type)
            % Get property name which can be linked to given type
                    
            arguments
                obj (1,1) openminds.internal.meta.Type
                type (1,1) openminds.enum.Types
            end

            linkedTypeInfo = obj.getMetaProperty('LINKED_PROPERTIES').DefaultValue;

            propertyNamesWithLinkedType = fieldnames( linkedTypeInfo );

            for i = 1:numel(propertyNamesWithLinkedType)
                types = linkedTypeInfo.(propertyNamesWithLinkedType{i});

                for j = 1:numel(types)
                    thisType = types{j};

                    tf = strcmp(thisType, type.ClassName);
                    if tf
                        propertyName = propertyNamesWithLinkedType{i};
                        return
                    end
                end
            end

            error('OPENMINDS_MATLAB:MetaType:NotALinkedType', ...
                '"%s" is not a linked type of any properties of "%s"', type, obj.Name)
        end
    end

    methods (Static, Hidden)
        function metaProperty = getMetaPropertyStatic(propertyList, propertyName)
            propNames = {propertyList.Name};
            propertyIndex = strcmp(propNames, propertyName);

            metaProperty = propertyList(propertyIndex);
        end
    end
end
