function contentsStr = createContentsHeader(options)
% createContentsHeader - Create a header for the Contents.m file
%
% Example:
%
% openMINDS Metadata Models
% Version 0.9.2 (R2022b) 29-Sep-2024
%
% Copyright (c) 2024, openMetadataInitiative
% ------------------------------------------

    arguments
        options.Name string
        options.VersionNumber string {mustBeValidVersionNumber}
        options.MinimumMatlabRelease string
        options.MaximumMatlabRelease string
        options.Owner string
    end

    titleLine = sprintf('%% %s', options.Name);
    dateStr = string( datetime("today", 'Format', "dd-MMM-yyyy") );
    yearNum = double(year(datetime('today')));

    if isfield(options, "MinimumMatlabRelease")
        releaseStr = options.MinimumMatlabRelease;
        if isfield(options, "MaximumMatlabRelease")
            releaseStr = sprintf('%s-%s', releaseStr, options.MaximumMatlabRelease);
        else
            releaseStr = sprintf('%s+', releaseStr);
        end
        versionLine = sprintf('%% Version %s (%s) %s', options.VersionNumber, releaseStr, dateStr);
    else
        versionLine = sprintf('%% Version %s %s', options.VersionNumber, dateStr);
    end

    copyRightLine = sprintf('%% Copyright (c) %d, %s', yearNum, options.Owner);
    separatorLine = sprintf('%% %s', repmat('-', numel(copyRightLine)-2, 1));

    contentsStr = strjoin({...
        titleLine, ...
        versionLine, ...
        '%', ... % Blank line
        copyRightLine, ...
        separatorLine}, newline);
end

