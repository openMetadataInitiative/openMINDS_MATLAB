function instances = listControlledInstances(schemaType, moduleName, instanceName)
% listControlledInstances - List instances for given options.
%
%   This function returns a table containing information about instances.
%   Input arguments can be used to control whether to show instances for
%   particular schemas or modules.
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
%       moduleName - openminds.enum.Modules (default will list all)
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
        moduleName (1,:) openminds.enum.Modules = openminds.enum.Modules.empty
        instanceName (1,1) string = missing
    end

    import openminds.internal.utility.git.isLatest
    import openminds.internal.utility.git.downloadRepository

    % Make singleton class that can be reset...
    instanceLibrary = openminds.internal.InstanceLibrary.getSingleton();
    instanceTable = instanceLibrary.InstanceTable;

    keep = true(height(instanceTable), 1);

    if ~isempty(schemaType) && ~(isscalar(schemaType) && strcmp(schemaType, "None"))
        keep = keep & ismember(instanceTable.Type, schemaType);
    end

    if ~isempty(moduleName)
        keep = keep & ismember(instanceTable.Module, moduleName);
    end

    if ~ismissing(instanceName)
        keep = keep & instanceTable.InstanceName == instanceName;
    end

    instances = instanceTable(keep, :);
end
