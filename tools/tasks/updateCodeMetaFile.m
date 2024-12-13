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

    codeMetaInfo.version = versionStringNumeric;
    codeMetaInfo.downloadUrl = sprintf("https://github.com/openMetadataInitiative/openMINDS_MATLAB/releases/download/%s/openMINDS_MATLAB_%s.mltbx", ...
        versionString, strrep(versionString, '.', '_'));
    codeMetaInfo.dateModified = string(datetime('today', 'Format', 'yyyy-MM-dd'));

    jsonStr = jsonencode(codeMetaInfo, 'PrettyPrint', true);

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