classdef FolderMetadataStore < openminds.interface.MetadataStore
% FolderMetadataStore - Metadata store implementation for folder-based metadata files
%
% This class handles saving and loading openMINDS Collections to/from
% multiple metadata files organized in a folder structure using a configurable serializer.
%
% Every node of the graph is written as a file of its own. Saving an
% instance also saves every instance reachable from it through links and
% embeddings, because a reference to a node that has no file could not be
% followed when the folder is loaded again.
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
                options.PrettyPrint (1,1) logical = true
                options.PropertyNameSyntax (1,1) string {mustBeMember(options.PropertyNameSyntax, ["compact","expanded"])} = "compact"
                options.IncludeEmptyProperties (1,1) logical = false
            end

            % Call parent constructor
            obj = obj@openminds.interface.MetadataStore();

            % Set immutable properties
            obj.Location = folderPath;
            obj.Nested = options.Nested;

            % Create JsonLdSerializer if not provided. The store flattens
            % the graph itself, so the serializer must not recurse into
            % links, and every document carries its identifier so it can
            % be linked to again on load. Neither is configurable here.
            if isempty(options.Serializer)
                obj.Serializer = openminds.internal.serializer.JsonLdSerializer(...
                    'RecursionDepth', 0, ...
                    'PrettyPrint', options.PrettyPrint, ...
                    'PropertyNameSyntax', options.PropertyNameSyntax, ...
                    'IncludeEmptyProperties', options.IncludeEmptyProperties, ...
                    'IncludeIdentifier', true, ...
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
        %   instances : openminds.Node, cell array, or openminds.Collection
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
                instances % openminds.Node, cell array, or openminds.Collection
                options struct = struct() %#ok<INUSA>
            end
            
            % Every node reachable from the given instances is written,
            % not only the instances themselves. The collection does the
            % flattening; a new one is built so a collection passed in is
            % left as it was.
            if isa(instances, 'openminds.Collection')
                instances = instances.getAll();
            elseif ~iscell(instances)
                instances = num2cell(instances);
            end
            instances = openminds.Collection(instances{:}).getAll();

            % Ensure folder exists
            if ~isfolder(obj.Location)
                mkdir(obj.Location);
            end

            % Serialize instances to individual documents. A single
            % instance serializes to one document rather than a cell, so
            % it is wrapped to keep the loop below uniform.
            serializedDocuments = obj.Serializer.serialize(instances);
            if ~iscell(serializedDocuments)
                serializedDocuments = {serializedDocuments};
            end

            % Each file is named after the instance its document was built
            % from, so documents and instances must line up one to one.
            % They do unless the serializer was configured to recurse into
            % links on its own.
            if numel(serializedDocuments) ~= numel(instances)
                error('openminds:FolderMetadataStore:DocumentCountMismatch', ...
                    ['The serializer produced %d documents for %d instances. ', ...
                    'A folder store writes one document per instance, so its ', ...
                    'serializer must not recurse into linked instances: ', ...
                    'configure it with RecursionDepth 0.'], ...
                    numel(serializedDocuments), numel(instances));
            end

            % Save each document to a separate file
            outputPaths = cell(size(serializedDocuments));
            for i = 1:numel(serializedDocuments)
                % Build file path using unified method
                filePath = obj.buildFilepath(instances{i});

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
        %       Cell array of openminds.Node instances
            
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
            instances = openminds.internal.store.loadInstances(filePaths);
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
        %   The path is derived from the instance itself rather than from
        %   its serialized document, so this works regardless of which
        %   Serializer subclass produced the document.
        %
        %   PARAMETERS:
        %   -----------
        %   instance : openminds.Node
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

            % Get instance type from its class name
            classNameParts = strsplit(class(instance), '.');
            typeName = classNameParts{end};

            % Get instance ID and make it filesystem-safe
            instanceId = string(instance.id);
            if startsWith(instanceId, "http")
                idParts = strsplit(instanceId, '/');
                safeId = idParts{end};
            else
                % A blank node identifier is prefixed with "_:", which the
                % sanitizing step below would turn into a second separator.
                safeId = regexprep(instanceId, '^_:', '');
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
