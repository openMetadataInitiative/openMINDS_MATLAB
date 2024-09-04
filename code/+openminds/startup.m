function startup(version)
% startup - Startup routines for openMINDS_MATLAB
%
%   This function ensures that only one version of openMINDS schema classes
%   are on MATLAB's search path.
    
    arguments
        version (1,1) string = "latest"
    end

    disp('Initializing openMINDS_MATLAB...')

    % NB: Assumes this function is located in code/+openminds:
    codePath = fileparts( fileparts( mfilename('fullpath') ) );
    addpath( fullfile(codePath, 'internal') )
    
    % Run internal function that correctly configures the search path
    openminds.selectOpenMindsVersion(version)
    disp('Added schemas from the "latest" version to path')
end