function singletonObject = getSingleton(folderPath, options)
    arguments
        folderPath (1,1) string = ...
            openminds.internal.constants.Paths.LocalInstanceFolder;

        options.UseGit (1,1) logical = false
        options.Reset (1,1) logical = false
    end

    import openminds.internal.InstanceLibrary

    % InstanceLibraryLocation is stored as an absolute path, so the
    % requested path is made absolute before the two are compared.
    folderPath = openminds.internal.utility.resolveAbsolutePath(folderPath);

    % The default location need not exist yet: the library is downloaded
    % into it when it is constructed. A location a caller names has to
    % exist already, because nothing is downloaded anywhere else. It is
    % checked before the library in use is touched, so that a location
    % that names nothing leaves a working library alone.
    defaultLocation = InstanceLibrary.resolveAbsolutePath( ...
        openminds.internal.constants.Paths.LocalInstanceFolder);

    if ~isfolder(folderPath) && folderPath ~= defaultLocation
        error("OPENMINDS:InstanceLibrary:LocationNotFound", ...
            ['The folder "%s" does not exist. The instance library is only ', ...
            'downloaded into its default location, "%s". Another location ', ...
            'has to hold a copy of the library already.'], ...
            folderPath, defaultLocation)
    end

    SINGLETON_NAME = InstanceLibrary.SINGLETON_NAME;
    singletonObject = getappdata(0, SINGLETON_NAME);

    currentModelVersion = openminds.version();

    if ~isempty(singletonObject) && isvalid(singletonObject)
        % Replaced when another location is asked for, when the table was
        % typed against another model version, or when asked to.
        isStale = ~strcmp(folderPath, singletonObject.InstanceLibraryLocation) ...
            || ~strcmp(currentModelVersion, singletonObject.ModelVersion) ...
            || options.Reset;

        if isStale
            delete(singletonObject)
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
