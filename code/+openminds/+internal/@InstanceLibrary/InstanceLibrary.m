classdef InstanceLibrary < handle
% InstanceLibrary - Singleton class representing the openMINDS instance library

    properties (Constant, Access = private)
        SINGLETON_NAME = "InstanceLibrarySingleton"
    end

    properties (SetAccess = private)
        InstanceLibraryLocation (1,1) string
        InstanceTable table

        % ModelVersion - Model version the instance table was resolved
        % against. Instances name their type, and a type is only
        % meaningful for the model version that declares it, so the table
        % has to be rebuilt when another version is put on the path.
        ModelVersion (1,1) string = ""

        % LibraryVersion - Version of the instance library that was read.
        % It follows the model version and is not selected on its own: the
        % library publishes one set of instances per model version, and
        % reading one version's instances against another's types is what
        % leaves instances untyped. It is missing for a model version the
        % library publishes no instances for.
        LibraryVersion (1,1) string = missing
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

    methods (Static)
        % Method for retrieving singleton object. Defined in class folder
        singletonObject = getSingleton(folderPath, options)

        function notifyModelVersionChanged(modelVersion)
        % notifyModelVersionChanged - Rebuild the library for a model version
        %
        %   Syntax:
        %       openminds.internal.InstanceLibrary.notifyModelVersionChanged(modelVersion)
        %
        %   Input:
        %       modelVersion : The model version that was just selected
        %
        %   Instances are typed against the model version that was on the
        %   search path when the table was built, so selecting another
        %   version invalidates the table. Only a library that already
        %   exists is rebuilt: creating one here would download the
        %   instance repository as a side effect of selecting a version.

            arguments
                modelVersion (1,1) string
            end

            singletonObject = getappdata(0, ...
                openminds.internal.InstanceLibrary.SINGLETON_NAME);

            if isempty(singletonObject) || ~isvalid(singletonObject)
                return
            end

            try
                singletonObject.updateInstanceTable( ...
                    normalizeModelVersion(modelVersion))
            catch ME
                % Selecting a model version is a change to the search path.
                % The instance library is a separate resource that may be
                % absent or incomplete, and failing to read it is not a
                % reason for the version not to be selected.
                warning('OPENMINDS:InstanceLibrary:RebuildFailed', ...
                    ['Failed to read the openMINDS instance library for ', ...
                    'model version "%s". Reason: %s'], modelVersion, ME.message)
            end
        end
    end

    methods (Access = private)
        function obj = InstanceLibrary(folderPath, options)
            arguments
                folderPath (1,1) string {mustBeFolder}
                options.UseGit (1,1) logical = false
            end

            obj.UseGit = options.UseGit;
            obj.InstanceLibraryLocation = folderPath;
        end
    end

    methods % Set/get
        function set.InstanceLibraryLocation(obj, value)
            % Kept for the life of the library and read again on every
            % rebuild, so it must not depend on the working directory.
            obj.InstanceLibraryLocation = ...
                openminds.internal.utility.resolveAbsolutePath(value);
            obj.postSetInstanceLibraryLocation()
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
                    'library read for model version "%s".'], ...
                    iriSegment, obj.ModelVersion)
            end

            typeName = obj.IRISegmentIndex.TypeName(find(isMatch, 1));
            typeEnum = openminds.enum.Types(typeName);
        end
    end

    methods (Access = private) % Internal updating and validation
        function updateInstanceTable(obj, modelVersion)
            arguments
                obj (1,1) openminds.internal.InstanceLibrary

                % The version the instances are typed against. It is passed
                % in when the model version has just changed, because the
                % version derived from the search path is briefly cached
                % and may still name the previous one.
                modelVersion (1,1) string = openminds.version()
            end

            libraryVersion = obj.resolveLibraryVersion(modelVersion);

            if ismissing(libraryVersion)
                [instanceTable, iriSegmentIndex] = emptyInstanceTables();
            else
                rootFolder = fullfile(obj.InstanceLibraryLocation, libraryVersion);
                [instanceTable, iriSegmentIndex] = ...
                    obj.readInstanceLibrary(rootFolder, libraryVersion, modelVersion);
            end

            % Assigned last, and together. A read that fails part way must
            % not leave the version saying one thing and the table another,
            % because the version is what tells getSingleton the table is
            % current.
            obj.ModelVersion = modelVersion;
            obj.LibraryVersion = libraryVersion;
            obj.InstanceTable = instanceTable;
            obj.IRISegmentIndex = iriSegmentIndex;
        end

        function [instanceTable, iriSegmentIndex] = readInstanceLibrary(obj, rootFolder, libraryVersion, modelVersion)
        % readInstanceLibrary - Read the instances of one library version

            instanceFilePaths = listInstanceFiles(rootFolder);

            if isempty(instanceFilePaths)
                [instanceTable, iriSegmentIndex] = emptyInstanceTables();

                warning('OPENMINDS:InstanceLibrary:InstancesNotFound', ...
                    ['No instance files were found for version "%s" of the ', ...
                    'openMINDS instance library, so no controlled instances ', ...
                    'are available. The library at "%s" may be incomplete.'], ...
                    libraryVersion, obj.InstanceLibraryLocation)
                return
            end

            [instanceTable, iriSegmentIndex] = obj.createInstanceTable( ...
                instanceFilePaths, rootFolder, libraryVersion, modelVersion);
        end

        function libraryVersion = resolveLibraryVersion(obj, modelVersion)
        % resolveLibraryVersion - Pick the library version for a model version
        %
        %   Instances are typed against the metadata model, so the library
        %   version follows the model version. The library does not publish
        %   instances for every model version: versions 1 and 2 of the
        %   model predate the type names the library is written against,
        %   and no other version of the library can stand in for them. A
        %   version without instances is reported here and returned missing.

            if ismember(modelVersion, obj.AvailableVersions)
                libraryVersion = modelVersion;
                return
            end

            libraryVersion = missing;

            if isempty(obj.AvailableVersions)
                % The library is not on disk at all. Retrieving it has
                % already reported why, and the versions it publishes
                % cannot be named from here.
                return
            end

            warning('OPENMINDS:InstanceLibrary:NoInstancesForModelVersion', ...
                ['The openMINDS instance library publishes no instances ', ...
                'for version "%s" of the metadata model, so no controlled ', ...
                'instances are available. Select one of the model versions ', ...
                'it does publish instances for: %s.'], ...
                modelVersion, strjoin(obj.AvailableVersions, ', '))
        end

        function detectAvailableVersions(obj)
            L = dir(obj.InstanceLibraryLocation);
            names = string({L.name});
            names = names(~startsWith(names, '.') & [L.isdir]);
            obj.AvailableVersions = names;
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
    end

    methods (Access = private)
        function [instanceTable, iriSegmentIndex] = createInstanceTable( ...
                obj, filePaths, rootFolder, libraryVersion, modelVersion)
        % createInstanceTable - Build the instance table for a set of files
        %
        %   The openMINDS type of an instance is taken from the "@type" the
        %   instance document declares, not from the name of the folder the
        %   document is stored in. Folder names are pluralized type names
        %   and upstream renames them whenever a type is renamed, so they
        %   are not a source that stays correct across model versions.
        %
        %   The versions are passed in rather than read from the object,
        %   which is not updated until the table has been built.

            arguments
                obj (1,1) openminds.internal.InstanceLibrary
                filePaths (:,1) string
                rootFolder (1,1) string
                libraryVersion (1,1) string
                modelVersion (1,1) string
            end

            [folderPaths, instanceNames] = fileparts(filePaths);

            % All instances in a folder share one type, so one document per
            % folder is enough to type the whole library.
            [uniqueFolderPaths, firstInFolder, folderIndex] = unique(folderPaths);
            folderInfo = obj.resolveFolderInfo( ...
                filePaths(firstInFolder), libraryVersion, modelVersion);

            subGroups = resolveSubgroups( ...
                uniqueFolderPaths, folderInfo.TypeName, rootFolder);

            instanceTable = table(...
                instanceNames, ...
                folderInfo.TypeName(folderIndex), ...
                folderInfo.ModuleName(folderIndex), ...
                subGroups(folderIndex), ...
                filePaths, ...
                'VariableNames', instanceTableVariableNames());

            iriSegmentIndex = obj.createIRISegmentIndex(folderInfo);
        end

        function folderInfo = resolveFolderInfo(~, representativeFilePaths, libraryVersion, modelVersion)
        % resolveFolderInfo - Resolve the type each instance folder holds
        %
        %   Input:
        %       representativeFilePaths : One instance file per folder
        %       libraryVersion, modelVersion : Named in what is reported
        %
        %   Output:
        %       folderInfo : Table with the type name, module name and IRI
        %       path segment for each folder. A folder whose document
        %       cannot be read, or whose type the model does not declare,
        %       leaves its row empty. Each is reported once.

            arguments
                ~
                representativeFilePaths (:,1) string
                libraryVersion (1,1) string
                modelVersion (1,1) string
            end

            numFolders = numel(representativeFilePaths);
            [typeNames, moduleNames, iriSegments] = deal(repmat("", numFolders, 1));

            unreadableFilePaths = strings(0, 1);
            unresolvedTypeIRIs = strings(0, 1);

            for i = 1:numFolders
                header = readInstanceHeader(representativeFilePaths(i));
                iriSegments(i) = readIRISegment(header);

                typeIRI = readTypeIRI(header);
                if ismissing(typeIRI)
                    unreadableFilePaths(end+1) = representativeFilePaths(i); %#ok<AGROW>
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

            if ~isempty(unreadableFilePaths)
                warning('OPENMINDS:InstanceLibrary:UnreadableInstance', ...
                    ['No "@type" could be read from %d instance document(s) ', ...
                    'of the openMINDS instance library, so the instances ', ...
                    'stored with them are listed without a type. The library ', ...
                    'may be damaged. First of them: "%s".'], ...
                    numel(unreadableFilePaths), unreadableFilePaths(1))
            end

            % The library version follows the model version, so the two
            % naming different types means either the library is ahead of
            % the model, or the model classes still in memory belong to a
            % version selected earlier in this session.
            if ~isempty(unresolvedTypeIRIs)
                warning('OPENMINDS:InstanceLibrary:UnresolvedInstanceType', ...
                    ['Version "%s" of the openMINDS instance library holds ', ...
                    'instances of type(s) that version "%s" of the openMINDS ', ...
                    'model does not declare: %s. These instances are listed ', ...
                    'without a type. If another model version was selected ', ...
                    'earlier in this session, restart MATLAB.'], ...
                    libraryVersion, modelVersion, ...
                    summarizeTypeNames(unresolvedTypeIRIs))
            end

            folderInfo = table(typeNames, moduleNames, iriSegments, ...
                'VariableNames', ["TypeName", "ModuleName", "IRISegment"]);
        end

        function iriSegmentIndex = createIRISegmentIndex(~, folderInfo)
        % createIRISegmentIndex - Index IRI path segments by type name
        %
        %   Several folders can share one type, and a folder whose type
        %   could not be resolved contributes nothing to resolve with.

            isResolved = folderInfo.TypeName ~= "" & ~ismissing(folderInfo.IRISegment);
            iriSegmentIndex = unique( ...
                folderInfo(isResolved, ["IRISegment", "TypeName"]) );
        end
    end
end

function instanceFilePaths = listInstanceFiles(rootFolder)
% listInstanceFiles - List the instance files under a library version folder
%
%   Returns empty when there are none. The caller reports that, because a
%   library that cannot be read is not a reason for selecting a model
%   version to fail.

    instanceFileFormat = ".jsonld";

    L = dir(fullfile(rootFolder, "**", "*"+instanceFileFormat));

    if isempty(L)
        instanceFilePaths = strings(0, 1);
        return
    end

    instanceFilePaths = join([{L.folder}', {L.name}'], filesep);
    instanceFilePaths = string(instanceFilePaths);
end

function subGroups = resolveSubgroups(folderPaths, typeNames, rootFolder)
% resolveSubgroups - Resolve the subgroup name for each folder
%
%   Instances of one type are sometimes grouped in a subfolder, as in
%   parcellationEntities/BA-human. Such a subfolder is recognized by its
%   siblings holding the same type, which sets it apart from a folder that
%   groups several types, as terminologies does. Neither shape is declared
%   anywhere, so it is derived from the types resolved above rather than
%   from folder names.

    arguments
        folderPaths (:,1) string
        typeNames (:,1) string
        rootFolder (1,1) string
    end

    subGroups = strings(numel(folderPaths), 1);
    subGroups(:) = missing;

    relativePaths = replace(folderPaths, rootFolder, "");
    relativePaths = strip(relativePaths, "left", filesep);
    [parentPaths, folderNames] = fileparts(relativePaths);

    for parentPath = unique(parentPaths(parentPaths ~= ""))'
        isChild = parentPaths == parentPath;
        if isscalar(unique(typeNames(isChild)))
            subGroups(isChild) = folderNames(isChild);
        end
    end
end

function variableNames = instanceTableVariableNames()
% instanceTableVariableNames - Columns of the instance table
    variableNames = ["InstanceName", "Type", "Module", "Subgroup", "Filepath"];
end

function [instanceTable, iriSegmentIndex] = emptyInstanceTables()
% emptyInstanceTables - The tables of a library with no instances to read
%
%   A model version the library publishes no instances for still leaves
%   tables that can be filtered and looked up in, rather than tables with
%   no columns to filter on.

    numColumns = numel(instanceTableVariableNames());
    instanceTable = array2table(strings(0, numColumns), ...
        'VariableNames', instanceTableVariableNames());

    iriSegmentIndex = array2table(strings(0, 2), ...
        'VariableNames', ["IRISegment", "TypeName"]);
end

function versionString = normalizeModelVersion(modelVersion)
% normalizeModelVersion - Name a model version the way openminds.version does
%
%   The version is stored to be compared against openminds.version, so it
%   has to be written the same way. Formatting the selected version here,
%   rather than reading the active one back from the search path, keeps the
%   comparison correct while that lookup still holds its cached value.

    versionNumber = openminds.internal.utility.VersionNumber(modelVersion);
    versionNumber.Format = "vX.Y";
    versionString = string(versionNumber);
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
        iriSegment = missing;
    else
        iriSegment = match.segment;
    end
end
