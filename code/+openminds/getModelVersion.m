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
        % The selected version is the one whose generated folders are on the
        % search path. A version contributes several entries, so the version
        % names are reduced to the distinct ones before they are counted.
        generatedFolder = string(openminds.internal.constants.Paths.GeneratedFolder) + filesep;
        pathEntries = string( strsplit(path, pathsep) );

        pathEntries = pathEntries(startsWith(pathEntries, generatedFolder));
        versionNames = extractAfter(pathEntries, strlength(generatedFolder));
        versionNames = unique( extractBefore(versionNames + filesep, filesep) );

        if isempty(versionNames)
            error('openMINDS:NoModelVersionOnPath', ...
                ['No openMINDS model version is on the search path. ', ...
                 'Call openminds.startup to select one.'])
        end

        if numel(versionNames) > 1
            warning('Multiple openMINDS model versions are present on the search path.');
        end

        cachedVersionNumber = openminds.internal.utility.VersionNumber(versionNames(1));
        cachedVersionNumber.Format = "vX.Y";
        lastTic = tic();
    end
    versionNum = cachedVersionNumber;

    if outputType == "char"
        versionNum = char(versionNum);
    end
end
