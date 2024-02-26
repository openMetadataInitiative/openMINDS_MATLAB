function versionStr = toolboxversion()
% toolboxversion - Get the version identifier for the openMINDS toolbox

    rootPath = openminds.internal.rootpath();
    contentsFile = fullfile(rootPath, 'Contents.m');

    fileStr = fileread(contentsFile);
   
    % First try to get a version with a sub-patch version number
    matchedStr = regexp(fileStr, 'Version \d*\.\d*\.\d*.\d*(?= )', 'match');

    % If not found, get major-minor-patch
    if isempty(matchedStr)
        matchedStr = regexp(fileStr, 'Version \d*\.\d*\.\d*(?= )', 'match');
    end

    if isempty(matchedStr)
        error('openMINDS:Version:VersionNotFound', ...
            'No version was detected for this openminds installation.')
    end
    versionStr = matchedStr{1};
end
