function versionNum = getSchemaVersion(outputType)
    
    arguments
        % outputType - char or VersionNumber. char is default to keep
        % backwards compatibility. Todo: Deprecate char option
        outputType (1,1) string ...
            {mustBeMember(outputType, ["char", "VersionNumber"])} = "char"
    end

    schemaFolder = fullfile(openminds.internal.rootpath, 'schemas/');
    pathSplit = strsplit(path, pathsep);

    matchedIdx = find(contains(pathSplit, schemaFolder));

    if numel(matchedIdx) > 1
        warning('Multiple schema versions are on path');
    end

    versionNum = strrep(pathSplit{matchedIdx(1)}, schemaFolder, '');

    if outputType == "VersionNumber"
        versionNum = openminds.internal.utility.VersionNumber(versionNum);
        versionNum.Format = "vX.Y";
    end
end
