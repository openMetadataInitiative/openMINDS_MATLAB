function selectOpenMindsVersion(version)
% selectOpenMindsVersion - Select and "import" a specific version of openMINDS library.
%
% This function allows you to select a specific version of the openMINDS
% library and load its components (schemas and mixed types) into the MATLAB
% environment. The selected version can be specified as a version number or
% as "latest" to load the most recent version available.
%
% Usage:
%   selectOpenMindsVersion(version)
%
% Arguments:
%   - version (optional) : string (default: "latest")
%     The version of the openMINDS library to select and load. Use a specific
%     version number like 1 or use "latest" to load the latest available version.
%
% Notes:
%   - The openMINDS library must be imported before using this function.
%   - This function modifies the MATLAB path to include the selected version's
%     schemas and mixedtypes subdirectories while removing the others.
%
% Example:
%   % Load the latest version of openMINDS library
%   selectOpenMindsVersion();
%
%   % Load a specific version (e.g., v1.0) of openMINDS library
%   selectOpenMindsVersion(1);
%
%   % Load the latest version using version number
%   selectOpenMindsVersion("latest");
%
% See also: addpath, rmpath


% Author: Eivind Hennestad
% Created: 2023-08-08
% Last Modified: 2023-08-08
%
% Copyright 2023 Open Metadata Initiative
% Licensed under MIT License

    arguments
        version (1,1) string = "latest"
    end

    rootPath = fileparts( mfilename('fullpath') );

    addpath(rootPath)
    addpath( genpath( fullfile(rootPath, 'internal') ) )
    
    import openminds.internal.constants.*

    % - Validate inputs
    version = openminds.internal.validateVersionNumber(version);
    
    if str2double(version) == Models.getLatestVersionNumber()
        version = "latest";
    end

    if version == "latest"
        versionAsString = version;
    else
        versionNumber = str2double(version);
        versionAsString = sprintf('v%.1f', versionNumber);
    end

    % Remove the schema/mixedtypes subdirectory for all versions
    warning('off', 'MATLAB:rmpath:DirNotFound')
    rmpath(genpath( fullfile(rootPath, "schemas") ))
    rmpath(genpath( fullfile(rootPath, "mixedtypes") ))
    warning('on', 'MATLAB:rmpath:DirNotFound')
    
    % Add the schema/mixedtypes subdirectory for the selected version
    addpath(genpath( fullfile(rootPath, "schemas", versionAsString) ))
    addpath(genpath( fullfile(rootPath, "mixedtypes", versionAsString) ))
end
