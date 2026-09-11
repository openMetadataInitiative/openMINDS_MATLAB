function singletonObject = getSingleton(folderPath, options)
    arguments
        folderPath (1,1) string {mustBeFolder} = ...
            openminds.internal.constants.Paths.LocalInstanceFolder;

        options.UseGit (1,1) logical = false
        options.Reset (1,1) logical = false
    end

    import openminds.internal.InstanceLibrary

    % InstanceLibraryLocation is stored as an absolute path, so the
    % requested path is made absolute before the two are compared.
    folderPath = openminds.internal.utility.resolveAbsolutePath(folderPath);

    SINGLETON_NAME = InstanceLibrary.SINGLETON_NAME;
    singletonObject = getappdata(0, SINGLETON_NAME);

    currentModelVersion = openminds.version();

    if ~isempty(singletonObject) && isvalid(singletonObject)
        if ~strcmp(folderPath, singletonObject.InstanceLibraryLocation)
            delete(singletonObject) % Reset singleton
            singletonObject = [];
        elseif ~strcmp(currentModelVersion, singletonObject.ModelVersion)
            % The table was typed against another model version, so it is
            % stale.
            delete(singletonObject) % Reset singleton
            singletonObject = [];
        elseif options.Reset
            delete(singletonObject) % Reset singleton
            singletonObject = [];
        end
    end

    % Create a new singleton if necessary
    if isempty(singletonObject) || ~isvalid(singletonObject)
        options = rmfield(options, 'Reset');
        nvPairs = namedargs2cell(options);
        singletonObject = InstanceLibrary(folderPath, nvPairs{:});
        setappdata(0, SINGLETON_NAME, singletonObject)
    end
end
