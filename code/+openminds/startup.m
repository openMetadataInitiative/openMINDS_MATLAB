function startup(version)
% startup - Startup routines for openMINDS_MATLAB
%
%   This function ensures that only one version of openMINDS schema classes
%   are on MATLAB's search path.

    arguments
        version (1,1) openminds.internal.utility.VersionNumber ...
            {openminds.mustBeValidModelVersion(version)} = "latest"
    end

    disp('Initializing openMINDS_MATLAB...')

    % Run internal function that correctly configures the search path
    openminds.selectModelVersion(version)
    fprintf(['Added classes for version "%s" of the openMINDS metadata model ' ...
             'to the search path.\n'], string(version))
end
