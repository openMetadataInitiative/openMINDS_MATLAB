function schemaInfo = listSourceSchemas(schemaModule, options)
%listSourceSchemas List information about all available schemas.
%
%   schemaInfo = listSourceSchemas() returns a table with information
%   about all the available schemas.

    arguments
        schemaModule = {}
        options.SchemaType (1,1) string = "schema.omi.json";
        options.SchemaFileExtension = '*.omi.json';
        options.VersionNumber (1,1) openminds.internal.utility.VersionNumber ...
            {openminds.mustBeValidVersion(options.VersionNumber)} = "latest"
    end

    versionAsString = char(options.VersionNumber);
        
    % - Get path constant
    sourceSchemaFolder = char(openminds.internal.PathConstants.SourceSchemaFolder);
    schemaFolderPath = fullfile( sourceSchemaFolder, versionAsString);
    
    L = dir(fullfile(schemaFolderPath, '**', options.SchemaFileExtension));
    filePaths = fullfile({L.folder}, {L.name});

    if isempty(filePaths)
        error("openMINDS:SourceFilesMissing", 'Could not find source files for openMINDS %s', versionAsString)
    end

    S = collectInfoInStructArray(schemaFolderPath, filePaths);

    schemaInfo = convertStructToTable(S);
end

function S = collectInfoInStructArray(schemaFolderPath, filePaths)
    
    FILE_EXT = '.schema.omi';
    
    % - Get relevant parts of folder hierarchy for extracting information
    folderNames = replace(filePaths, schemaFolderPath, '');
    [folderNames, fileNames] = fileparts(folderNames);

    % - Create struct array with information about all schemas
    schemaNames = replace(fileNames, FILE_EXT, '');

    S = struct('SchemaName', schemaNames);

    for i = 1:numel(S)

        thisFolderSplit = strsplit(folderNames{i}, filesep);
        if isempty(thisFolderSplit{1})
            thisFolderSplit(1) = [];
        end

        S(i).ModuleName = thisFolderSplit{1};
        
        if numel(thisFolderSplit) == 1
            S(i).SubModuleName = '';
        
        elseif numel(thisFolderSplit) == 2
            S(i).SubModuleName = matlab.lang.makeValidName(thisFolderSplit{2});
        
        elseif numel(thisFolderSplit) == 3
            S(i).SubModuleName = matlab.lang.makeValidName(thisFolderSplit{2});
            S(i).SchemaName = thisFolderSplit{3};
        else
            error('Something unexpected happened');
        end
        S(i).Filepath = filePaths{i};
    end
end

function schemaInfo = convertStructToTable(S)
%convertStructToTable Convert struct to table and format columns as strings
    
    % - Convert struct array to table
    schemaInfo = struct2table(S);
    
    % - Convert all columns to string columns
    for i = 1:size(schemaInfo, 2)
        varName = schemaInfo.Properties.VariableNames{i};
        schemaInfo.(varName) = string(schemaInfo.(varName));
    end
end
