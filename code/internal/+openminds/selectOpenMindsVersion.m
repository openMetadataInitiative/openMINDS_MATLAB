function selectOpenMindsVersion(versionNumber)
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
        versionNumber (1,1) openminds.internal.utility.VersionNumber ...
            {openminds.mustBeValidVersion(versionNumber)} = "latest"
    end

    rootPath = openminds.internal.rootpath();
    
    addpath(rootPath)
    addpath( genpath( fullfile(rootPath, 'internal') ) )
    addpath( genpath( fullfile(rootPath, 'livescripts') ) )

    % Get version number as string matching version numbers of version folders
    if versionNumber == "latest"
        versionAsString = 'latest';
    else
        versionAsString = string(versionNumber);
    end

    % Remove the schema/mixedtypes subdirectory for all versions
    warning('off', 'MATLAB:rmpath:DirNotFound')
    rmpath(genpath( fullfile(rootPath, "schemas") ))
    rmpath(genpath( fullfile(rootPath, "mixedtypes") ))
    rmpath(genpath( fullfile(rootPath, "enumerations") ))
    warning('on', 'MATLAB:rmpath:DirNotFound')

    % Add the schema/mixedtypes subdirectory for the selected version
    addpath(genpath( fullfile(rootPath, "schemas", versionAsString) ))
    addpath(genpath( fullfile(rootPath, "mixedtypes", versionAsString) ))
    addpath(genpath( fullfile(rootPath, "enumerations", versionAsString) ))
end
