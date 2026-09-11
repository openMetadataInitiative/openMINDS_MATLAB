function downloadRepository(repositoryName, options)
% downloadRepository - Download a repository from GitHub
%
%   Input arguments:
%       repositoryName - Name of repository
%
%   Optional parameters:
%       BranchName - Name of branch
%       Owner - Name of repository owner
%       TargetDirectory - Folder the repository folder is placed in
%
%   The commit is recorded only once the repository is in place, so a
%   download that failed is retried on the next call rather than taken
%   for the current commit.

    arguments
        repositoryName = "openMINDS"
        options.BranchName = "main"
        options.Owner = openminds.internal.constants.Github.Organization
        options.TargetDirectory = openminds.internal.utility.git.getRepositoryTargetRootFolder()
    end

    % Todo: Should be a preference.
    targetDirectory = options.TargetDirectory;

    import openminds.internal.extern.fex.filedownload.downloadFile
    import openminds.internal.utility.git.extractRepositoryArchive
    import openminds.internal.utility.git.getCurrentCommitID
    import openminds.internal.utility.git.writeRecordedCommitID
    import openminds.internal.utility.git.isRecordedCommitCurrent

    % Check if we already have the latest commit
    if isRecordedCommitCurrent('RepositoryName', repositoryName, ...
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
    zipCleanup = onCleanup(@() delete(tempZipFilepath));

    fprintf('Downloading repository "%s" from "%s"... ', ...
        repositoryName, options.Owner)
    downloadFile(tempZipFilepath, webURI.EncodedURI, 'ShowFilename', true);
    fprintf('Done.\n')

    fprintf('Extracting repository "%s" into local directory:\n%s... ', ...
        repositoryName, targetDirectory)
    extractRepositoryArchive(tempZipFilepath, targetDirectory);
    fprintf('Done.\n')

    % Save current commit ID and repository details
    [~, commitDetails] = getCurrentCommitID(repositoryName, ...
        "BranchName", options.BranchName, ...
        "Owner", options.Owner);
    writeRecordedCommitID(commitDetails)
end
