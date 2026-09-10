classdef InstanceLibrary < handle & matlab.mixin.SetGet
% InstanceLibrary - Singleton class representing the openMINDS instance library

    properties (Constant, Access = private)
        SINGLETON_NAME = "InstanceLibrarySingleton"
    end

    properties
        LibraryVersion (1,1) string = "latest"
    end

    properties (SetAccess = private)
        InstanceLibraryLocation (1,1) string
        InstanceTable table

        % ModelVersion - Model version the instance table was resolved
        % against. Instances name their type, and a type is only
        % meaningful for the model version that declares it, so the table
        % has to be rebuilt when another version is put on the path.
        ModelVersion (1,1) string = ""
    end

    properties (SetAccess = private)
        AvailableVersions (1,:) string
    end

    properties (Access = private)
        UseGit (1,1) logical = false
        GitRepo

        % Index from the IRI path segment that names a type, e.g.
        % "licenses" or "biologicalSex", to the name of that type. Most
        % segments name the type directly, but a few are plural and
        % openMINDS publishes no plural to singular mapping, so the
        % segments are collected from the instance documents themselves.
        IRISegmentIndex table
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

    methods
        function typeEnum = getTypeFromIRISegment(obj, iriSegment)
        % getTypeFromIRISegment - Get the type named by an IRI path segment
        %
        %   Syntax:
        %       typeEnum = getTypeFromIRISegment(obj, iriSegment)
        %
        %   Input:
        %       iriSegment : The path segment of an instance IRI that names
        %       the type, i.e. "licenses" for the instance IRI
        %       https://openminds.om-i.org/instances/licenses/MIT
        %
        %   Output:
        %       typeEnum : The openminds.enum.Types member for that segment
        %
        %   Most segments name their type directly and do not need this
        %   lookup. It exists for the few that are plural, which openMINDS
        %   publishes no mapping for.

            arguments
                obj (1,1) openminds.internal.InstanceLibrary
                iriSegment (1,1) string
            end

            isMatch = obj.IRISegmentIndex.IRISegment == iriSegment;

            if ~any(isMatch)
                error("OPENMINDS:InstanceLibrary:UnknownIRISegment", ...
                    ['"%s" does not name a type in the openMINDS instance ', ...
                    'library at version "%s".'], iriSegment, obj.LibraryVersion)
            end

            typeName = obj.IRISegmentIndex.TypeName(find(isMatch, 1));
            typeEnum = openminds.enum.Types(typeName);
        end
    end

    methods (Access = private) % Internal updating and validation
        function updateInstanceTable(obj)
            if isfolder(obj.InstanceLibraryLocation)
                instanceFilePaths = obj.listInstanceFiles();
                [obj.InstanceTable, obj.IRISegmentIndex] = ...
                    obj.createInstanceTable(instanceFilePaths);
                obj.ModelVersion = openminds.version();
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
            import openminds.internal.utility.git.isRecordedCommitCurrent
            import openminds.internal.utility.git.downloadRepository
            % import openminds.internal.utility.git.pullRepository

            try
                if ~isfolder(obj.InstanceLibraryLocation) ...
                        || ~isRecordedCommitCurrent('RepositoryName', 'openMINDS_instances')
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
        function [instanceTable, iriSegmentIndex] = createInstanceTable(obj, filePaths)
        % createInstanceTable - Build the instance table for a set of files
        %
        %   The openMINDS type of an instance is taken from the "@type" the
        %   instance document declares, not from the name of the folder the
        %   document is stored in. Folder names are pluralized type names
        %   and upstream renames them whenever a type is renamed, so they
        %   are not a source that stays correct across model versions.

            arguments
                obj (1,1) openminds.internal.InstanceLibrary
                filePaths (:,1) string
            end

            [folderPaths, instanceNames] = fileparts(filePaths);

            % All instances in a folder share one type, so one document per
            % folder is enough to type the whole library.
            [uniqueFolderPaths, firstInFolder, folderIndex] = unique(folderPaths);
            folderInfo = obj.resolveFolderInfo(filePaths(firstInFolder));

            subGroups = obj.resolveSubgroups(uniqueFolderPaths, folderInfo.TypeName);

            variableNames = ["InstanceName", "Type", "Module", "Subgroup", "Filepath"];
            instanceTable = table(...
                instanceNames, ...
                folderInfo.TypeName(folderIndex), ...
                folderInfo.ModuleName(folderIndex), ...
                subGroups(folderIndex), ...
                filePaths, ...
                'VariableNames', variableNames);

            iriSegmentIndex = obj.createIRISegmentIndex(folderInfo);
        end

        function folderInfo = resolveFolderInfo(obj, representativeFilePaths)
        % resolveFolderInfo - Resolve the type each instance folder holds
        %
        %   Input:
        %       representativeFilePaths : One instance file per folder
        %
        %   Output:
        %       folderInfo : Table with the type name, module name and IRI
        %       path segment for each folder. A type the active model does
        %       not declare leaves the row empty and is reported once.

            arguments
                obj (1,1) openminds.internal.InstanceLibrary
                representativeFilePaths (:,1) string
            end

            numFolders = numel(representativeFilePaths);
            [typeNames, moduleNames, iriSegments] = deal(repmat("", numFolders, 1));

            unresolvedTypeIRIs = strings(0, 1);

            for i = 1:numFolders
                header = readInstanceHeader(representativeFilePaths(i));
                iriSegments(i) = readIRISegment(header);

                typeIRI = readTypeIRI(header);
                if ismissing(typeIRI)
                    continue
                end

                try
                    typeEnum = openminds.enum.Types.fromAtType(typeIRI);
                catch
                    unresolvedTypeIRIs(end+1) = typeIRI; %#ok<AGROW>
                    continue
                end

                typeNames(i) = string(typeEnum);
                moduleNames(i) = string(typeEnum.getModule());
            end

            if ~isempty(unresolvedTypeIRIs)
                warning('OPENMINDS:InstanceLibrary:UnresolvedInstanceType', ...
                    ['The instance library at version "%s" holds instances of ', ...
                    'type(s) that version "%s" of the openMINDS model does not ', ...
                    'declare: %s. These instances are listed without a type. ', ...
                    'Select a model version that matches the instance library, ', ...
                    'or set the LibraryVersion of the instance library to match ', ...
                    'the model version.'], ...
                    obj.LibraryVersion, openminds.version(), ...
                    summarizeTypeNames(unresolvedTypeIRIs))
            end

            folderInfo = table(typeNames, moduleNames, iriSegments, ...
                'VariableNames', ["TypeName", "ModuleName", "IRISegment"]);
        end

        function subGroups = resolveSubgroups(obj, folderPaths, typeNames)
        % resolveSubgroups - Resolve the subgroup name for each folder
        %
        %   Instances of one type are sometimes grouped in a subfolder, as
        %   in parcellationEntities/BA-human. Such a subfolder is
        %   recognized by its siblings holding the same type, which sets it
        %   apart from a folder that groups several types, as terminologies
        %   does. Neither shape is declared anywhere, so it is derived from
        %   the types resolved above rather than from folder names.

            arguments
                obj (1,1) openminds.internal.InstanceLibrary
                folderPaths (:,1) string
                typeNames (:,1) string
            end

            subGroups = strings(numel(folderPaths), 1);
            subGroups(:) = missing;

            relativePaths = replace(folderPaths, obj.InstanceRootFolder, "");
            relativePaths = strip(relativePaths, "left", filesep);
            [parentPaths, folderNames] = fileparts(relativePaths);

            for parentPath = unique(parentPaths(parentPaths ~= ""))'
                isChild = parentPaths == parentPath;
                if isscalar(unique(typeNames(isChild)))
                    subGroups(isChild) = folderNames(isChild);
                end
            end
        end

        function iriSegmentIndex = createIRISegmentIndex(~, folderInfo)
        % createIRISegmentIndex - Index IRI path segments by type name
        %
        %   Several folders can share one type, and a folder whose type
        %   could not be resolved contributes nothing to resolve with.

            isResolved = folderInfo.TypeName ~= "" & folderInfo.IRISegment ~= "";
            iriSegmentIndex = unique( ...
                folderInfo(isResolved, ["IRISegment", "TypeName"]) );
        end
    end
end

function typeList = summarizeTypeNames(typeIRIs)
% summarizeTypeNames - Name the types of a set of type IRIs for a message
%
%   A version mismatch leaves every type of a module unresolved, which is
%   more names than a warning can carry, so the list is capped.

    MAX_LISTED_TYPES = 10;

    typeNames = unique( regexprep(typeIRIs, ".*/", "") );

    if numel(typeNames) > MAX_LISTED_TYPES
        typeList = strjoin(typeNames(1:MAX_LISTED_TYPES), ', ') + ...
            sprintf(" and %d more", numel(typeNames)-MAX_LISTED_TYPES);
    else
        typeList = strjoin(typeNames, ', ');
    end
end

function header = readInstanceHeader(filePath)
% readInstanceHeader - Read the head of an instance document
%
%   "@id" and "@type" are declared at the top of every openMINDS instance
%   document, so reading a document in full to recover two lines is not
%   worth the cost across a library of thousands of instances.

    HEADER_NUM_BYTES = 1024;

    fileId = fopen(filePath, "r");
    if fileId == -1
        header = "";
        return
    end
    cleanupObj = onCleanup(@() fclose(fileId));

    header = string( fread(fileId, HEADER_NUM_BYTES, "*char")' );
end

function typeIRI = readTypeIRI(header)
% readTypeIRI - Read the "@type" IRI declared in an instance document head

    match = regexp(header, '"@type"\s*:\s*"(?<iri>[^"]+)"', 'names', 'once');

    if isempty(match)
        typeIRI = missing;
    else
        typeIRI = match.iri;
    end
end

function iriSegment = readIRISegment(header)
% readIRISegment - Read the type segment of the "@id" of an instance
%
%   The "@id" of an instance is .../instances/<segment>/<name>, where the
%   segment names the type. It is usually, but not always, the singular
%   type name in lower camel case.

    match = regexp(header, ...
        '"@id"\s*:\s*"[^"]*?/instances/(?<segment>[^"/]+)/', 'names', 'once');

    if isempty(match)
        iriSegment = "";
    else
        iriSegment = match.segment;
    end
end
