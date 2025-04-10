function manifest = loadSchemaManifest(versionNumber)
% loadSchemaManifest - Load the schema manifest for a given version
%
%   Syntax:
%   manifest = loadSchemaManifest() loads the schema manifest for the
%       latest version of openMINDS as a table.
%
%   manifest = loadSchemaManifest(versionNumber) loads the schema manifest
%       for the given version of openMINDS as a table.
%
%   Input arguments:
%       versionNumber : A string representing a version number. Examples:
%           "v1.0", "v2.0", "v3.0", "latest" (default)
%
%   Output arguments:
%       manifest : A table containing the following variables for each
%       schema:
%           Name - Name of the schema
%           Module - Name of the module the schema belongs to
%           Group - Name of the group the schema belongs to. Some modules do
%               not have groups, and then this is a blank string.

    arguments
        versionNumber (1,1) string = "latest"
    end

    schemaRootFolder = openminds.internal.PathConstants.MatlabSchemaFolder;
    manifestDirectory = fullfile(schemaRootFolder, versionNumber, "resources");

    data = jsondecode( fileread( fullfile(manifestDirectory, "schema_manifest.json") ) );

    % Convert data to table and convert columndata to string
    manifest = struct2table(data);
    manifest.name = string(manifest.name);
    manifest.module = string(manifest.module);
    
    isEmptyGroup = cellfun(@isempty, manifest.group(:));
    [manifest.group(isEmptyGroup)] = deal({''});
    
    manifest.group = string(manifest.group);

    % Rename variables
    manifest.Properties.VariableNames = ["Name", "Module", "Group"];
end
