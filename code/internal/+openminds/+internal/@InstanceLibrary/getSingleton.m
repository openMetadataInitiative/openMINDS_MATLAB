function singletonObject = getSingleton(folderPath, options)
    arguments
        folderPath (1,1) string {mustBeFolder} = ...
            openminds.internal.PathConstants.LocalInstanceFolder;

        options.UseGit (1,1) logical = false
        options.Reset (1,1) logical = false
    end

    import openminds.internal.InstanceLibrary

    SINGLETON_NAME = InstanceLibrary.SINGLETON_NAME;
    singletonObject = getappdata(0, SINGLETON_NAME);
    
    if ~isempty(singletonObject) && isvalid(singletonObject) 
        if ~strcmp(folderPath, singletonObject.InstanceLibraryLocation)
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
