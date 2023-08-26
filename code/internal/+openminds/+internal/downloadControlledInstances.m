function downloadControlledInstances()
    
    import openminds.internal.extern.fex.filedownload.downloadFile

    webUrl = "https://github.com/openMetadataInitiative/openMINDS_instances/archive/refs/heads/main.zip";
    webURI = matlab.net.URI( webUrl );

    targetDirectory = openminds.internal.PathConstants.LocalInstanceFolder;
    
    % - Create path for saving and download schemas
    zipFileName = webURI.Path(end);

    tempZipFilepath = tempname + "-" + zipFileName;
    %disp(tempZipFilepath)
    
    C1 = onCleanup(@(pathStr) delete(tempZipFilepath) );
   
    fprintf('Downloading instances from openMINDS repository...\n')
    downloadFile(tempZipFilepath, webURI.EncodedURI);
    fprintf('Done.\n')

    directoryForUnzip = tempname;
    if ~isfolder(directoryForUnzip)
        mkdir(directoryForUnzip)
    end

    C2 = onCleanup(@(pathStr, mode) rmdir(directoryForUnzip, "s") );

    fprintf('Unzipping instances...\n')
    unzip(tempZipFilepath, directoryForUnzip)
    fprintf('Done.\n')

    sourceDirectory = fullfile(directoryForUnzip, 'openMINDS_instances-main', 'instances');
    %targetDirectory = fullfile(openMindsFolderPath, 'instances');

    if ~isfolder(targetDirectory)
        mkdir(targetDirectory)
    end

    fprintf('Copying instances to local directory (%s)...\n', targetDirectory)
    copyfile(sourceDirectory, targetDirectory)
    fprintf('Done.\n') 
end
