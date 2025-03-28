function instanceTable = listInstances(options)
%listInstances List information about all available metadata instances.
%
%   instanceTable = listInstances() returns a table with information
%   about all the available controlled instances.

    arguments
        options.VersionNumber (1,1) string = "latest"
        options.RootDirectory (1,1) string = ""
    end

    instanceFileFormat = ".jsonld";

    versionNumber = openminds.internal.validateVersionNumber(options.VersionNumber);
    versionAsString = sprintf('v%s', versionNumber);
    
    % - Get path constant
    if options.RootDirectory == ""
        sourceSchemaFolder = openminds.internal.PathConstants.SourceSchemaFolder;
        schemaFolderPath = fullfile( sourceSchemaFolder, versionAsString);
    else
        sourceSchemaFolder = options.RootDirectory;
        schemaFolderPath = fullfile( sourceSchemaFolder);
    end

    L = dir(fullfile(schemaFolderPath, '**', "*"+instanceFileFormat));
    filePaths = join([{L.folder}', {L.name}'], filesep);

    if isempty(filePaths)
        error("openMINDS:SourceFilesMissing", 'Could not find instance files for openMINDS %s', versionAsString)
    end

    S = collectInfoInStructArray(schemaFolderPath, filePaths);

    instanceTable = convertStructToTable(S);
end

function S = collectInfoInStructArray(schemaFolderPath, filePaths)
    
    SANDS_INSTANCE_FOLDERS = openminds.internal.constants.SandsInstanceFolders();
    
    % - Get relevant parts of folder hierarchy for extracting information
    folderNames = replace(filePaths, schemaFolderPath, '');
    [folderNames, instanceNames] = fileparts(folderNames);

    % - Create struct array with information about all schemas
    S = struct('InstanceName', instanceNames);

    for i = 1:numel(S)

        thisFolderSplit = strsplit(folderNames{i}, filesep);
        if isempty(thisFolderSplit{1})
            thisFolderSplit(1) = [];
        end

        if strcmp(thisFolderSplit{1}, 'terminologies')
            if numel(thisFolderSplit) == 2
                S(i).SchemaName = thisFolderSplit{end};
                S(i).ModelName = "controlledTerms";
                S(i).ModelVersion = "N/A";
                S(i).GroupName = "";
            else
                error("Unexpected number of subfolders for terminologies. Please report!")
            end

        elseif any( strcmp(thisFolderSplit{1}, SANDS_INSTANCE_FOLDERS))

            S(i).SchemaName = thisFolderSplit{1};
            S(i).ModelName = "SANDS";
            S(i).ModelVersion = "N/A";
            if numel(thisFolderSplit) == 1
                S(i).GroupName = "";
            elseif numel(thisFolderSplit) == 2
                S(i).GroupName = string(thisFolderSplit{end});
            else
                error("Unexpected number of subfolders for SANDS instances. Please report!")
            end

        elseif any( strcmp(thisFolderSplit{1}, ["licenses", "contentTypes"]) )
            if strcmp( thisFolderSplit{end}, 'licenses')
                S(i).SchemaName = 'License';
            elseif strcmp( thisFolderSplit{end}, 'contentTypes')
                S(i).SchemaName = 'ContentType';
            else
                warning('Unhandled instance ("%s")', thisFolderSplit{end})
                S(i).SchemaName = 'Unresolved';
            end
            S(i).ModelName = "core";
            S(i).ModelVersion = "N/A";
            S(i).GroupName = "";
        else
            error('The instance folder with name "%s" is not implemented. Please report', thisFolderSplit{1})
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
