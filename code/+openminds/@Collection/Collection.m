classdef Collection < handle
%Collection A collection of openMINDS instances that can be saved to and
% loaded from disk.
%
%   USAGE:
%   - - - -
%   collection = openminds.Collection() creates a new empty collection
%
%   collection = openminds.Collection(instanceA, instanceB, ...) creates a
%   new collection and populates with instances. instanceA, instanceB etc
%   can be instances of openMINDS metadata or files holding serialized
%   openMINDS metadata (jsonlds)
%
%   METHODS:
%   - - - - -
%       openminds.Collection/add         Add instances to collection
%       openminds.Collection/updateLinks Update collection
%       openminds.Collection/save        Save instances of collection to file
%       openminds.Collection/load        Load instances from file and add to collection
%
%   METHODS USAGE:
%   - - - - - - - -
%
%   collection.add(instanceC, instanceD) adds more instances to the
%   collection.
%
%   collection.updateLinks() updates the collection by checking if any of
%   the instances in the collection has linked types that are not added to
%   the collection yet.
%
%   collection.save(filePath) saves a collection to a jsonld file. Please
%   specify the filePath including the file extension.
%
%   collection.load(filePath) loads metadata instances from a file and adds
%   them to the collection.
%
%   For more details on how to create a new Collection:
%   See also openminds.Collection/Collection

% Todo: Validation.
%   - Linked subject states should have same subject

    properties
        % Name of the metadata collection
        Name (1,1) string

        % Description of the metadata collection
        Description (1,1) string
    end
    
    properties (SetAccess = protected)
        Nodes (1,1) dictionary
    end

    properties (SetAccess = protected, Hidden)
        TypeMap (1,1) dictionary
    end

    properties
        LinkResolver
    end
    
    methods % Constructor
        function obj = Collection(instance, options)
        % Create an instance of an openMINDS collection
        %
        %   USAGE:
        %
        %   collection = openminds.Collection() creates a collection for
        %   adding metadata instances
        %
        %   collection = openminds.Collection(instanceA, instanceB, ...)
        %   creates a collection and populates it with the provided
        %   instances. Note: Linked types of the provided instances will be
        %   added automatically.
        %
        %   collection = openminds.Collection(filepathA, filePathB, ...)
        %   creates a collection and loads instances from files. Note:
        %   Currently supports metadata instances saved as jsonld files.
        %
        %   collection = openminds.Collection(rootFolderPath)
        %   creates a collection and loads instances from files in a root
        %   folder.
        
        %   TODO: This needs to be saved somehow.
        %   collection = openminds.Collection(..., NameA, ValueA, ... )
        %   also specifies optional name value pairs when creating the
        %   collection.
        %
        %   Name-Value Pairs:
        %       - Name : A name for the collection
        %       - Description : A description of the collection
            
            arguments (Repeating)
                instance % openminds.abstract.Schema
            end
            arguments
                options.Name (1,1) string = ""
                options.Description (1,1) string = ""
            end
            
            % Initialize nodes
            obj.Nodes = dictionary;
            obj.TypeMap = dictionary;
            
            if ~isempty(instance) && ~isempty(instance{1})
                isFilePath = @(x) (ischar(x) || isstring(x)) && isfile(x);
                isFolderPath = @(x) (ischar(x) || isstring(x)) && isfolder(x);
                isMetadata = @(x) openminds.utility.isInstance(x);
                
                % Initialize from file(s)
                if all( cellfun(isFilePath, instance) )
                    obj.load(instance{:})
    
                % Initialize from folder
                elseif all( cellfun(isFolderPath, instance) )
                    obj.load(instance{:})
    
                % Initialize from instance(s)
                elseif all( cellfun(isMetadata, instance) )
                    obj.add(instance{:});
    
                else
                    error('All given instances must be valid filepaths or openminds instances')
                end
            end

            obj.Name = options.Name;
            obj.Description = options.Description;
        end
    end

    methods
        function len = length(obj)
            len = numEntries(obj.Nodes);
        end

        function tf = isKey(obj, identifier)
            tf = false;

            if isConfigured(obj.Nodes)
                if isKey(obj.Nodes, identifier)
                    tf = true;
                end
            end
        end
        
        function add(obj, instance, options)
        %add Add single or multiple instances to a collection.
        %
        %   Example usage:
        %
        %       myCollection.add(personInstance)
        %
        %       myCollection.add(personInstanceA, personInstanceB, ...)

            arguments
                obj openminds.Collection % Object of this class
            end
            arguments (Repeating)
                instance % openminds.abstract.Schema
            end
            arguments
                options.AddSubNodesOnly = false;
            end

            for i = 1:numel(instance)
                thisInstance = instance{i};
                for j = 1:numel(thisInstance) % If thisInstance is an array
                    obj.addNode(thisInstance(j), "AddSubNodesOnly", options.AddSubNodesOnly);
                end
            end
        end
        
        function tf = contains(obj, instance)
            % Todo:work for arrays
            tf = false;

            if isConfigured(obj.Nodes)
                if isKey(obj.Nodes, instance.id)
                    tf = true;
                end
            end
        end
        
        function remove(obj, instance)
            
            if isstring(instance) || ischar(instance)
                instanceId = instance;
            elseif openminds.utility.isInstance(instance)
                instanceId = instance.id;
            else
                error('Unexpected type "%s" for instance argument', class(instance))
            end

            if isConfigured(obj.Nodes) && isKey(obj.Nodes, instanceId)
                obj.Nodes(instanceId) = [];
            else
                error('Instance with id %s is not found in collection')
            end
        end

        function instance = get(obj, nodeKey)
            instance = obj.Nodes{nodeKey};
        end

        function instances = list(obj, type, propertyName, propertyValue)
            arguments
                obj
                type (1,1) string
            end
            arguments (Repeating)
                propertyName (1,1) string
                propertyValue
            end

            instances = [];

            if ~isConfigured(obj.Nodes)
                return
            end
            
            typeKeys = obj.TypeMap.keys;
            isMatch = endsWith(typeKeys, "."+type); %i.e ".Person"
            if any(isMatch)
                if isMATLABReleaseOlderThan("R2023b")
                    keys = string( obj.TypeMap(typeKeys(isMatch)) );
                else
                    keys = obj.TypeMap{typeKeys(isMatch)};
                end
            else
                return
            end
            
            instances = obj.Nodes(keys);
            instances = [instances{:}];

            % Filter by property values:
            for i = 1:numel(propertyName)
                thisName = propertyName{i};
                thisValue = propertyValue{i};

                instanceValues = {instances.(thisName)};

                keep = cellfun(@(c) isequal(c, thisValue), instanceValues);
                instances = instances(keep);
            end
        end

        function updateLinks(obj)
            for instance = obj.Nodes.values
                obj.addNode(instance{1}, ...
                    'AddSubNodesOnly', true, ...
                    'AbortIfNodeExists', false);
            end
        end

        function outputPaths = save(obj, savePath, options)
        %save Save the instance collection to disk in JSON-LD format.
        %
        %   collection.save(filePath) saves a collection to a jsonld file.
        %
        %   collection.save(folderPath, "SaveToSingleFile", false) saves a
        %   collection to individual files in a folder.
        %
        %     INPUT
        %     -----
        %
        %     savePath (str):
        %         either a file or a directory into which the metadata will be written.
        %
        %     OPTIONAL INPUT
        %     --------------
        %
        %     SaveToSingleFile (bool):
        %         if true (default), save the entire collection into a single file.
        %         if false, savePath must be a directory, and each node is saved into a
        %         separate file within that directory.
        %
        %     OUTPUT
        %     ------
        %
        %     outputPaths (cell): A list of the file paths created.
        
            arguments
                obj openminds.Collection
                savePath (1,1) string
                options.SaveToSingleFile (1,1) logical = true
                % options.IncludeEmptyProperties (1,1) logical = false
            end
            
            % Update links before saving
            obj.updateLinks()

            instances = obj.Nodes.values;
            
            outputPaths = obj.saveInstances(instances, savePath, ...
                'SaveToSingleFile', options.SaveToSingleFile, ...
                'RecursionDepth', 0);
            % Note: For collections, recursion depth should be 0.
            
            if ~nargout
                clear outputPaths
            end
        end
    
        function load(obj, filePath)%, options)
        %load Load instances from JSON-LD files on disk into the collection
        %
        %   collection.load(filePath) loads metadata from a jsonld file.
        %
        %   collection.load(folderPath) loads metadata from a folder.
        %
        %     INPUT
        %     -----
        %
        %     filePath (str):
        %         either a file or a directory from which the metadata will be read.

            arguments
                obj openminds.Collection
            end
            arguments (Repeating)
                filePath % openminds.abstract.Schema
            end

            if numel(filePath) == 1 && isfolder(filePath{1})
                rootPath = filePath{1};
                folderPaths = openminds.internal.utility.dir.listSubDir(rootPath, '', {}, inf);
                jsonldFilePaths = openminds.internal.utility.dir.listFiles(folderPaths, '.jsonld');
            else
                jsonldFilePaths = filePath;
            end

            if isempty(jsonldFilePaths); return; end

            instances = obj.loadInstances(jsonldFilePaths);
            for i = 1:numel(instances)
                if openminds.utility.isInstance(instances{i})
                    obj.addNode(instances{i})
                else
                    warning('todo')
                end
            end
        end
    end

    methods (Static) % Methods in separate files
        
        outputPaths = saveInstances(instance, filePath, options)
        
        instances = loadInstances(filePath)
    end

    methods (Access = protected)

        % Add an instance to the Node container.
        function addNode(obj, instance, options)
    
            arguments
                obj (1,1) openminds.Collection
                instance (1,1) openminds.abstract.Schema
                options.AddSubNodesOnly = false
                options.AbortIfNodeExists = true;
            end
            
            if isempty(instance.id)
                instance.id = obj.getBlankNodeIdentifier();
            end

            % Do not add openminds controlled term instances
            if startsWith(instance.id, "https://openminds.ebrains.eu/instances/")
                return
            end

            if isConfigured(obj.Nodes)
                if isKey(obj.Nodes, instance.id)
                    % warning('Node with id %s already exists in collection', instance.id)
                    if options.AbortIfNodeExists
                        return
                    end
                end
            end
            
            if ~options.AddSubNodesOnly
                obj.Nodes(instance.id) = {instance};
                
                % Todo: Separate method
                instanceType = class(instance);
                if isConfigured(obj.TypeMap) && isKey(obj.TypeMap, instanceType)
                    if isMATLABReleaseOlderThan("R2023b")
                        existingInstances = obj.TypeMap(instanceType);
                        obj.TypeMap(instanceType) = {[existingInstances{:}, string(instance.id)]};
                    else
                        obj.TypeMap(instanceType) = {[obj.TypeMap{instanceType}, string(instance.id)]};
                    end
                else
                    obj.TypeMap(instanceType) = {string(instance.id)};
                end
            end
            
            obj.addSubNodes(instance)
        end
        
        % Add sub node instances (linked types) to the Node container.
        function addSubNodes(obj, instance)
            % Add links.
            linkedTypes = instance.getLinkedTypes();
            for i = 1:numel(linkedTypes)
                if openminds.utility.isInstance(linkedTypes{i})
                    obj.addNode(linkedTypes{i});
                end
            end

            % Add embeddings.
            embeddedTypes = instance.getEmbeddedTypes();
            for i = 1:numel(embeddedTypes)
                obj.addNode(embeddedTypes{i}, 'AddSubNodesOnly', true);
            end
        end

        function identifier = getBlankNodeIdentifier(obj)
            fmt = '_:%06d';
            identifier = length(obj) + 1;
            identifier = sprintf(fmt, identifier);
        end
    end
end
