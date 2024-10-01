function versionStr = getVersionFromContents(toolboxFolder)
% getVersionFromContents - Get version number from the Contents.m file

    arguments
        toolboxFolder (1,1) string {mustBeFolder(toolboxFolder)}
    end

    % Update Contents.m
    contentsFilePath = fullfile(toolboxFolder, 'Contents.m');
    contentsStr = fileread(contentsFilePath);
    
    % First try to get a version with a sub-patch version number
    versionStr = regexp(contentsStr, '(?<=Version )\d+\.\d+\.\d+.\d+(?= )', 'match', 'once');

    % If not found, get major-minor-patch
    if isempty(versionStr)
        versionStr = regexp(contentsStr, '(?<=Version )\d+\.\d+\.\d+(?= )', 'match', 'once');
    end
    
    if isempty(versionStr)
        error('BUILDTOOLS:Version:VersionNotFound', ...
              'No version was detected in the Contents file for this toolbox.')
    end
end
