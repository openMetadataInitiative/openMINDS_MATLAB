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

    % NB: Assumes this function is located in code/+openminds:
    codePath = fileparts( fileparts( mfilename('fullpath') ) );
    addpath( fullfile(codePath, 'internal') )

    warnIfStaleControlledTermBase(codePath)

    % Run internal function that correctly configures the search path
    openminds.selectModelVersion(version)
    fprintf(['Added classes for version "%s" of the openMINDS metadata model ' ...
             'to the search path.\n'], string(version))
end

function warnIfStaleControlledTermBase(codePath)
% warnIfStaleControlledTermBase - Warn about a leftover from an older checkout
%
%   Earlier versions copied the controlled term base class of the selected
%   model version to code/internal/+openminds/+base/ControlledTerm.m. That
%   class is now generated per model version, and a file left behind at the
%   old location shadows the generated one for every version.

    staleFile = fullfile(codePath, 'internal', '+openminds', '+base', 'ControlledTerm.m');

    if isfile(staleFile)
        warning('openMINDS:StaleControlledTermBase', ...
            ['A leftover controlled term base class was found at\n  %s\n' ...
             'It is no longer tracked and shadows the class generated for the ' ...
             'selected model version. Delete the file.'], staleFile)
    end
end
