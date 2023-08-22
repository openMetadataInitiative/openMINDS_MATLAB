function schemaInfo = listSourceSchemas(schemaModule, options)
%listSourceSchemas List information about all available schemas.   
%   
%   schemaInfo = listSourceSchemas() returns a table with information
%   about all the available schemas.

% Todo: Rename function, as it is used for listing instances as well.

    arguments
        schemaModule = {}
        options.SchemaType (1,1) string = "schema.tpl.json";
        options.SchemaFileExtension = '.json';
        options.VersionNumber (1,1) string = "latest" 
    end

    versionNumber = openminds.internal.validateVersionNumber(options.VersionNumber);
    versionAsString = sprintf('v%s', versionNumber);
        
    % - Get path constant
    sourceSchemaFolder = openminds.internal.PathConstants.SourceSchemaFolder;
    schemaFolderPath = fullfile( sourceSchemaFolder, versionAsString, options.SchemaType);
    
    filePaths = listSchemaFiles(schemaFolderPath, schemaModule, options.SchemaFileExtension);
    
    if isempty(filePaths)
        error("openMINDS:SourceFilesMissing", 'Could not find source files for openMINDS %s', versionAsString)
    end

    S = collectInfoInStructArray(schemaFolderPath, filePaths, options.SchemaType);

    schemaInfo = convertStructToTable(S);
end

function [filePaths] = listSchemaFiles(schemaFolderPath, schemaModule, fileExtension)
%listSchemaFiles List schema files given a root directory

    import openminds.internal.utility.dir.listSubDir
    import openminds.internal.utility.dir.listFiles 

    if nargin < 3 || isempty(fileExtension)
        fileExtension = '.json';
    end

    % - Look through subfolders for all json files of specified modules
    [absPath, dirName] = listSubDir(schemaFolderPath, '', {}, 0);
    
    if ~isempty(schemaModule) % Filter by given module(s), if any
        [~, keepIdx] = intersect(dirName, schemaModule);
        absPath = absPath(keepIdx);
    end

    [absPath, ~] = listSubDir(absPath, '', {}, 2);
    [filePaths, ~] = listFiles(absPath, fileExtension);
end

function S = collectInfoInStructArray(schemaFolderPath, filePaths, format)
    
    FILE_EXT = '.schema.tpl';
    
    % - Get relevant parts of folder hierarchy for extracting information
    folderNames = replace(filePaths, schemaFolderPath, '');
    [folderNames, fileNames] = fileparts(folderNames);

    % - Create struct array with information about all schemas
    schemaNames = replace(fileNames, FILE_EXT, '');

    if format == "instances"
        S = struct('InstanceName', schemaNames);
    else
        S = struct('SchemaName', schemaNames);
    end

    for i = 1:numel(S)

        thisFolderSplit = strsplit(folderNames{i}, filesep);
        if isempty(thisFolderSplit{1})
            thisFolderSplit(1) = [];
        end

        S(i).ModuleName = thisFolderSplit{1};
        S(i).ModuleVersion = thisFolderSplit{2};
        
        if numel(thisFolderSplit) == 2
            S(i).SubModuleName = '';

        elseif numel(thisFolderSplit) == 3 && format == "instances"
            S(i).SubModuleName = '';
            S(i).SchemaName = thisFolderSplit{3};
        
        elseif numel(thisFolderSplit) == 3 && format ~= "instances"
            S(i).SubModuleName = matlab.lang.makeValidName(thisFolderSplit{3});
        
        elseif numel(thisFolderSplit) == 4
            S(i).SubModuleName = matlab.lang.makeValidName(thisFolderSplit{3});
            S(i).SchemaName = thisFolderSplit{4};
        
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