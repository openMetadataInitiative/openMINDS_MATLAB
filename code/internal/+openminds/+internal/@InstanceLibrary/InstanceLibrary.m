classdef InstanceLibrary < handle & matlab.mixin.SetGet
% InstanceLibrary - Singleton class representing the openMINDS instance library
    
    % Todo: Create mapping from types to folder of type instances?

    properties (Constant, Access = private)
        SINGLETON_NAME = "InstanceLibrarySingleton"
    end

    properties
        LibraryVersion (1,1) string = "latest"
    end

    properties (SetAccess = private)
        InstanceLibraryLocation (1,1) string
        InstanceTable table
    end

    properties (SetAccess = private)
        AvailableVersions (1,:) string
    end

    properties (Access = private)
        UseGit (1,1) logical = false
        GitRepo
    end

    properties (Dependent, Access = private)
        InstanceRootFolder
    end
    
    methods (Static)
        % Method for retrieving singleton object. Defined in class folder
        singletonObject = getSingleton(folderPath, options)
    end

    methods (Access = private)
        function obj = InstanceLibrary(folderPath, options)
            arguments
                folderPath (1,1) string {mustBeFolder}
                options.UseGit (1,1) logical = false
                options.LibraryVersion (1,1) string = "latest"
            end

            obj.set(options)
            obj.InstanceLibraryLocation = folderPath;
        end
    end

    methods % Set/get
        function set.InstanceLibraryLocation(obj, value)
            obj.InstanceLibraryLocation = value;
            obj.postSetInstanceLibraryLocation()
        end
        function set.LibraryVersion(obj, value)
            obj.validateLibraryVersion(value)
            obj.LibraryVersion = value;
            obj.postSetLibraryVersion()
        end
        function instanceRootFolder = get.InstanceRootFolder(obj)
            instanceRootFolder = fullfile(...
                obj.InstanceLibraryLocation, obj.LibraryVersion);
        end
    end

    methods (Access = private) % Internal updating and validation
        function updateInstanceTable(obj)
            if isfolder(obj.InstanceLibraryLocation)
                instanceFilePaths = obj.listInstanceFiles();
                obj.InstanceTable = obj.createInstanceTable(instanceFilePaths);
            end
        end

        function validateLibraryVersion(obj, value)
            if ~isempty(obj.AvailableVersions)
                assert(ismember(value, obj.AvailableVersions), ...
                    'Version should be a member of available versions: %s', ...
                    strjoin(obj.AvailableVersions, ', '))
            end
        end

        function detectAvailableVersions(obj)
            L = dir(obj.InstanceLibraryLocation);
            names = string({L.name});
            names = names(~startsWith(names, '.') & [L.isdir]);
            obj.AvailableVersions = names;
        end

        function instanceFilePaths = listInstanceFiles(obj)
        % listInstanceFiles - List instance files for current library version
            
            instanceFileFormat = ".jsonld";

            L = dir(fullfile(obj.InstanceRootFolder, "**", "*"+instanceFileFormat));
            instanceFilePaths = join([{L.folder}', {L.name}'], filesep);
            instanceFilePaths = string(instanceFilePaths);
        
            if isempty(instanceFilePaths)
                error(...
                    "openMINDS:InstanceLibrary:InstancesNotFound", ...
                    'Could not find instance files for openMINDS %s', ...
                    obj.LibraryVersion)
            end
        end
    end

    methods (Access = private)
        function postSetInstanceLibraryLocation(obj)
            import openminds.internal.utility.git.isLatest
            import openminds.internal.utility.git.downloadRepository
            % import openminds.internal.utility.git.pullRepository

            try
                if ~isfolder(obj.InstanceLibraryLocation) ...
                        || ~isLatest('Repository', 'openMINDS_instances')
                    if obj.UseGit
                        % pullRepository('openMINDS_instances', obj.InstanceLibraryLocation)
                    else
                        downloadRepository('openMINDS_instances')
                    end
                end
            catch ME
                warning('OPENMINDS:InstanceLibrary:UpdateFailed', ...
                    ['Failed to retrieve or update instance library. ', ...
                    'Reason: %s'], ME.message)
            end
            obj.detectAvailableVersions()
            obj.updateInstanceTable()
        end

        function postSetLibraryVersion(obj)
            obj.updateInstanceTable()
        end
    end

    methods (Access = private)
        function instanceTable = createInstanceTable(obj, filePaths)
            arguments
                obj (1,1) openminds.internal.InstanceLibrary
                filePaths (:,1) string
            end
            
            SANDS_INSTANCE_FOLDERS = openminds.internal.constants.SandsInstanceFolders();
            
            % - Get relevant parts of folder hierarchy for extracting information
            relativeFilepaths = replace(filePaths, obj.InstanceRootFolder, '');
            [folderNames, instanceNames] = fileparts(relativeFilepaths);
        
            numInstances = numel(filePaths);
            [types, modules, subGroups] = deal(repmat("", numInstances, 1));
            for i = 1:numInstances
        
                thisFolderSplit = split(folderNames(i), filesep);
                if thisFolderSplit(1) == ""
                    thisFolderSplit(1) = [];
                end
        
                if thisFolderSplit(1) == "terminologies"
                    if numel(thisFolderSplit) == 2
                        types(i) = getTypeName(thisFolderSplit(2));
                        modules(i) = "controlledTerms";
                    else
                        throw( unexpectedSubfolderCountException('terminologies') )
                    end
        
                elseif any( strcmp(thisFolderSplit(1), SANDS_INSTANCE_FOLDERS))
                    types(i) = getTypeName(thisFolderSplit(1), "IsPlural", true);
                    modules(i) = "SANDS";
                    if numel(thisFolderSplit) == 1
                        subGroups(i) = missing;
                    elseif numel(thisFolderSplit) == 2
                        subGroups(i) = string(thisFolderSplit(2));
                    else
                        throw( unexpectedSubfolderCountException('SANDS') )
                    end
        
                elseif any( strcmp(thisFolderSplit(1), ["licenses", "contentTypes"]) )
                    types(i) = getTypeName(thisFolderSplit(1), "IsPlural", true);
                    modules(i) = "core";
                    subGroups(i) = missing;
                else
                    error('The instance folder with name "%s" is not implemented. Please report', thisFolderSplit(1))
                end
            end

            variableNames = ["InstanceName", "Type", "Module", "Subgroup", "Filepath"];
            instanceTable = table(...
                instanceNames, types, modules, subGroups, filePaths, ...
               'VariableNames', variableNames);
        end
    end
end

function ME = unexpectedSubfolderCountException(moduleName)
    ME = MException(...
        "OPENMINDS:InstanceLibrary:UnexpectedInstanceSubfolderCount", ...
        "Unexpected number of subfolders for %s. Please report!", moduleName);
end

function typeName = getTypeName(folderName, options)
    arguments
        folderName
        options.IsPlural (1,1) logical = false
    end

    persistent pluralMap
    if isempty(pluralMap)
        pluralMap = openminds.internal.vocab.getPluralToSingluarTypeMap();
    end

    if options.IsPlural
        typeName = pluralMap(folderName);
    else
        typeName = folderName;
    end
    typeName{1}(1) = upper(typeName{1}(1));
end
