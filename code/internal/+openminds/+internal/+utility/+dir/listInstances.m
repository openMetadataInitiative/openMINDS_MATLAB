function schemaInfo = listInstances(schemaModule, options)
%listSourceSchemas List information about all available schemas.   
%   
%   schemaInfo = listSourceSchemas() returns a table with information
%   about all the available schemas.

% Todo: Rename function, as it is used for listing instances as well.

% Note: Adapted from listSourceSchemas to list instances from the new
% OMI/openMINDS_instances repository
% This should be simplified.

    arguments
        schemaModule = {}
        options.SchemaType (1,1) string = "terminology";
        options.SchemaFileExtension = '.jsonld';
        options.VersionNumber (1,1) string = "latest" 
        options.RootDirectory (1,1) string = ""
    end

    versionNumber = openminds.internal.validateVersionNumber(options.VersionNumber);
    versionAsString = sprintf('v%s', versionNumber);
        
    % - Get path constant
    if options.RootDirectory == ""
        sourceSchemaFolder = openminds.internal.PathConstants.SourceSchemaFolder;
        schemaFolderPath = fullfile( sourceSchemaFolder, versionAsString, options.SchemaType);
    else
        sourceSchemaFolder = options.RootDirectory;
        schemaFolderPath = fullfile( sourceSchemaFolder, options.SchemaType);
    end
    
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

    [filePaths, ~] = listFiles(absPath, fileExtension);
end

function S = collectInfoInStructArray(schemaFolderPath, filePaths, format)
    
    FILE_EXT = '.schema.tpl';
    
    % - Get relevant parts of folder hierarchy for extracting information
    folderNames = replace(filePaths, schemaFolderPath, '');
    [folderNames, fileNames] = fileparts(folderNames);

    % - Create struct array with information about all schemas
    schemaNames = replace(fileNames, FILE_EXT, '');

    if format == "terminologies"
        S = struct('InstanceName', schemaNames);
    else
        S = struct('SchemaName', schemaNames);
    end

    for i = 1:numel(S)

        thisFolderSplit = strsplit(folderNames{i}, filesep);
        if isempty(thisFolderSplit{1})
            thisFolderSplit(1) = [];
        end

        S(i).ModuleName = "controlledTerms";
        S(i).ModuleVersion = "N/A";
        
        S(i).SubModuleName = "";
        S(i).SchemaName = thisFolderSplit{1};
        
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