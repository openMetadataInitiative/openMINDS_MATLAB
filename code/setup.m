function setup(options)

    arguments
        % UpdatePathDef - Add openMINDS_MATLAB to the search path and update 
        % the pathdef file, making sure this toolbox stays on path when 
        % restarting MATLAB
        options.UpdatePathDef (1,1) logical = true
        
        % Version - Specifies which openMINDS version to use
        options.Version (1,1) string = "latest"
    end
    
    % Add the code folder to the search path
    codeFolder = fileparts( mfilename('fullpath') );
    addpath(codeFolder)
    addpath(fullfile(codeFolder, 'internal'))

    % Running startup will properly add openMINDS_MATLAB to the search path
    openminds.startup(options.Version)
    
    % Save the current search path if this is specified
    if options.UpdatePathDef
        savepath()
    end
    
    % Todo: Install dependencies
    
    % Download latest version of the openMINDS controlled instances library
    openminds.internal.setup.downloadControlledInstances()
end
