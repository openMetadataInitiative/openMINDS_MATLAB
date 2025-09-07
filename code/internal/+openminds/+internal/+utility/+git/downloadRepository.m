function downloadRepository(repositoryName, options)
% downloadRepository - Download a repository from GitHub
%
%   Input arguments:
%       repositoryName - Name of repository
%
%   Optional parameters:
%       BranchName - Name of branch
%       Owner - Name of repository owner

    arguments
        repositoryName = "openMINDS"
        options.BranchName = "main"
        options.Owner = openminds.internal.constants.Github.Organization
        options.TargetDirectory (1,1) string = ...
            fullfile(openminds.internal.PathConstants.UserPath, 'Repositories')
    end
    
    import openminds.internal.extern.fex.filedownload.downloadFile
    import openminds.internal.utility.git.getCurrentCommitID
    import openminds.internal.utility.git.saveCurrentCommitID

    webUrl = sprintf("https://github.com/%s/%s/archive/refs/heads/%s.zip", ...
        options.Owner, repositoryName, options.BranchName);
    webURI = matlab.net.URI( webUrl );

    % - Create path for saving and download types
    zipFileName = webURI.Path(end);

    tempZipFilepath = tempname + "-" + zipFileName;
    % disp(tempZipFilepath)
    
    C1 = onCleanup(@(pathStr) delete(tempZipFilepath) );
   
    fprintf('Downloading repository "%s" from "%s"... ', ...
        repositoryName, options.Owner)
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

    if ~isfolder(options.TargetDirectory)
        mkdir(options.TargetDirectory)
    end

    % Get repository folder name
    L = dir(sourceDirectory); L(startsWith({L.name}, '.')) = [];
    assert(isscalar(L), "Expected temporary folder to contain one downloaded item")
    folderName = strtrim( L.name );
    if isfolder( fullfile(options.TargetDirectory, folderName) )
        rmdir(fullfile(options.TargetDirectory, folderName), "s")
    end

    fprintf('Copying repository "%s" to local directory:\n%s... ', repositoryName, options.TargetDirectory)
    copyfile(sourceDirectory, options.TargetDirectory)
    fprintf('Done.\n')

    % Save current commit ID and repository details
    [~, commitDetails] = getCurrentCommitID(repositoryName, ...
        "BranchName", options.BranchName, ...
        "Owner", options.Owner);
    saveCurrentCommitID(commitDetails)
end
