classdef Type < handle
% Type - Provides information about a type derived from an openMINDS metadata schema.
%
%   Provides utility methods for checking various property attributes of a 
%   metadata type derived from an openMINDS metadata schema.
%
%   This class is meant to be used by internal/external applications that
%   need to infer schema constraints that are implicitly coded into the 
%   generated type classes, but not necessarily explcitly expressed.

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

            mp = obj.getMetaProperty(propertyName);
            
            if obj.isPropertyWithLinkedType(propertyName) || ...
                    obj.isPropertyWithEmbeddedType(propertyName)
                validationFcn = mp.Validation.ValidatorFunctions;
                
                isScalar = @(str) contains(str, 'mustBeSpecifiedLength') && contains(str, '0,1)');
                tf = any( cellfun(@(c) isScalar(func2str(c)), validationFcn) );
            else
                if isa( mp.Validation.Size(2), 'meta.UnrestrictedDimension')
                    tf = false;
                elseif isa( mp.Validation.Size(2), 'meta.FixedDimension')
                    tf = mp.Validation.Size(2).Length == 1;
                else
                    error('Not implemented.') % Is this ever going to happen?
                end
            end
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
            mp = obj.getMetaProperty(propertyName);
            className = mp.Validation.Class.Name;
            tf = startsWith(className, 'openminds.internal.mixedtype');
        end

        function className = getMixedTypeForProperty(obj, propertyName)
        % getMixedTypeForProperty - Get class name of MixedTypeSet for given property
            mp = obj.getMetaProperty(propertyName);
            className = mp.Validation.Class.Name;
            assert( startsWith(className, 'openminds.internal.mixedtype'), ...
                'Property is not a mixed type' );
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
