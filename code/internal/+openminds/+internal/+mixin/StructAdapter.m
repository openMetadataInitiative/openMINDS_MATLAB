classdef StructAdapter < handle & matlab.mixin.SetGet
%StructAdapter Facility for converting objects to struct
%
%   Inherit from this class to provide your class with methods for
%   converting an object to and from a struct. The options properties of
%   this class can be used to determine what properties to include based on
%   the property attributes.
%
%   Add names of object superclasses in the ExcludeSuperclass property to
%   exclude properties from certain superclasses.

    properties (Hidden) % Options
        IncludeHidden (1,1) logical = false
        IncludeTransient (1,1) logical = false
        IncludeDependent (1,1) logical = false
        IncludePrivate (1,1) logical = false
        ExcludeSuperclass (1,:) cell = {} % Cell array with names of superclasses to exclude (Todo)
    end
    
    properties (Access = private)
        % Cache names of properties that should be included in struct
        PropertyNames_ cell
    end

    properties (Hidden, Dependent)
        PropertyNames
    end

    properties (Constant, Access = private)
        PROPERTY_NAMES_SELF = openminds.internal.mixin.StructAdapter.getOwnPropertyNames()
    end
    
    % Public methods for converting object array to/from struct or table
    methods

        function S = toStruct(obj, recursive)

            if nargin < 2
                recursive = false;
            end
            
            % Todo: Does the following support arrays?

            % Get all values for properties that should be retrieved
            values = get(obj, obj(1).PropertyNames);
            
            % Assign names and values to a struct.
            S = cell2struct(values, obj(1).PropertyNames, 2);

            % Check if any of the properties values are themselved objects
            % of the structAdapter class and convertible to structs
            for iProp = 1:numel(obj(1).PropertyNames)
                thisProp = obj(1).PropertyNames{iProp};
                for jInstance = 1:numel(S) % Account for arrays?
                    if isa( S(jInstance).(thisProp), 'openminds.internal.mixin.StructAdapter' ) && recursive
                        if numel( S(jInstance).(thisProp)) == 0
                            S(jInstance).(thisProp) = struct.empty;
                        else
                            S(jInstance).(thisProp) = S(jInstance).(thisProp).toStruct();
                        end
                    end
                end
            end
        end

        function obj = fromStruct(obj, S)
        %Create instance/list of instances from a struct array
            
            numInstances = numel(S);
            obj(numInstances) = feval(class(obj));

            allowedPropertyNames = [obj(1).PropertyNames];

            for i = 1:numInstances
                C = struct2cell(S(i));
                fieldNames = fieldnames(S(i));
                [fieldNames, iA] = intersect(fieldNames', allowedPropertyNames, 'stable');

                propertyValues = C(iA);
    
                % If empty values are not of correct type, setting them
                % will cause error. Therefore we skip setting empty values
                keep = cellfun(@(c) ~isempty(c), propertyValues);
                propertyNames = fieldNames(keep);
                propertyValues = propertyValues(keep);
               
                set(obj(i), propertyNames', propertyValues');
                
                if isfield(S, 'at_id') % Not present for embedded values
                    obj(i).assignInstanceId( S(i).at_id );
                end
            end

            if ~nargout
                clear obj
            end
        end
    
        function T = toTable(obj)
            S = obj.toStruct();
            T = struct2table(S, 'AsArray', true);
        end

        function fromTable(obj, T)
            S = table2struct(T);
            obj.fromStruct(S)
        end
    end
    
    % Set/get methods
    methods
        
        function set.IncludeHidden(obj, newValue)
            obj.IncludeHidden = newValue;
            obj.updatePropertyNames()
        end
                
        function set.IncludeTransient(obj, newValue)
            obj.IncludeTransient = newValue;
            obj.updatePropertyNames()
        end

        function set.IncludeDependent(obj, newValue)
            obj.IncludeDependent = newValue;
            obj.updatePropertyNames()
        end

        function set.IncludePrivate(obj, newValue)
            obj.IncludePrivate = newValue;
            obj.updatePropertyNames()
        end
        
        function propertyNames = get.PropertyNames(obj)
            if isempty(obj.PropertyNames_)
                propertyNames = assignPropertyNames(obj);
            else
                propertyNames = obj.PropertyNames_;
            end
        end
    end
    
    % Methods for updating list of property names
    methods (Access = private)
        
        function propertyNames = assignPropertyNames(obj)
        %assignPropertyNames Assign (initialize) the list of property names
            obj.PropertyNames_ = cell({''}); % Set to non-empty
            obj.updatePropertyNames()
            
            if nargout
                propertyNames = obj.PropertyNames_;
            end
        end

        function updatePropertyNames(obj)
        %updatePropertyNames Update the list of cached property names
            if isempty(obj.PropertyNames_); return; end
            
            mc = metaclass(obj);
            classPropertyList = mc.PropertyList;

            % Get all property names
            propertyNames = {classPropertyList.Name};

            % Exclude all properties that are members of the StructAdapter
            % class.
            [propertyNames, keep] = setdiff(propertyNames, obj.PROPERTY_NAMES_SELF);
            classPropertyList = classPropertyList(keep);

            isHidden = [ classPropertyList.Hidden ];
            isTransient = [ classPropertyList.Transient ];
            isDependent = [ classPropertyList.Dependent ];

            isPrivateGet = ~contains({classPropertyList.GetAccess}, 'public');
            isPrivateSet = ~contains({classPropertyList.SetAccess}, 'public');
            
            % Todo: Refine this
            isPrivate = isPrivateGet | isPrivateSet;

            keep = true(1, numel(propertyNames));

            if ~obj.IncludeHidden
                keep(isHidden) = false;
            end

            if ~obj.IncludeTransient
                keep(isTransient) = false;
            end

            if ~obj.IncludeDependent
                keep(isDependent) = false;
            end

            if ~obj.IncludePrivate
                keep(isPrivate) = false;
            end

            obj.PropertyNames_ = propertyNames(keep);
        end
    end
    
    methods (Static, Access = private)
        function propertyNames = getOwnPropertyNames()
        %getOwnPropertyNames Get list of property names for this superclass
            mc = meta.class.fromName('openminds.internal.mixin.StructAdapter');
            propertyNames = {mc.PropertyList.Name};
        end
    end
end
