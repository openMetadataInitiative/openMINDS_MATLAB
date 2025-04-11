function versionNum = getModelVersion(outputType)
    
    % Todo: save version number in prefs/singleton?

    arguments
        % outputType - char or VersionNumber. char is default to keep
        % backwards compatibility. Todo: Deprecate char option
        outputType (1,1) string ...
            {mustBeMember(outputType, ["char", "VersionNumber"])} = "char"
    end

    persistent lastTic cachedVersionNumber
    if isempty(lastTic); lastTic = uint64(0); end

    if toc(lastTic) > 1
        typeFolder = fullfile(openminds.internal.rootpath, 'types/');
        pathSplit = strsplit(path, pathsep);
    
        matchedIdx = find(contains(pathSplit, typeFolder));
    
        if numel(matchedIdx) > 1
            warning('Multiple openMINDS model versions are present on the search path.');
        end
    
        versionName = strrep(pathSplit{matchedIdx(1)}, typeFolder, '');
        cachedVersionNumber = openminds.internal.utility.VersionNumber(versionName);
        cachedVersionNumber.Format = "vX.Y";
        lastTic = tic();
    end
    versionNum = cachedVersionNumber;

    if outputType == "char"
        versionNum = char(versionNum);
    end
end
