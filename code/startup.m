% Startup file for openMINDS_MATLAB
%
% ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! !!
% !!            If you want to permanently add openMINDS_MATLAB           - - !!
% !!                to the search path, see setup.m instead               - - !!
% ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! !! 
%
% This file provides startup options for the openMINDS MATLAB toolbox. The
% toolbox contains classes for openMINDS Schemas across all different
% versions, and it is therefore important to not add the entire toolbox
% with subfolders to MATLAB's search path. 
%
% Therefore, this script selectively adds its subfolders to the path to
% ensure only one version of openMINDS schemas are added to the search
% path. By default, the latest version is added.
%
% This script is meant for developers who prefer to manage their paths
% through startup files. If you would like to properly add openMINDS_MATLAB to 
% the search path and then "forget" about it, run setup.m instead.
%
% You can add this script to your main startup file like this:
%
%   run( fullfile(<path/to/openMINDS_MATLAB>, 'code', 'startup.m') )
%
% Alternatively, to startup with a specified version which is not the
% latest:
%   addpath( fullfile('<path/to/openMINDS_MATLAB>, 'code') );
%   startup(versionNumber)
%
% See also openminds.startup

function startup(version)
    arguments
        version = "latest"
    end

    codeFolder = fileparts( mfilename('fullpath') );
    addpath(codeFolder)
    addpath(fullfile(codeFolder, 'internal'))

    openminds.startup(version)
end
