function selectOpenMindsVersion(versionNumber)
% selectOpenMindsVersion - Select and "import" a specific version of the openMINDS model.
%
% This function allows you to select a specific version of the openMINDS
% metadata model and load its components (classes for metadata types and mixed 
% types) into the MATLAB environment. The selected version can be specified as 
% a version number or as "latest" to load the most recent version available.
%
% Usage:
%   selectOpenMindsVersion(version)
%
% Arguments:
%   - version (optional) : string (default: "latest")
%     The version of the openMINDS metadata model to select and load. Use a 
%     specific version number like 1 or use "latest" to load the latest 
%     available version.
%
% Notes:
%   - The openMINDS package must be on the search path before using this function.
%   - This function modifies the MATLAB search path to include the selected 
%     version's types and mixedtypes subdirectories while removing the others.
%
% Example:
%   % Load the latest version of openMINDS metadata model
%   selectOpenMindsVersion();
%
%   % Load a specific version (e.g., v1.0) of openMINDS metadata model
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

    % Remove the types/mixedtypes subdirectory for all versions
    warning('off', 'MATLAB:rmpath:DirNotFound')
    rmpath(genpath( fullfile(rootPath, "types") ))
    rmpath(genpath( fullfile(rootPath, "mixedtypes") ))
    rmpath(genpath( fullfile(rootPath, "enumerations") ))
    warning('on', 'MATLAB:rmpath:DirNotFound')

    % Add the types/mixedtypes subdirectory for the selected version
    addpath(genpath( fullfile(rootPath, "types", versionAsString) ))
    addpath(genpath( fullfile(rootPath, "mixedtypes", versionAsString) ))
    addpath(genpath( fullfile(rootPath, "enumerations", versionAsString) ))
end
