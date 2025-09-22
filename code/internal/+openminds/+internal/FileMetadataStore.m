classdef FileMetadataStore < openminds.interface.MetadataStore
% FileMetadataStore - Metadata store implementation for single metadata files
%
% This class handles saving and loading openMINDS Collections to/from
% a single metadata file using a configurable serializer.
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
                options.RecursionDepth (1,1) {mustBeInteger, mustBeNonnegative} = 0
                options.PrettyPrint (1,1) logical = true
                options.PropertyNameSyntax (1,1) string {mustBeMember(options.PropertyNameSyntax, ["compact","expanded"])} = "compact"
                options.IncludeEmptyProperties (1,1) logical = false
                options.IncludeIdentifier (1,1) logical = true
            end
            
            % Call parent constructor
            obj = obj@openminds.interface.MetadataStore();
            
            % Set immutable location
            obj.Location = filePath;
            
            % Create JsonLdSerializer if not provided
            if isempty(options.Serializer)
                obj.Serializer = openminds.internal.serializer.JsonLdSerializer(...
                    'RecursionDepth', options.RecursionDepth, ...
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
        %   instances : openminds.abstract.Schema, cell array, or openminds.Collection
        %       Instance(s) to save
        %   options : struct (optional)
        %       Additional options (implementation-specific)
        %
        %   RETURNS:
        %   --------
        %   filePath : string
        %       Path to the created file
            

        % Todo: What about recursion.

            arguments
                obj (1,1) openminds.internal.FileMetadataStore
                instances % openminds.abstract.Schema, cell array, or openminds.Collection
                options struct = struct() %#ok<INUSA> 
            end
            
            % Handle Collection objects
            if isa(instances, 'openminds.Collection')
                instances = instances.getAll();
                if iscell(instances)
                    instances = [instances{:}];
                end
            end
            
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
        %       Cell array of openminds.abstract.Schema instances
            
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
