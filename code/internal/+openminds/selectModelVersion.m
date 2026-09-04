function selectModelVersion(versionNumber)
% selectModelVersion - Select and "import" a specific version of the openMINDS model.
%
% This function allows you to select a specific version of the openMINDS
% metadata model and load its components (classes for metadata types and mixed
% types) into the MATLAB environment. The selected version can be specified as
% a version number or as "latest" to load the most recent version available.
%
% Usage:
%   selectModelVersion(version)
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
%   selectModelVersion();
%
%   % Load a specific version (e.g., v1.0) of openMINDS metadata model
%   selectModelVersion(1);
%
%   % Load the latest version using version number
%   selectModelVersion("latest");
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
            {openminds.mustBeValidModelVersion(versionNumber)} = "latest"
    end

    rootPath = openminds.internal.rootpath();
    
    addpath(rootPath)
    addpath( genpath( fullfile(rootPath, 'internal') ) )
    addpath( genpath( fullfile(rootPath, 'livescripts') ) )

    openminds.internal.installControlledTermBase(versionNumber);

    % Get version number as string matching version numbers of version folders
    if versionNumber == "latest"
        versionAsString = 'latest';
    else
        versionAsString = string(versionNumber);
    end

    generatedFolder = openminds.internal.constants.Paths.GeneratedFolder;

    % Remove every model version from the path. Classes of different versions
    % share names, so two versions on the path would shadow one another.
    warning('off', 'MATLAB:rmpath:DirNotFound')
    for versionFolder = listModelVersionFolders(generatedFolder)
        rmpath(genpath( versionFolder ))
    end
    warning('on', 'MATLAB:rmpath:DirNotFound')

    % Add the selected version. One folder holds its types, mixedtypes,
    % enumerations and the controlled term base class generated for it.
    addpath(genpath( fullfile(generatedFolder, versionAsString) ))

    % Version selection can replace shared abstract class files.
    % Clear cached class definitions so MATLAB sees the active files.
    clear classes;

    % Add a second pause for changes to take effect.
    pause(1) % Ad hoc value. Usually at least 0.3 - 0.4 seconds is necessary
end

function versionFolders = listModelVersionFolders(generatedFolder)
% listModelVersionFolders - Full path of every model version folder present
    folderInfo = dir(generatedFolder);
    folderInfo = folderInfo([folderInfo.isdir]);
    folderNames = string({folderInfo.name});
    folderNames = folderNames(~startsWith(folderNames, "."));
    versionFolders = fullfile(generatedFolder, folderNames);
end
