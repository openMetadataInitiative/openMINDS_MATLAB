function singletonObject = getSingleton(options)
    arguments
        options.Reset (1,1) logical = false
    end

    import openminds.internal.meta.MetaTypeRegistry

    SINGLETON_NAME = MetaTypeRegistry.SINGLETON_NAME;
    singletonObject = getappdata(0, SINGLETON_NAME);
    
    currentModelVersion = openminds.version();

    if ~isempty(singletonObject) && isvalid(singletonObject)
        if ~strcmp(currentModelVersion, singletonObject.ModelVersion)
            delete(singletonObject) % Reset singleton
            singletonObject = [];
        elseif options.Reset
            delete(singletonObject) % Reset singleton
            singletonObject = [];
        end
    end

    % Create a new singleton if necessary
    if isempty(singletonObject) || ~isvalid(singletonObject)
        singletonObject = MetaTypeRegistry('ModelVersion', currentModelVersion);
        setappdata(0, SINGLETON_NAME, singletonObject)
    end
end
