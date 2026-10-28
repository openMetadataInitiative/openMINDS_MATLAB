function data = getControlledInstance(instanceName, schemaName, versionNumber, options)
% getControlledInstance - Read the document of a controlled term from the library
%
%   Only controlled terms are served here: they are stored one type per
%   folder under a fixed name, so their path can be built from the type.
%   Instances of other modules are stored under pluralized type names that
%   upstream renames, and are found through the InstanceLibrary instead.

    arguments
        instanceName (1,1) string
        schemaName (1,1) string
        versionNumber (1,1) openminds.internal.utility.VersionNumber ...
            {openminds.mustBeValidModelVersion(versionNumber)} = missing
        options.FileSource (1,1) string ...
            {mustBeMember(options.FileSource, ["local", "github"])} = "local"
    end

    if ismissing(versionNumber)
        versionNumber = openminds.getModelVersion("VersionNumber");
    end

    versionNumber = string(versionNumber);

    % Make type name lowercase unless it is an abbreviated typename like
    % e.g. UBERONParcellation
    if ~strcmp( upper(schemaName{1}(1:2)), schemaName{1}(1:2))
        schemaName{1}(1) = lower(schemaName{1}(1));
    end
    
    if options.FileSource == "local"
        try
            data = getOfflineInstance(instanceName, schemaName, versionNumber);
        catch
            data = getOnlineInstance(instanceName, schemaName, versionNumber);
        end
    else
        data = getOnlineInstance(instanceName, schemaName, versionNumber);
    end
end

function data = getOnlineInstance(instanceName, schemaName, versionNumber)

    filePath = getOnlineFilepath(instanceName, schemaName, versionNumber);
    jsonStr = webread(filePath);
    data = openminds.internal.utility.json.decode(jsonStr);

    % Save instance locally
    filePath = getOfflineFilepath(instanceName, schemaName, versionNumber);
    openminds.internal.utility.filewrite(filePath, jsonStr)
end

function data = getOfflineInstance(instanceName, schemaName, versionNumber)

    filePath = getOfflineFilepath(instanceName, schemaName, versionNumber);

    if ~isfile(filePath)
        error('File does not exist')
    end

    jsonStr = fileread(filePath);
    data = openminds.internal.utility.json.decode(jsonStr);
end

function pathStr = getOnlineFilepath(instanceName, schemaName, versionNumber)
    import openminds.internal.constants.Github
    import openminds.internal.utility.string.uriJoin

    fileParts = getRelativeInstanceFileParts(instanceName, schemaName);
    relativePath = uriJoin(["main", "instances", versionNumber, fileParts]);
    pathStr = Github.getRawFileUrl("instances", relativePath);
end

function pathStr = getOfflineFilepath(instanceName, schemaName, versionNumber)
    rootPath = openminds.internal.constants.Paths.LocalInstanceFolder;
    fileParts = getRelativeInstanceFileParts(instanceName, schemaName);

    pathStr = fullfile(rootPath, versionNumber, fileParts{:});
end

function fileParts = getRelativeInstanceFileParts(instanceName, schemaName)
% getRelativeInstanceFileParts - Path of a controlled term's file within a version
%
%   Controlled terms are stored one type per folder under "terminologies",
%   which is the one layout a path can be built for from a type name.

    fileName = instanceName + ".jsonld";
    fileParts = ["terminologies", schemaName, fileName];
end
