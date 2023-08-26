classdef SchemaInspector < handle
% Utility class for inspection of a Schema    

    properties (SetAccess = immutable, GetAccess = private)
        metaClassObject
    end

    properties (SetAccess = immutable)
        SchemaClassName
        PropertyNames
    end

    properties (Dependent)
        NumProperties
    end

    methods 

        function obj = SchemaInspector(varargin)
            
            if isa(varargin{1}, 'char')
                obj.metaClassObject = meta.class.fromName(varargin{1});
                obj.SchemaClassName = varargin{1};
            elseif isa(varargin{1}, 'openminds.abstract.Schema')
                obj.metaClassObject = metaclass(varargin{1});
                obj.SchemaClassName = class(varargin{1});
            end
            
            %obj.countProperties()
            obj.PropertyNames = obj.getPublicProperties();

            if ~nargout
                clear obj
            end
        end

    end

    methods 
        function n = get.NumProperties(obj)
            n = numel(obj.PropertyNames);
        end

    end

    methods (Access = private)
        
        function metaProperty = getMetaProperty(obj, propertyName)

            propNames = {obj.metaClassObject.PropertyList.Name};
            propertyIndex = strcmp(propNames, propertyName);

            metaProperty = obj.metaClassObject.PropertyList(propertyIndex);
        end

        function propertyNames = getPublicProperties(obj)
            propertyNames = {obj.metaClassObject.PropertyList.Name};
            propSetAccess = {obj.metaClassObject.PropertyList.SetAccess};
            isPublic = cellfun(@(c) strcmp(c, 'public'), propSetAccess);
            isHidden = [obj.metaClassObject.PropertyList.Hidden];
            
            propertyNames = propertyNames(isPublic & ~isHidden);
        end
        
    end


    methods (Access = public)

        function tf = isPropertyValueScalar(obj, propertyName)
        %isPropertyValueScalar Check if property value must be scalar

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
            % Return true if property value is a linked type.
            
            mp = obj.getMetaProperty('LINKED_PROPERTIES');
            % DefaultValue is a struct where each field is corresponding to
            % one property
            tf = isfield( mp.DefaultValue, propertyName );
        end

        function tf = isPropertyWithEmbeddedType(obj, propertyName)
            % Return true if property value is an embedded type.
            mp = obj.getMetaProperty('EMBEDDED_PROPERTIES');
            
            % DefaultValue is a struct where each field is corresponding to
            % one property
            tf = isfield( mp.DefaultValue, propertyName );
        end

    end

end