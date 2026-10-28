classdef FileMetadataStore < openminds.interface.MetadataStore
% FileMetadataStore - Metadata store implementation for single metadata files
%
% This class handles saving and loading openMINDS Collections to/from
% a single metadata file using a configurable serializer.
%
% Saving an instance also saves every instance reachable from it through
% links and embeddings, as nodes of the same file, because a reference to
% a node that is not in the file could not be followed when it is loaded
% again.
%
% USAGE:
%   store = FileMetadataStore("metadata.jsonld");  % Extension depends on serializer
%   store.save(instances);
%   loadedInstances = store.load();

    properties (SetAccess = immutable)
        Location (1,1) string  % File path for saving/loading
    end

    methods
        function obj = FileMetadataStore(filePath, options)
            arguments
                filePath (1,1) string
                options.Serializer = []
                options.PrettyPrint (1,1) logical = true
                options.PropertyNameSyntax (1,1) string {mustBeMember(options.PropertyNameSyntax, ["compact","expanded"])} = "compact"
                options.IncludeEmptyProperties (1,1) logical = false
                options.IncludeIdentifier (1,1) logical = true
            end
            
            % Call parent constructor
            obj = obj@openminds.interface.MetadataStore();
            
            % Set immutable location
            obj.Location = filePath;
            
            % Create JsonLdSerializer if not provided. The store flattens
            % the graph itself, so the serializer does not need to recurse
            % into links, and recursion depth is not configurable here.
            if isempty(options.Serializer)
                obj.Serializer = openminds.internal.serializer.JsonLdSerializer(...
                    'RecursionDepth', 0, ...
                    'PrettyPrint', options.PrettyPrint, ...
                    'PropertyNameSyntax', options.PropertyNameSyntax, ...
                    'IncludeEmptyProperties', options.IncludeEmptyProperties, ...
                    'IncludeIdentifier', options.IncludeIdentifier, ...
                    'OutputMode', 'single');
            else
                obj.Serializer = options.Serializer;
            end
        end
    end

    methods
        function filePath = save(obj, instances, options)
        % save - Save openMINDS instances to a single file
        %
        %   filePath = save(obj, instances)
        %   filePath = save(obj, instances, options)
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
        %   filePath : string
        %       Path to the created file

            arguments
                obj (1,1) openminds.internal.FileMetadataStore
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

            % Serialize instances
            serializedContent = obj.Serializer.serialize(instances);
            
            % Ensure directory exists
            [folder, ~, ~] = fileparts(obj.Location);
            if folder ~= "" && ~isfolder(folder)
                mkdir(folder);
            end
            
            % Write to file
            openminds.internal.utility.filewrite(obj.Location, serializedContent);
            
            % Return the file path
            filePath = obj.Location;
        end
        
        function instances = load(obj, options)
        % load - Load openMINDS instances from a metadata file
        %
        %   instances = load(obj)
        %   instances = load(obj, options)
        %
        %   PARAMETERS:
        %   -----------
        %   options : struct (optional)
        %       Additional options (implementation-specific)
        %
        %   RETURNS:
        %   --------
        %   instances : cell array
        %       Cell array of openminds.Node instances
            
            arguments
                obj (1,1) openminds.internal.FileMetadataStore
                options struct = struct() %#ok<INUSA>
            end
            
            if ~isfile(obj.Location)
                error('openminds:FileMetadataStore:FileNotFound', ...
                    'File not found: %s', obj.Location);
            end
            
            % Use the existing loadInstances functionality
            instances = openminds.internal.store.loadInstances(obj.Location);
        end
    end
end
