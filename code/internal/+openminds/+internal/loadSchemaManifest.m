function manifest = loadSchemaManifest(versionNumber)

    arguments
        versionNumber (1,1) string = "latest"
    end

    schemaRootFolder = openminds.internal.PathConstants.MatlabSchemaFolder;
    manifestDirectory = fullfile(schemaRootFolder, versionNumber, "resources");

    data = jsondecode( fileread( fullfile(manifestDirectory, "schema_manifest.json") ) );

    % Convert data to table and convert columndata to string
    manifest = struct2table(data);
    manifest.name = string(manifest.name);
    manifest.model = string(manifest.model);
    
    isEmptyGroup = cellfun(@isempty, manifest.group(:));
    [manifest.group(isEmptyGroup)] = deal({''});
    
    manifest.group = string(manifest.group);

    % Rename variables
    manifest.Properties.VariableNames = ["Name", "Model", "Group"];
