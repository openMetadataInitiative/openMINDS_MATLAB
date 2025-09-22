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
        options.TargetDirectory = openminds.internal.utility.git.getRepositoryTargetRootFolder()
    end

    % Todo: Should be a preference.
    targetDirectory = options.TargetDirectory;
    
    import openminds.internal.extern.fex.filedownload.downloadFile
    import openminds.internal.utility.git.getCurrentCommitID
    import openminds.internal.utility.git.saveCurrentCommitID
    import openminds.internal.utility.git.hasLatestCommit

    % Check if we already have the latest commit
    if hasLatestCommit('RepositoryName', repositoryName, ...
                      'BranchName', options.BranchName, ...
                      'Owner', options.Owner)
        fprintf('Repository "%s" is already up to date. Skipping download.\n', repositoryName);
        return;
    end

    webURI = openminds.internal.utility.git.buildRepositoryURL(...
        options.Owner, repositoryName, options.BranchName);

    % - Create path for saving and download types
    zipFileName = webURI.Path(end);
    tempZipFilepath = tempname + "-" + zipFileName;
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

    if ~isfolder(targetDirectory)
        mkdir(targetDirectory)
    end

    % Get repository folder name
    L = dir(sourceDirectory); L(startsWith({L.name}, '.')) = [];
    assert(isscalar(L), "Expected temporary folder to contain one downloaded item")
    folderName = strtrim( L.name );
    if isfolder( fullfile(targetDirectory, folderName) )
        rmdir(fullfile(targetDirectory, folderName), "s")
    end

    fprintf('Copying repository "%s" to local directory:\n%s... ', repositoryName, targetDirectory)
    copyfile(sourceDirectory, targetDirectory)
    fprintf('Done.\n')

    % Save current commit ID and repository details
    [~, commitDetails] = getCurrentCommitID(repositoryName, ...
        "BranchName", options.BranchName, ...
        "Owner", options.Owner);
    saveCurrentCommitID(commitDetails)
end
