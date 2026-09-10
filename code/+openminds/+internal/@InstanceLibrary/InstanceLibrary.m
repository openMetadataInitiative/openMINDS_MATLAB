classdef InstanceLibrary < handle
% InstanceLibrary - Singleton class representing the openMINDS instance library

    properties (Constant, Access = private)
        SINGLETON_NAME = "InstanceLibrarySingleton"
    end

    properties (SetAccess = private)
        InstanceLibraryLocation (1,1) string
        InstanceTable table

        % ModelVersion - Model version the instance table was built
        % against. Instance types are resolved against the model classes
        % on the search path, so the table must be rebuilt when another
        % model version is selected.
        ModelVersion (1,1) string = ""

        % LibraryVersion - Version of the instance library that was read.
        % The library publishes one set of instances per model version, so
        % this equals ModelVersion when the library has instances for that
        % version and is missing otherwise. It is never chosen on its own:
        % reading one version's instances against another version's
        % classes leaves instances untyped.
        LibraryVersion (1,1) string = missing
    end

    properties (SetAccess = private)
        AvailableVersions (1,:) string
    end

    properties (Access = private)
        UseGit (1,1) logical = false
        GitRepo

        % Maps the IRI path segment that names a type, e.g. "licenses" or
        % "biologicalSex", to the type name. A few segments are plural and
        % openMINDS publishes no plural-to-singular mapping, so the mapping
        % is read from the "@id" and "@type" of the instance documents.
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
        %   The instance table is typed against the model classes on the
        %   search path when it was built, so selecting another model
        %   version makes it stale. Only a library that already exists is
        %   rebuilt. Creating one here would download the instance
        %   repository as a side effect of selecting a version.

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
                % The instance library may be absent or incomplete. That
                % must not stop the model version from being selected, so
                % the failure is reported as a warning instead of an error.
                warning('OPENMINDS:InstanceLibrary:RebuildFailed', ...
                    ['Failed to read the openMINDS instance library for ', ...
                    'model version "%s". Reason: %s'], modelVersion, ME.message)
            end
        end
    end

    methods (Access = private)
        function obj = InstanceLibrary(folderPath, options)
            arguments
                % Need not exist yet. Setting the location downloads the
                % library into it when it is the default location.
                folderPath (1,1) string
                options.UseGit (1,1) logical = false
            end

            obj.UseGit = options.UseGit;
            obj.InstanceLibraryLocation = folderPath;
        end
    end

    methods % Set/get
        function set.InstanceLibraryLocation(obj, value)
            % Stored as an absolute path. The location is read again on
            % every rebuild, so it must not depend on the working directory.
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
        %   Most segments are the singular type name and resolve without
        %   this lookup. It exists for the few plural segments, for which
        %   openMINDS publishes no mapping.

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

                % The model version to type the instances against.
                % notifyModelVersionChanged passes it explicitly because
                % openminds.version caches its result for one second and
                % may still return the previous version right after a
                % switch.
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

            % All four are assigned after the read has succeeded, so that a
            % read that errors part way leaves the previous version and
            % table in place together. getSingleton compares ModelVersion
            % to decide whether the table is current, so the version must
            % never be updated ahead of the table.
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

            [instanceTable, iriSegmentIndex] = createInstanceTable( ...
                instanceFilePaths, rootFolder, libraryVersion, modelVersion);
        end

        function libraryVersion = resolveLibraryVersion(obj, modelVersion)
        % resolveLibraryVersion - Pick the library version for a model version
        %
        %   The library version equals the model version. The library
        %   publishes no instances for model versions 1 and 2, which predate
        %   the type names the library uses, and no other library version
        %   can substitute for them. For such a version this warns and
        %   returns missing.

            if ismember(modelVersion, obj.AvailableVersions)
                libraryVersion = modelVersion;
                return
            end

            libraryVersion = missing;

            if isempty(obj.AvailableVersions)
                % Nothing is on disk to list. A folder that does not exist
                % is a failed download, which postSetInstanceLibraryLocation
                % has warned about. A folder that exists but holds no
                % version is an incomplete download that the recorded
                % commit did not notice, and nothing else warns about it.
                if isfolder(obj.InstanceLibraryLocation)
                    warning('OPENMINDS:InstanceLibrary:NoVersionsFound', ...
                        ['The openMINDS instance library at "%s" holds no ', ...
                        'version folder, so no controlled instances are ', ...
                        'available. The library may be incomplete.'], ...
                        obj.InstanceLibraryLocation)
                end
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
end

function instanceFilePaths = listInstanceFiles(rootFolder)
% listInstanceFiles - List the instance files under a library version folder
%
%   Returns an empty string array when there are none. The caller warns
%   rather than errors in that case, so that an unreadable library does
%   not stop a model version from being selected.

    instanceFileFormat = ".jsonld";

    L = dir(fullfile(rootFolder, "**", "*"+instanceFileFormat));

    if isempty(L)
        instanceFilePaths = strings(0, 1);
        return
    end

    instanceFilePaths = join([{L.folder}', {L.name}'], filesep);
    instanceFilePaths = string(instanceFilePaths);
end

function [instanceTable, iriSegmentIndex] = createInstanceTable( ...
        filePaths, rootFolder, libraryVersion, modelVersion)
% createInstanceTable - Build the instance table for a set of files
%
%   The type of an instance is read from the "@type" the instance
%   document declares, not derived from the folder name. Folder
%   names are pluralized type names that upstream renames whenever
%   a type is renamed, so typing by folder name goes stale.
%
%   The versions are passed in rather than read from the object,
%   because the object is not updated until the table is built.

    arguments
        filePaths (:,1) string
        rootFolder (1,1) string
        libraryVersion (1,1) string
        modelVersion (1,1) string
    end

    [folderPaths, instanceNames] = fileparts(filePaths);

    % All instances in a folder have the same type, so reading one
    % document per folder types the whole library.
    [uniqueFolderPaths, firstInFolder, folderIndex] = unique(folderPaths);
    folderInfo = resolveFolderInfo( ...
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

    iriSegmentIndex = createIRISegmentIndex(folderInfo);
end

function folderInfo = resolveFolderInfo(representativeFilePaths, libraryVersion, modelVersion)
% resolveFolderInfo - Resolve the type each instance folder holds
%
%   Input:
%       representativeFilePaths : One instance file per folder
%       libraryVersion, modelVersion : Used only in the warnings
%
%   Output:
%       folderInfo : Table with the type name, module name and IRI
%       path segment for each folder. The row is empty for a folder
%       whose document cannot be read or whose type the loaded
%       model classes do not declare. Each case is reported in one
%       warning.

    arguments
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

    % The library version equals the model version, so a type that
    % the library holds but the loaded classes do not declare has
    % one of two causes: the library is newer than the generated
    % model classes, or MATLAB still holds the classes of a
    % previously selected model version because something in the
    % session references them. The two cannot be told apart here.
    if ~isempty(unresolvedTypeIRIs)
        warning('OPENMINDS:InstanceLibrary:UnresolvedInstanceType', ...
            ['Version "%s" of the openMINDS instance library holds ', ...
            'instances of type(s) that the openMINDS model classes ', ...
            'loaded in this session do not declare: %s. These ', ...
            'instances are listed without a type. Either the library ', ...
            'is ahead of model version "%s", or something in the ', ...
            'session still holds the classes of a model version ', ...
            'selected earlier; clear what holds them, or restart ', ...
            'MATLAB.'], ...
            libraryVersion, summarizeTypeNames(unresolvedTypeIRIs), ...
            modelVersion)
    end

    folderInfo = table(typeNames, moduleNames, iriSegments, ...
        'VariableNames', ["TypeName", "ModuleName", "IRISegment"]);
end

function iriSegmentIndex = createIRISegmentIndex(folderInfo)
% createIRISegmentIndex - Index IRI path segments by type name
%
%   Several folders can hold the same type, so the rows are made
%   unique. Folders whose type could not be resolved are left out.

    isResolved = folderInfo.TypeName ~= "" & ~ismissing(folderInfo.IRISegment);
    iriSegmentIndex = unique( ...
        folderInfo(isResolved, iriSegmentIndexVariableNames()) );
end

function subGroups = resolveSubgroups(folderPaths, typeNames, rootFolder)
% resolveSubgroups - Resolve the subgroup name for each folder
%
%   Instances of one type are sometimes split into subfolders, e.g.
%   parcellationEntities/BA-human, where BA-human is a subgroup. Other
%   folders hold one type per subfolder, e.g. terminologies/ageCategory,
%   where ageCategory is a type and not a subgroup. Neither layout is
%   declared anywhere, so the two are told apart by the resolved types: a
%   subfolder is a subgroup when all its sibling folders hold the same
%   type.

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

function variableNames = iriSegmentIndexVariableNames()
% iriSegmentIndexVariableNames - Columns of the IRI segment index
    variableNames = ["IRISegment", "TypeName"];
end

function [instanceTable, iriSegmentIndex] = emptyInstanceTables()
% emptyInstanceTables - The tables of a library with no instances to read
%
%   Returned when a model version has no instances. The tables have their
%   columns and no rows, so callers can filter and index them without
%   special-casing an empty library.

    numColumns = numel(instanceTableVariableNames());
    instanceTable = array2table(strings(0, numColumns), ...
        'VariableNames', instanceTableVariableNames());

    iriSegmentIndex = array2table(strings(0, 2), ...
        'VariableNames', iriSegmentIndexVariableNames());
end

function versionString = normalizeModelVersion(modelVersion)
% normalizeModelVersion - Name a model version the way openminds.version does
%
%   Formats a model version as openminds.version does, e.g. "v3.0".
%   getSingleton compares ModelVersion against openminds.version, so the
%   stored value must use the same format. The selected version is
%   formatted here rather than read back from openminds.version because
%   that lookup caches its result for one second and may still return the
%   previous version.

    versionNumber = openminds.internal.utility.VersionNumber(modelVersion);
    versionNumber.Format = "vX.Y";
    versionString = string(versionNumber);
end

function typeList = summarizeTypeNames(typeIRIs)
% summarizeTypeNames - Name the types of a set of type IRIs for a message
%
%   A version mismatch typically leaves every type of a module unresolved,
%   which is too many names for one warning, so the list is capped.

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
%   Reads the first HEADER_NUM_BYTES bytes only. "@id" and "@type" are at
%   the top of every openMINDS instance document, and reading thousands of
%   documents in full to recover two lines each would be slow.

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
