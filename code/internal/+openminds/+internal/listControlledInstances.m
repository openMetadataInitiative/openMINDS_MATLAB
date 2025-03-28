function instances = listControlledInstances(schemaType, moduleName, instanceName)
% listControlledInstances - List instances for given options.
%
%   This function returns a table containing information about instances.
%   Input arguments can be used to control whether to show instances for
%   particular schemas or models.
%
%   Syntax:
%       instances = listControlledInstances() list all available controlled
%           instances
%
%       instances = listControlledInstances(schemaType) list all available
%           controlled instances for given schema type
%
%       instances = listControlledInstances(schemaType, moduleName) list all
%           available controlled instances for given schema type and module
%
%   Input Arguments:
%       schemaType - openminds.enum.Types (default will list all)
%       moduleName - openminds.enum.Models (default will list all)
%
%   Output Arguments:
%       instances - Table
%
%   Note: The information about instances is retrieved from a local copy of
%   the instances repository. The table will be persistent and stay in
%   memory, and will be updated if new commit(s) are available on the
%   instances repository.

    arguments
        schemaType (1,:) openminds.enum.Types = openminds.enum.Types.empty
        moduleName (1,:) openminds.enum.Models = openminds.enum.Models.empty
        instanceName (1,1) string = missing
    end

    import openminds.internal.utility.git.isLatest
    import openminds.internal.utility.git.downloadRepository

    % Make singleton class that can be reset...
    persistent allInstancesTable
    
    % Check latest commit id for the instances github repository
    if isempty(allInstancesTable)

        instanceRootDirectory = openminds.internal.PathConstants.LocalInstanceFolder;

        if ~isfolder(instanceRootDirectory) || ~isLatest('Repository', 'openMINDS_instances')
            downloadRepository('openMINDS_instances')
        end

        instanceDirectory = fullfile(instanceRootDirectory, 'latest');

        allInstancesTable = openminds.internal.utility.dir.listInstances(...
            'RootDirectory', instanceDirectory);
    end

    % Todo: match on camel case!!!
    
    keep = true(height(allInstancesTable), 1);
    
    if ~isempty(schemaType) && ~(isscalar(schemaType) && strcmp(schemaType, "None"))
        keep = keep & ismember(allInstancesTable.SchemaName, schemaType);
    end

    if ~isempty(moduleName)
        %keep = keep & strcmpi(allInstancesTable.ModelName, moduleName);
        keep = keep & ismember(allInstancesTable.ModelName, moduleName);
    end

    if ~ismissing(instanceName)
        keep = keep & allInstancesTable.InstanceName == instanceName;
    end

    instances = allInstancesTable(keep, :);
end

