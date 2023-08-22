function downloadSchemas(versionNumber)
%downloadSchemas Download openMINDS source files from github
%
%   downloadSchemas() downloads the source files for the latest version
%
%   downloadSchemas(versionNumber) downloads the source files for the
%   specified version

    arguments
        versionNumber (1,1) string = "latest"
    end

    import openminds.internal.extern.fex.filedownload.downloadFile

    % - Validate inputs
    versionNumber = openminds.internal.validateVersionNumber(versionNumber);
    versionAsString = sprintf('v%s', versionNumber);

    % - Get some path/uri constants
    filename = sprintf("openMINDS-v%s.zip", versionNumber);
    schemaPathStr = sprintf("%s/%s", openminds.internal.Constants.ReleaseURL, filename);
    schemaURI = matlab.net.URI( schemaPathStr );
    openMindsFolderPath = openminds.internal.rootpath();
    
    % - Create path for saving and download schemas
    downloadFolderPath = fullfile(openMindsFolderPath, 'temp');
    zipFileName = schemaURI.Path(end);
    tempPath = fullfile(downloadFolderPath, zipFileName); % Todo: use tempname

    if ~isfolder(downloadFolderPath); mkdir(downloadFolderPath); end

    fprintf('Downloading schemas from openMINDS repository...')
    downloadFile(tempPath, schemaURI.EncodedURI)
    fprintf('Done.\n')

    % - Unzip downloaded file
    schemaFolderPath = fullfile(openminds.internal.PathConstants.SourceSchemaFolder, versionAsString);
    if ~isfolder(schemaFolderPath); mkdir(schemaFolderPath); end
    
    % Todo: Unzip file in a new folder and then do diff on all schema.tpl
    % files.

    unzip(tempPath, schemaFolderPath)
    delete(tempPath)
    
    % Save the current commit ID
    %openminds.internal.utility.git.saveCurrentSchemaCommitID()
end