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

    % Get currently active version of the openMINDS model
    version = openminds.getModelVersion();

    typesFolder = fullfile( openminds.internal.rootpath, "types", version, "+openminds");
    
    % List all schema/type class files for the current version
    fileInfo = dir( fullfile(typesFolder, '**', '*.m'));
    fileInfo( strcmp({fileInfo.name}, 'Contents.m') ) = []; % Ignore Contents.m
    filePaths = string( fullfile( {fileInfo.folder}, {fileInfo.name} ) )';
    relativeFilePaths = strrep(filePaths, typesFolder, '');

    [parentDir, schemaNames] = fileparts(relativeFilePaths);
    
    packageFolders = strrep( parentDir, "+", "");
    packageNames = strcat("openminds", strrep( packageFolders, filesep, ".") );
    
    classNames = packageNames + "." + schemaNames;
    D = dictionary(schemaNames, classNames);
end

function throwSchemaNotFoundError(schemaName)
    error('OPENMINDS:SchemaNameNotFound', 'No schema name matching "%s" was found.', schemaName);
end
