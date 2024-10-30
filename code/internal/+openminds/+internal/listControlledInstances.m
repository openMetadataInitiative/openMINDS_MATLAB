function instances = listControlledInstances(schemaName, modelName, instanceName)
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
%       instances = listControlledInstances(schemaName) list all available
%           controlled instances for given schema name
%
%       instances = listControlledInstances(schemaName, modelName) list all
%           available controlled instances for given schema name
%
%   Input Arguments:
%       schemaName - Name (default will list all)
%       modelName - Name (default - controlledTerms)
%
%   Output Arguments:
%       instances - Table
%
%   Note: The information about instances is retrieved from a local copy of
%   the instances repository. The table will be persistent and stay in
%   memory, and will be updated if new commit(s) are available on the
%   instances repository.

    import openminds.internal.utility.git.isLatest
    import openminds.internal.utility.git.downloadRepository

    if nargin < 3
        instanceName = [];
    end

    if nargin < 2
        modelName = '';
    end

    if nargin < 1
        schemaName = '';
    end
    
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
            'SchemaFileExtension', '.jsonld', ...
            'RootDirectory', instanceDirectory);
    end

    % Todo: match on camel case!!!
    
    isRequested = true(height(allInstancesTable), 1);
    
    if ~isempty(schemaName)
        isRequested = isRequested & strcmpi(allInstancesTable.SchemaName, schemaName);
    end

    if ~isempty(modelName)
        isRequested = isRequested & strcmpi(allInstancesTable.ModelName, modelName);
    end

    if ~isempty(instanceName)
        isRequested = isRequested & allInstancesTable.InstanceName == instanceName;
    end

    instances = allInstancesTable(isRequested, :);
end
