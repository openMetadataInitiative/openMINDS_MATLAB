function versionStr = getSchemaVersion()

    schemaFolder = fullfile(openminds.internal.rootpath, 'schemas/');
    pathSplit = strsplit(path, pathsep);

    matchedIdx = find(contains(pathSplit, schemaFolder));

    if numel(matchedIdx) > 1
        warning('Multiple schema versions are on path');
    end

    versionStr = strrep(pathSplit{matchedIdx(1)}, schemaFolder, '');
end