function repositoryFolder = extractRepositoryArchive(zipFilePath, targetDirectory)
% extractRepositoryArchive - Put the repository in an archive in place of the previous copy
%
%   Syntax:
%       repositoryFolder = extractRepositoryArchive(zipFilePath, targetDirectory)
%
%   Input Arguments:
%       zipFilePath - A GitHub archive: a zip file holding one folder,
%           named after the repository and branch
%       targetDirectory - Folder the repository folder is placed in
%
%   Output Arguments:
%       repositoryFolder - Folder the repository was placed in
%
%   The archive is extracted into a staging folder beside the repository
%   folder and moved into place last, so an extraction that fails part
%   way, from a full disk or an interrupted job, leaves the previous
%   copy where it was instead of a folder that exists but is incomplete.
%   Nothing of the staging folder remains afterwards, whether or not the
%   extraction succeeded.
%
%   See also downloadRepository

    arguments
        zipFilePath (1,1) string {mustBeFile}
        targetDirectory (1,1) string
    end

    if ~isfolder(targetDirectory)
        mkdir(targetDirectory)
    end

    % Beside the repository folder, not under tempdir, so that moving the
    % result into place is a rename on one volume rather than a second
    % copy of every file.
    [~, stagingName] = fileparts(tempname);
    stagingDirectory = fullfile(targetDirectory, stagingName);
    stagingCleanup = onCleanup(@() removeFolder(stagingDirectory));

    unzip(zipFilePath, stagingDirectory)

    L = dir(stagingDirectory);
    L(startsWith({L.name}, '.')) = [];
    if ~isscalar(L) || ~L.isdir
        error('OPENMINDS:Git:UnexpectedArchiveLayout', ...
            ['The archive "%s" was expected to hold one folder, as a ', ...
            'GitHub archive does, but holds %d items.'], zipFilePath, numel(L))
    end
    folderName = string(L.name);
    stagedFolder = fullfile(stagingDirectory, folderName);
    repositoryFolder = fullfile(targetDirectory, folderName);

    % The previous copy goes only now that the new one is complete, and it
    % must be gone before the move: movefile moves a folder into one that
    % exists rather than over it.
    if isfolder(repositoryFolder)
        rmdir(repositoryFolder, "s")
    end

    [isMoved, message] = movefile(stagedFolder, repositoryFolder);
    if ~isMoved
        error('OPENMINDS:Git:MoveFailed', ...
            'The repository folder "%s" could not be moved into "%s": %s', ...
            folderName, targetDirectory, message)
    end
end

function removeFolder(folderPath)
% removeFolder - Remove a folder and its contents if it exists
    if isfolder(folderPath)
        rmdir(folderPath, "s")
    end
end
