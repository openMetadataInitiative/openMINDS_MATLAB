function codeMetaInfo = updateCodeMetaFile(versionString)
    
    arguments
        versionString (1,1) string {mustBeTextScalar, mustBeValidVersionString}
    end

    if startsWith(versionString, "v")
        versionStringNumeric = extractAfter(versionString, 1);
    else
        error('Expected versionString to start with "v"')
    end

    projectRootDirectory = ommtools.projectdir();
    
    codeMetaFilePath = fullfile(projectRootDirectory, 'codemeta.json');
    codeMetaInfo = jsondecode( fileread(codeMetaFilePath) );

    % The toolbox packaging file is the source of truth for the supported
    % MATLAB releases, so read it from there instead of keeping a copy here.
    toolboxInfoFilePath = fullfile(projectRootDirectory, 'tools', 'MLToolboxInfo.json');
    toolboxInfo = jsondecode( fileread(toolboxInfoFilePath) );
    assert(isempty(toolboxInfo.ToolboxOptions.MaximumMatlabRelease), ...
        'runtimePlatform assumes no maximum MATLAB release. Update this task if one is set.')
    minimumMatlabRelease = string(toolboxInfo.ToolboxOptions.MinimumMatlabRelease);

    % This task runs on the day a version is released, so both dates are today.
    releaseDate = string(datetime('today', 'Format', 'yyyy-MM-dd'));

    codeMetaInfo.version = versionStringNumeric;
    codeMetaInfo.downloadUrl = sprintf("https://github.com/openMetadataInitiative/openMINDS_MATLAB/releases/download/%s/openMINDS_MATLAB_%s.mltbx", ...
        versionString, strrep(versionString, '.', '_'));
    % GitHub anchors each release section on the releases page by its tag,
    % so the release notes link can point at this version's notes directly.
    releasesPageUrl = "https://github.com/openMetadataInitiative/openMINDS_MATLAB/releases";
    codeMetaInfo.releaseNotes = releasesPageUrl + "#release-" + versionString;
    codeMetaInfo.runtimePlatform = "MATLAB " + minimumMatlabRelease + " or later";
    codeMetaInfo.datePublished = releaseDate;
    codeMetaInfo.dateModified = releaseDate;

    if isscalar(codeMetaInfo.author)
        % Ensure author is encoded as an array
        codeMetaInfo.author = {codeMetaInfo.author};
    end

    jsonStr = jsonencode(codeMetaInfo, 'PrettyPrint', true);

    % Add EOF newline
    jsonStr = [jsonStr, newline];

    % Fix json-ld @props
    jsonStr = strrep(jsonStr, 'x_context', '@context');
    jsonStr = strrep(jsonStr, 'x_type', '@type');
    jsonStr = strrep(jsonStr, 'x_id', '@id');

    fid = fopen(codeMetaFilePath, 'wt');
    fwrite(fid, jsonStr);
    fclose(fid);
end

function mustBeValidVersionString(versionString)
    pattern = 'v\d+\.\d+\.\d+';
    assert( ~ismissing( regexp(versionString, pattern, 'match', 'once')), 'Invalid version string. Must be formatted as v<major>.<minor>.<patch>' )
end
