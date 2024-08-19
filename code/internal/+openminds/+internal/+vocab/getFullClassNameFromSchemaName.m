function fullClassName = getFullClassNameFromSchemaName(schemaName)
    
    persistent fullClassNameMap
    if isempty(fullClassNameMap)
        fullClassNameMap = buildFullClassNameMap();
    end
    
    if isKey(fullClassNameMap, schemaName)
        fullClassName = fullClassNameMap(schemaName);
    else
        throwSchemaNotFoundError(schemaName)
    end
end

function D = buildFullClassNameMap()
    % Todo: Use / or create openminds method for listing all schemas based
    % on selected version...
    schemaPath = fullfile( openminds.internal.rootpath, "schemas", "latest", "+openminds");
    
    relativeFilePaths = recursiveDir(schemaPath, ...
        'FileType', 'm', ...
        "IgnoreList", "Contents", ...
        "OutputType", "RelativeFilePath");

    [parentDir, schemaNames] = fileparts(relativeFilePaths);
    
    packageFolders = strrep( parentDir, "+", "");
    packageNames = strcat("openminds", strrep( packageFolders, filesep, ".") );
    
    classNames = packageNames + "." + schemaNames;
    D = dictionary(schemaNames,classNames);
end

function throwSchemaNotFoundError(schemaName)
    error('OPENMINDS:SchemaNameNotFound', 'No schema name matching "%s" was found.', schemaName);
end