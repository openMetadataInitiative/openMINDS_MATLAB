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
