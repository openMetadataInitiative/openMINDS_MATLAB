function update(mode)
%UPDATE Updates openMINDS schemas if necessary.
%
%   openminds.internal.update() checks the commit ID for the previous schema 
%   update and the current commit ID of the 'documentation' branch of the 
%   openMINDS github repository. If they are the same and the mode is not 
%   'force', it displays a message indicating that the schemas are up to date. 
%   Otherwise, it proceeds with updating the schemas.
%
%   openminds.internal.update(mode) allows specifying the update mode. The 
%   default mode is 'default', but setting it to 'force' forces the update 
%   regardless of the commit IDs.
%
%   Example:
%       openminds.internal.update()
%       openminds.internal.update('force')


    arguments
        mode (1,1) string = "default"
    end

    % - Check commitID, and return if previous commit is is same as current
    previousCommitID = openminds.internal.utility.git.loadPreviousCommitID();
    currentCommitID = openminds.internal.utility.git.getCurrentCommitID('documentation');

    if isequal(previousCommitID, currentCommitID) && mode ~= "force"
        disp('Schemas are up to date.')
    
    elseif isempty(previousCommitID)
        disp('Downloading openMINDS schemas.')
        openminds.internal.downloadSchemas()

        disp('Generating openMINDS schemas.')
        openminds.internal.generateSchemaClasses()
           
        disp('Finished!')
    else
        disp('Downloading openMINDS schemas.')
        openminds.internal.downloadSchemas()
        
        disp('Updating openMINDS schemas.')
        %openminds.internal.updateSchemas()

        % Temporary (openminds.internal.updateSchemas is not implemented yet)
        schemaFolderPath = fullfile(openminds.internal.Constants.SchemaFolder, 'matlab', '+openminds');
        if isfolder(schemaFolderPath)
            rmdir(schemaFolderPath, 's' )
        end
        openminds.internal.generateSchemaClasses()

        disp('Finished!')
    end

    openminds.internal.utility.git.saveCurrentCommitID()

    % Check that the schemafolder in on path
    currentPathList = strsplit(path, pathsep);

    if ~any(strcmp(currentPathList, openminds.internal.Constants.SchemaFolder))
        addpath(genpath(openminds.internal.Constants.SchemaFolder))
    end
    
end

% Todo: If updating, need to keep old schemas until update is complete.