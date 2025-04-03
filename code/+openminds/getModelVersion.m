function versionNum = getModelVersion(outputType)
    
    arguments
        % outputType - char or VersionNumber. char is default to keep
        % backwards compatibility. Todo: Deprecate char option
        outputType (1,1) string ...
            {mustBeMember(outputType, ["char", "VersionNumber"])} = "char"
    end

    typeFolder = fullfile(openminds.internal.rootpath, 'types/');
    pathSplit = strsplit(path, pathsep);

    matchedIdx = find(contains(pathSplit, typeFolder));

    if numel(matchedIdx) > 1
        warning('Multiple openMINDS model versions are present on the search path.');
    end

    versionNum = strrep(pathSplit{matchedIdx(1)}, typeFolder, '');

    if outputType == "VersionNumber"
        versionNum = openminds.internal.utility.VersionNumber(versionNum);
        versionNum.Format = "vX.Y";
    end
end
