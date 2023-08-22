function data = getControlledInstance(instanceName, schemaName, modelName)
    
    arguments
        instanceName (1,1) string
        schemaName (1,1) string
        modelName (1,1) string
    end

    import openminds.internal.listControlledInstances
    
    instanceTable = listControlledInstances(schemaName, modelName, instanceName);

    assert(size(instanceTable, 1) == 1, 'Expected a single match for instance "%s", but %d was found.', instanceName, size(instanceTable, 1))

    jsonStr = fileread(instanceTable.Filepath);
           
    jsonStr = strrep(jsonStr, '''', ''''''); %If character array contains ', need to replace with ''
    data = openminds.internal.utility.json.decode(jsonStr);
end