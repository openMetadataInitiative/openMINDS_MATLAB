function data = getControlledInstance(instanceName, schemaName, modelName)
    
    arguments
        instanceName (1,1) string
        schemaName (1,1) string
        modelName (1,1) string
    end
    
    try
        data = getOnlineInstance(instanceName, schemaName, modelName);
    catch
        data = getOfflineInstance(instanceName, schemaName, modelName);
    end
end

function data = getOnlineInstance(instanceName, schemaName, modelName)
       
    arguments
        instanceName (1,1) string
        schemaName (1,1) string
        modelName (1,1) string = "controlledTerms"
    end
        
    import openminds.internal.constants.Github
    import openminds.internal.utility.string.uriJoin
    
    if ~strcmp( upper(schemaName{1}(1:2)), schemaName{1}(1:2))
        schemaName{1}(1) = lower(schemaName{1}(1));
    end

    % Note: modelName is currently not used.

    % Build url for file
    branchUrl = "main/instances/latest/terminologies";
    instancePath = uriJoin(branchUrl, schemaName, instanceName+".jsonld");

    url = Github.getRawFileUrl("instances", instancePath);

    jsonStr = webread(url);
    data = openminds.internal.utility.json.decode(jsonStr);
end

function data = getOfflineInstance(instanceName, schemaName, modelName)

    import openminds.internal.listControlledInstances
    
    instanceTable = listControlledInstances(schemaName, modelName, instanceName);

    assert(size(instanceTable, 1) == 1, 'Expected a single match for instance "%s", but %d was found.', instanceName, size(instanceTable, 1))

    jsonStr = fileread(instanceTable.Filepath);
           
    jsonStr = strrep(jsonStr, '''', ''''''); %If character array contains ', need to replace with ''
    data = openminds.internal.utility.json.decode(jsonStr);
end
