function instances = listControlledInstances(schemaName, modelName, instanceName)

    if nargin < 3
        instanceName = [];
    end
    
    % Make singleton class that can be reset...
    persistent allInstancesTable
    
    if isempty(allInstancesTable)

        try % Use terminologies from openMetadataInitiative/openMINDS_instances repo
            instanceDirectory = fullfile(openminds.internal.rootpath, 'instances', 'latest');
            allInstancesTable = openminds.internal.utility.dir.listInstances(...
                'SchemaType', 'terminologies', 'SchemaFileExtension', '.jsonld', ...
                'RootDirectory', instanceDirectory);
        catch % Use instances from HumanBrainProject/openMINDS repo
            allInstancesTable = openminds.internal.utility.dir.listSourceSchemas(...
                'SchemaType', 'instances', 'SchemaFileExtension', '.jsonld');
        end
    end

    % Todo: match on camel case!!!

    isRequested = allInstancesTable.ModuleName == modelName & ...
                    strcmpi(allInstancesTable.SchemaName, schemaName);
    
    if ~isempty(instanceName)
        isRequested = isRequested & allInstancesTable.InstanceName == instanceName;
    end

    instances = allInstancesTable(isRequested, :);
end