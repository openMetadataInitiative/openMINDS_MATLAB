function downloadControlledInstances()
    
    import openminds.internal.extern.fex.filedownload.downloadFile

    webUrl = "https://github.com/openMetadataInitiative/openMINDS_instances/archive/refs/heads/main.zip";
    webURI = matlab.net.URI( webUrl );

    openMindsFolderPath = openminds.internal.rootpath();
    
    % - Create path for saving and download schemas
    zipFileName = webURI.Path(end);

    tempZipFilepath = tempname + "-" + zipFileName;
    disp(tempZipFilepath)
    
    C1 = onCleanup(@(pathStr) delete(tempZipFilepath) );
   
    fprintf('Downloading schemas from openMINDS repository...')
    downloadedFile = downloadFile(tempZipFilepath, webURI.EncodedURI);
    disp(downloadedFile)
    fprintf('Done.\n')

    directoryForUnzip = tempname;
    if ~isfolder(directoryForUnzip)
        mkdir(directoryForUnzip)
    end

    C2 = onCleanup(@(pathStr, mode) rmdir(directoryForUnzip, "s") );

    unzip(tempZipFilepath, directoryForUnzip)

    sourceDirectory = fullfile(directoryForUnzip, 'openMINDS_instances-main', 'instances');
    targetDirectory = fullfile(openMindsFolderPath, 'instances');

    if ~isfolder(targetDirectory)
        mkdir(targetDirectory)
    end

    copyfile(sourceDirectory, targetDirectory)
end