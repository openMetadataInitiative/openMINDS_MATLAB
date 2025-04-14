classdef MetaTypeRegistry < handle & matlab.mixin.SetGet & matlab.mixin.Scalar
% MetaTypeRegistry - Singleton class representing registry of meta.type objects
%
% This class provides a centralized registry for meta.Type objects.
% It implements custom indexing to allow retrieval of type information using
% either type names or class names.
%
% Example:
%   registry = openminds.internal.meta.MetaTypeRegistry.getSingleton();
%   personType = registry('Person');
%   % Access type information
%   disp(personType.PropertyNames);
%
% See also: openminds.internal.meta.Type

    properties (Constant, Access = private)
        % Name used to store the singleton instance in application data
        SINGLETON_NAME = "MetaTypeRegistrySingleton"
    end

    properties (SetAccess = immutable)
        % ModelVersion - Version of the openMINDS model to use
        % Default is "latest"
        ModelVersion (1,1) string = "latest"
    end

    properties (Access = private)
        % Registry - Storage for cached Type objects
        % Uses dictionary in newer MATLAB versions, containers.Map in older ones
        Registry {mustBeA(Registry, ["dictionary", "containers.Map"])} = containers.Map %#ok<MCHDP>
    end

    properties (SetAccess = private)
        % AvailableVersions - List of available openMINDS model versions
        AvailableVersions (1,:) string = openminds.internal.listValidVersions()
    end
    
    properties (Access = private)
        % AvailableTypes - Enumeration of all available metadata types
        AvailableTypes (1,:) openminds.enum.Types
        
        % AvailableClassNames - String array of class names for all available types
        AvailableClassNames (1,:) string
    end
    
    methods (Static)
        % getSingleton - Method for retrieving singleton object
        % Defined in separate file in class folder
        singletonObject = getSingleton(options)
    end

    methods (Access = private)
        function obj = MetaTypeRegistry(options)
        % MetaTypeRegistry - Private constructor for singleton class
        %
        % Parameters:
        %   options.ModelVersion - Version of the openMINDS model to use
            arguments
                options.ModelVersion (1,1) string
            end
            
            obj.initializeCache()
            
            % Apply options
            obj.ModelVersion = options.ModelVersion;
            
            % Validate model version
            if ~strcmp(obj.ModelVersion, "latest")
                openminds.mustBeValidVersion(obj.ModelVersion);
            end

            % Cache available types and class names for performance
            obj.AvailableTypes = enumeration('openminds.enum.Types');
            obj.AvailableClassNames = [obj.AvailableTypes.ClassName];
        end
    end

    methods
        function clearCache(obj)
        % clearCache - Clear the registry cache
        %
        % This method can be used to force reloading of Type objects
            obj.initializeCache()
        end
    end

    methods (Access = private)
        function initializeCache(obj)
            % Initialize registry using dictionary if available (R2022b+)
            % otherwise fall back to containers.Map
            if exist('dictionary', 'file')
                if exist('configureDictionary', 'file') % From R2023b
                    obj.Registry = configureDictionary('string', 'cell');
                else % Fallback for R2022b and R2023a
                    obj.Registry = dictionary(string.empty, {});
                end
            else
                obj.Registry = containers.Map();
            end
        end

        function isValid = isValidKey(obj, keyName)
        % isValidKey - Check if a key is valid for the registry
        %
        % Parameters:
        %   keyName - Name to check (type name or class name)
        %
        % Returns:
        %   isValid - True if the key is valid, false otherwise
            
            arguments
                obj (1,1) openminds.internal.meta.MetaTypeRegistry
                keyName (1,1) string
            end

            % Todo: Check validity against alias names of type class.
            
            % Check if the key matches either a type name or a class name
            isValid = any(ismember(obj.AvailableTypes, keyName)) || ...
                     any(ismember(obj.AvailableClassNames, keyName));
        end
        
        function validateKey(obj, keyName)
        % validateKey - Check if a registry key is valid and throw error if not
            arguments
                obj (1,1) openminds.internal.meta.MetaTypeRegistry
                keyName (1,1) string
            end

            % Validate the key
            if ~obj.isValidKey(keyName)
                ME = MException(...
                    "OPENMINDS_MATLAB:MetaTypeRegistry:InvalidKey", ...
                    ['"%s" is not a valid name or classname for an openMINDS ', ...
                    'metadata type of version "%s".'], keyName, obj.ModelVersion);
                throwAsCaller(ME)
            end
        end
    end

    methods (Access=protected)
        function varargout = parenReference(obj, indexOp)
        % parenReference - Implements obj(...) indexing behavior
        %
        % This method allows retrieving Type objects using either their type name
        % or class name as a key, e.g., registry('Person') or registry('openminds.core.Person')
            
            % Extract the key name from the indexing operation
            keyName = indexOp(1).Indices{1};

            obj.validateKey(keyName)

            if any(ismember(obj.AvailableTypes, keyName))
                % Key is a type name (e.g., 'Person')
                typeEnum = openminds.enum.Types(keyName);
            else
                % Key is a class name (e.g., 'openminds.core.Person')
                typeEnum = openminds.enum.Types.fromClassName(keyName);
                keyName = string(typeEnum);
            end

            % Check if the type is already in the registry
            if isKey(obj.Registry, keyName)
                % Retrieve from cache
                metaType = obj.Registry(keyName);
                if iscell(metaType)
                    metaType = metaType{1};
                end
            else
                % Create and cache a new object
                metaType = openminds.internal.meta.Type(typeEnum.ClassName);
                obj.Registry(keyName) = {metaType};
            end
            
            % Handle the output based on the indexing operation
            if isscalar(indexOp)
                varargout{1} = metaType;
            else
                % Forward additional indexing to the Type object
                [varargout{1:nargout}] = metaType.(indexOp(2:end));
            end
        end

        function obj = parenAssign(~, ~, ~) %#ok<STOUT>
        % parenAssign - Implements obj(...) = value assignment behavior
        %
        % This registry is read-only, so assignment operations are not supported
            error("OPENMINDS_MATLAB:MetaTypeRegistry:UnsupportedIndexingOperation", ...
                'This registry is read-only and does not support assignment operations')
        end

        function n = parenListLength(obj, indexOp, ctx)
        % parenListLength - Implements length calculation for indexing operations
        %
        % This method is called when determining the number of outputs for
        % comma-separated list expansion with indexing
            if numel(indexOp) <= 1
                n = 1;
                return;
            end
            
            % Forward to the contained object for nested indexing
            metaType = obj.(indexOp(1));
            n = listLength(metaType, indexOp(2:end), ctx);
        end

        function obj = parenDelete(~, ~) %#ok<STOUT>
        % parenDelete - Implements delete obj(...) behavior
        %
        % This registry is read-only, so deletion operations are not supported
            error("OPENMINDS_MATLAB:MetaTypeRegistry:UnsupportedIndexingOperation", ...
                'This registry is read-only and does not support deletion operations')
        end
    end
end
