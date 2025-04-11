function downloadRepository(repositoryName, options)
% downloadRepository - Download a repository from GitHub
%
%   Input arguments:
%       repositoryName - Name of repository
%
%   Optional parameters:
%       BranchName - Name of branch
%       Organization - Name of organization

    arguments
        repositoryName = "openMINDS"
        options.BranchName = "main"
        options.Organization = "openMetadataInitiative"
    end
    
    import openminds.internal.extern.fex.filedownload.downloadFile
    import openminds.internal.utility.git.getCurrentCommitID
    import openminds.internal.utility.git.saveCurrentCommitID

    webUrl = sprintf("https://github.com/%s/%s/archive/refs/heads/%s.zip", ...
        options.Organization, repositoryName, options.BranchName);
    webURI = matlab.net.URI( webUrl );

    targetDirectory = openminds.internal.PathConstants.UserPath;
    targetDirectory = fullfile(targetDirectory, 'Repositories');

    % - Create path for saving and download types
    zipFileName = webURI.Path(end);

    tempZipFilepath = tempname + "-" + zipFileName;
    % disp(tempZipFilepath)
    
    C1 = onCleanup(@(pathStr) delete(tempZipFilepath) );
   
    fprintf('Downloading repository "%s" from "%s"... ', ...
        repositoryName, options.Organization)
    downloadFile(tempZipFilepath, webURI.EncodedURI, 'ShowFilename', true);
    fprintf('Done.\n')

    directoryForUnzip = tempname;
    if ~isfolder(directoryForUnzip)
        mkdir(directoryForUnzip)
    end

    C2 = onCleanup(@(pathStr, mode) rmdir(directoryForUnzip, "s") );

    fprintf('Unzipping repository file (%s)... ', repositoryName)
    unzip(tempZipFilepath, directoryForUnzip)
    fprintf('Done.\n')

    sourceDirectory = directoryForUnzip;

    if ~isfolder(targetDirectory)
        mkdir(targetDirectory)
    end

    % Get repository folder name
    L = dir(sourceDirectory); L(startsWith({L.name}, '.')) = [];
    assert(numel(L) == 1, "Expected temporary folder to contain one downloaded item")
    folderName = strtrim( L.name );
    if isfolder( fullfile(targetDirectory, folderName) )
        rmdir(fullfile(targetDirectory, folderName), "s")
    end

    fprintf('Copying repository "%s" to local directory:\n%s... ', repositoryName, targetDirectory)
    copyfile(sourceDirectory, targetDirectory)
    fprintf('Done.\n')

    % Save current commit ID and repository details
    nvPairs = namedargs2cell(options);
    [~, commitDetails] = getCurrentCommitID(repositoryName, nvPairs{:});
    saveCurrentCommitID(commitDetails)
end
