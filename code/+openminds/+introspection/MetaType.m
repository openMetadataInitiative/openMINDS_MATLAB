classdef MetaType < handle
% MetaType - Describes the properties of an openMINDS metadata type.
%
%   Syntax:
%       metaType = openminds.introspection.MetaType(instance)
%           describes the type of a metadata instance.
%
%       metaType = openminds.introspection.MetaType(className)
%           describes the type named by a fully qualified class name.
%
%   Description:
%       A generated type class encodes the constraints of its schema in the
%       validators and size declarations of its properties, where they are
%       hard to read back. This class answers questions about them directly:
%       whether a property holds one value or many, whether it links to
%       another node, embeds one, or accepts several types, and which types
%       those are. Tools that build interfaces or walk a graph need those
%       answers and should not have to parse property declarations.
%
%   Input Arguments:
%       instance  - Any openMINDS metadata instance.
%       className - Fully qualified class name, char or string.
%
%   Properties:
%       Name                 - Short name of the type, such as "Subject"
%       ClassName            - Fully qualified MATLAB class name
%       PropertyNames        - Public property names of the type
%       NumProperties        - How many properties the type has
%       RenamedPropertyNames - Properties whose schema name is not their
%                              MATLAB name
%
%   A schema may spell a property name in a way that is not a valid MATLAB
%   identifier, such as "z-stepSize". The generated class then declares
%   the property under a valid name and records the schema name. Use
%   getSchemaPropertyName and getPropertyNameFromSchemaName to translate
%   between the two; for every other property they return the name given.
%   getPropertyNamesFromFieldNames maps the fields of a struct decoded by
%   jsondecode, which rewrites such a schema name, to property names.
%
%   Example:
%       metaType = openminds.introspection.MetaType("openminds.core.Subject");
%       metaType.isPropertyMixedType("species")
%
%   Note on caching:
%       This constructor builds a new object each time. Prefer
%       openminds.introspection.fromInstance or openminds.introspection.fromClassName, which
%       return cached objects and are cheaper when called repeatedly.
%
%   See also openminds.introspection.fromInstance, openminds.introspection.fromClassName

    properties (SetAccess = immutable)
        Name char                   % (Short) Name of openMINDS metadata type
        ClassName char              % Full MATLAB class name of of openMINDS metadata type
        PropertyNames (1,:) string  % List of property names for a metadata type
        RenamedPropertyNames (1,:) string  % Properties the schema names differently
    end

    properties (Dependent)
        NumProperties
        MetaClassHandle meta.class
    end

    properties (Access = private)
        PropertyNamesAll (1,:) string
        CachedMetaClassHandle meta.class

        % Schema name of each renamed property, keyed by MATLAB name. Read
        % from the PROPERTY_NAME_MAP constant the generated class carries
        % when it has such a property.
        SchemaNameOfProperty struct = struct()
    end

    properties (Constant, Access = private)
        PROPERTY_NAME_MAP_CONSTANT = "PROPERTY_NAME_MAP"
    end

    methods % Constructor
        function obj = MetaType(varargin)
            
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
            obj.SchemaNameOfProperty = obj.readPropertyNameMap();
            obj.RenamedPropertyNames = reshape( ...
                string(fieldnames(obj.SchemaNameOfProperty)), 1, []);

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

        function tf = hasDateValidator(metaProperty)
        % hasDateValidator - Check for a mustBeValidDate validator

            tf = false;
            if isempty(metaProperty.Validation)
                return
            end

            validatorFunctions = metaProperty.Validation.ValidatorFunctions;
            tf = any( cellfun(@(c) contains(func2str(c), 'mustBeValidDate'), ...
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

        function nameMap = readPropertyNameMap(obj)
        % readPropertyNameMap - The PROPERTY_NAME_MAP constant, or an empty struct
        %
        %   A generated class carries the constant only when a property of
        %   its schema has a name that is not a valid MATLAB identifier.

            nameMap = struct();
            metaProperty = obj.getMetaProperty(obj.PROPERTY_NAME_MAP_CONSTANT);
            if ~isempty(metaProperty) && metaProperty.HasDefault
                nameMap = metaProperty.DefaultValue;
            end
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

        function tf = hasRenamedProperties(obj)
        % hasRenamedProperties - Whether any property has a different schema name
            tf = ~isempty(obj.RenamedPropertyNames);
        end

        function schemaName = getSchemaPropertyName(obj, propertyName)
        % getSchemaPropertyName - The name the schema uses for a property
        %
        %   For most properties this is the property name itself. It
        %   differs when the schema name is not a valid MATLAB identifier.

            arguments
                obj (1,1) openminds.introspection.MetaType
                propertyName (1,1) string
            end

            if isfield(obj.SchemaNameOfProperty, propertyName)
                schemaName = string(obj.SchemaNameOfProperty.(propertyName));
            else
                schemaName = propertyName;
            end
        end

        function propertyName = getPropertyNameFromSchemaName(obj, schemaName)
        % getPropertyNameFromSchemaName - The property the schema name belongs to
        %
        %   The inverse of getSchemaPropertyName. A schema name that no
        %   property was renamed from is returned as it is, whether or not
        %   the type has a property of that name.

            arguments
                obj (1,1) openminds.introspection.MetaType
                schemaName (1,1) string
            end

            propertyName = schemaName;
            for renamedProperty = obj.RenamedPropertyNames
                if obj.getSchemaPropertyName(renamedProperty) == schemaName
                    propertyName = renamedProperty;
                    return
                end
            end
        end

        function propertyNames = getPropertyNamesFromFieldNames(obj, fieldNames)
        % getPropertyNamesFromFieldNames - The properties the fields of a decoded struct hold
        %
        %   jsondecode turns a schema name that is not a valid MATLAB
        %   identifier into one with matlab.lang.makeValidName, so
        %   "z-stepSize" arrives as the field "z_stepSize". Such a field is
        %   returned as the name of the property it belongs to. Every other
        %   field name is returned as it is, as is a decoded name when the
        %   struct also has a field named as the property, because the
        %   declared name takes precedence.

            arguments
                obj (1,1) openminds.introspection.MetaType
                fieldNames (1,:) string
            end

            propertyNames = fieldNames;
            for renamedProperty = obj.RenamedPropertyNames
                decodedName = matlab.lang.makeValidName(obj.getSchemaPropertyName(renamedProperty));
                isDecodedName = fieldNames == decodedName;
                if any(isDecodedName) && ~any(fieldNames == renamedProperty)
                    propertyNames(isDecodedName) = renamedProperty;
                end
            end
        end

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

        function tf = isPropertyDateOnly(obj, propertyName)
        % isPropertyDateOnly - Check if a datetime property holds a date
        %
        %   The schema distinguishes a date from a date-time. Both are
        %   held as datetime, and the generated classes mark a date with
        %   the mustBeValidDate validator.

            metaProperty = obj.getMetaProperty(propertyName);
            tf = obj.hasDateValidator(metaProperty);
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
        % getMixedTypeForProperty - Class name of the mixed-type container
        %
        %   Returns the name of the generated container class that holds the
        %   value of a property accepting more than one type.
        %
        %   Treat the result as an opaque handle to hand back to the toolbox,
        %   not as a name to construct from or to write into your own code.
        %   These classes are generated per property, they live in an
        %   internal namespace, and they are not part of the public API.
        %
        %   To ask which types a property accepts, which is usually the real
        %   question, use listLinkedTypesForProperty or
        %   listEmbeddedTypesForProperty. Both answer in public type names.
        %
        %   See also listLinkedTypesForProperty, listEmbeddedTypesForProperty,
        %   isPropertyMixedType, openminds.utility.isMixedInstance
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
                obj (1,1) openminds.introspection.MetaType
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
                obj (1,1) openminds.introspection.MetaType
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
