classdef FolderMetadataStore < openminds.interface.MetadataStore
% FolderMetadataStore - Metadata store implementation for folder-based metadata files
%
% This class handles saving and loading openMINDS Collections to/from
% multiple metadata files organized in a folder structure using a configurable serializer.
%
% USAGE:
%   store = FolderMetadataStore("metadata_folder");  % Flat structure (default)
%   store = FolderMetadataStore("metadata_folder", 'Nested', true);  % Nested structure
%   store.save(instances);
%   loadedInstances = store.load();

    properties (SetAccess = immutable)
        Location (1,1) string  % Folder path for saving/loading
        Nested (1,1) logical    % Whether to use nested folder structure
    end

    methods
        function obj = FolderMetadataStore(folderPath, options)
            arguments
                folderPath (1,1) string
                options.Nested (1,1) logical = false
                options.Serializer = []
                options.RecursionDepth (1,1) {mustBeInteger, mustBeNonnegative} = 0
                options.PrettyPrint (1,1) logical = true
                options.PropertyNameSyntax (1,1) string {mustBeMember(options.PropertyNameSyntax, ["compact","expanded"])} = "compact"  
                options.IncludeEmptyProperties (1,1) logical = false
                options.IncludeIdentifier (1,1) logical = true
            end
            
            % Call parent constructor
            obj = obj@openminds.interface.MetadataStore();
            
            % Set immutable properties
            obj.Location = folderPath;
            obj.Nested = options.Nested;
            
            % Create JsonLdSerializer if not provided
            if isempty(options.Serializer)
                obj.Serializer = openminds.internal.serializer.JsonLdSerializer(...
                    'RecursionDepth', options.RecursionDepth, ...
                    'PrettyPrint', options.PrettyPrint, ...
                    'PropertyNameSyntax', options.PropertyNameSyntax, ...
                    'IncludeEmptyProperties', options.IncludeEmptyProperties, ...
                    'IncludeIdentifier', options.IncludeIdentifier, ...
                    'OutputMode', 'multiple');
            else
                obj.Serializer = options.Serializer;
                % Todo: Update serialiser with provided options?
                % Or, warn that we are using provided serializer and
                % ignoring serializer options
            end
        end
    end

    methods
        function outputPaths = save(obj, instances, options)
        %save Save openMINDS instances to multiple JSON-LD files in a folder
        %
        %   outputPaths = save(obj, instances)
        %   outputPaths = save(obj, instances, options)
        %
        %   PARAMETERS:
        %   -----------
        %   instances : openminds.abstract.Schema, cell array, or openminds.Collection
        %       Instance(s) to save
        %   options : struct (optional)
        %       Additional options (implementation-specific)
        %
        %   RETURNS:
        %   --------
        %   outputPaths : cell array of strings
        %       Paths to the created files
            
            arguments
                obj (1,1) openminds.internal.FolderMetadataStore
                instances % openminds.abstract.Schema, cell array, or openminds.Collection
                options struct = struct() %#ok<INUSA>
            end
            
            % Handle Collection objects
            if isa(instances, 'openminds.Collection')
                instances = instances.getAll();
            end
            
            % Ensure folder exists
            if ~isfolder(obj.Location)
                mkdir(obj.Location);
            end

            if ~iscell(instances)
                instances = num2cell(instances);
            end
            
            % Serialize instances to individual documents
            serializedDocuments = obj.Serializer.serialize(instances);
            
            % Save each document to a separate file
            outputPaths = cell(size(serializedDocuments));
            for i = 1:numel(serializedDocuments)
                instance = instances{i};
                
                % Build file path using unified method
                filePath = obj.buildFilepath(instance);
                
                % Write to file
                openminds.internal.utility.filewrite(filePath, serializedDocuments{i});
                outputPaths{i} = filePath;
            end
        end
        
        function instances = load(obj, options)
        %load Load openMINDS instances from JSON-LD files in a folder
        %
        %   instances = load(obj)
        %   instances = load(obj, options)
        %
        %   PARAMETERS:
        %   -----------
        %   options : struct (optional)
        %       Additional options (implementation-specific)
        %       - Recursive : logical (default: true) - search subfolders
        %
        %   RETURNS:
        %   --------
        %   instances : cell array
        %       Cell array of openminds.abstract.Schema instances
            
            arguments
                obj (1,1) openminds.internal.FolderMetadataStore
                options.Recursive (1,1) logical = true
            end
            
            if ~isfolder(obj.Location)
                error('openminds:FolderMetadataStore:FolderNotFound', ...
                    'Folder not found: %s', obj.Location);
            end
            
            % Find all metadata files in the folder
            filePattern = sprintf('*%s', obj.Serializer.DefaultFileExtension);
            if options.Recursive
                fileListing = dir(fullfile(obj.Location, '**', filePattern));
            else
                fileListing = dir(fullfile(obj.Location, filePattern));
            end
            
            if isempty(fileListing)
                instances = {};
                return;
            end
            
            % Get full file paths
            filePaths = string(fullfile({fileListing.folder}, {fileListing.name}));
            
            % Use the existing loadInstances functionality
            instances = openminds.internal.store.loadInstances(obj.Location);
        end
    end
    
    methods (Access = private)
        function instanceFilePath = buildFilepath(obj, instance)
        %buildFilepath Build complete filepath for an instance
        %
        %   Creates the appropriate file path based on the store's Nested property.
        %   For flat structure: saves all files in root folder with type prefix
        %   For nested structure: creates type-based subfolders with ID-only filenames
        %
        %   PARAMETERS:
        %   -----------
        %   instance : openminds.abstract.Schema
        %       The instance to generate a filepath for
        %
        %   RETURNS:
        %   --------
        %   instanceFilePath : string
        %       Complete file path for the instance
        %
        %   EXAMPLES:
        %   ---------
        %   Flat:   /root/Person_123.jsonld
        %   Nested: /root/person/123.jsonld
        
            % Get instance type and ID information
            className = class(instance);
            classNameParts = strsplit(className, '.');
            typeName = classNameParts{end};
            
            % Get instance ID and make it filesystem-safe
            instanceId = string(instance.id);
            if startsWith(instanceId, "http")
                idParts = strsplit(instanceId, '/');
                safeId = idParts{end};
            else
                safeId = instanceId;
            end
            safeId = regexprep(safeId, '[^\w\-_.]', '_');
            
            if obj.Nested
                % Nested structure: create type subfolder + ID-only filename
                typeFolder = lower(typeName);
                saveFolder = fullfile(obj.Location, typeFolder);
                if ~isfolder(saveFolder)
                    mkdir(saveFolder);
                end
                filename = sprintf('%s%s', safeId, obj.Serializer.DefaultFileExtension);
                instanceFilePath = fullfile(saveFolder, filename);
            else
                % Flat structure: type prefix + ID in root folder
                filename = sprintf('%s_%s%s', typeName, safeId, obj.Serializer.DefaultFileExtension);
                instanceFilePath = fullfile(obj.Location, filename);
            end
        end
    end
end
