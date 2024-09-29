function updateVersionInContents(versionNumber, toolboxFolder)
% updateVersionInContents - Update version number in the Contents.m file
%
%   Example:
%       utility.updateVersionInContents('0.9.2', <toolbox_folder>)

    arguments
        versionNumber (1,1) string {mustBeValidVersionNumber(versionNumber)}
        toolboxFolder (1,1) string {mustBeFolder(toolboxFolder)}
    end

    % Update Contents.m
    contentsFilePath = fullfile(toolboxFolder, 'Contents.m');
    str = fileread(contentsFilePath);
    lines = strsplit(str, newline);
    lines{2} = sprintf('%% Version %s %s', versionNumber, datetime("now", "Format", "dd-MMM-uuuu"));
    str = strjoin(lines, newline);
    utility.filewrite(contentsFilePath, str);
end
