function data = getControlledInstance(instanceName, schemaName, modelName, versionNumber, options)
    
    arguments
        instanceName (1,1) string
        schemaName (1,1) string
        modelName (1,1) string = "controlledTerms"
        versionNumber (1,1) openminds.internal.utility.VersionNumber ...
            {openminds.mustBeValidVersion(versionNumber)} = missing
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
            data = getOfflineInstance(instanceName, schemaName, modelName, versionNumber);
        catch
            data = getOnlineInstance(instanceName, schemaName, modelName, versionNumber);
        end
    else
        data = getOnlineInstance(instanceName, schemaName, modelName, versionNumber);
    end
end

function data = getOnlineInstance(instanceName, schemaName, modelName, versionNumber)

    filePath = getOnlineFilepath(instanceName, schemaName, modelName, versionNumber);
    jsonStr = webread(filePath);
    data = openminds.internal.utility.json.decode(jsonStr);

    % Save instance locally
    filePath = getOfflineFilepath(instanceName, schemaName, modelName, versionNumber);
    openminds.internal.utility.filewrite(filePath, jsonStr)
end

function data = getOfflineInstance(instanceName, schemaName, modelName, versionNumber)

    % import openminds.internal.listControlledInstances
    
    % instanceTable = listControlledInstances(schemaName, modelName, instanceName);

    % assert(size(instanceTable, 1) == 1, 'Expected a single match for instance "%s", but %d was found.', instanceName, size(instanceTable, 1))
    % jsonStr = fileread(instanceTable.Filepath);

    filePath = getOfflineFilepath(instanceName, schemaName, modelName, versionNumber);

    if ~isfile(filePath)
        error('File does not exist')
    end

    jsonStr = fileread(filePath);
    jsonStr = strrep(jsonStr, '''', ''''''); %If character array contains ', need to replace with ''
    data = openminds.internal.utility.json.decode(jsonStr);
end

function pathStr = getOnlineFilepath(instanceName, schemaName, modelName, versionNumber)
    import openminds.internal.constants.Github
    import openminds.internal.utility.string.uriJoin

    fileParts = getRelativeInstanceFileParts(instanceName, schemaName, modelName);
    relativePath = uriJoin(["main", "instances", versionNumber, fileParts]);
    pathStr = Github.getRawFileUrl("instances", relativePath);
end

function pathStr = getOfflineFilepath(instanceName, schemaName, modelName, versionNumber)
    rootPath = openminds.internal.PathConstants.LocalInstanceFolder;
    fileParts = getRelativeInstanceFileParts(instanceName, schemaName, modelName);
    
    pathStr = fullfile(rootPath, versionNumber, fileParts{:});
end

function fileParts = getRelativeInstanceFileParts(instanceName, schemaName, modelName)
    
    % Initialize the folder list with foldername given the model
    switch modelName
        case 'controlledTerms'
            folderList = "terminologies";
        case 'sands'
            folderList = "graphStructures";
        case 'core'
            folderList = [];
            schemaName = schemaName + "s"; % Make plural
    end

    fileName = instanceName + ".jsonld";

    % Add all relative file parts to a list
    fileParts = [folderList, schemaName, fileName];
end
