function newVersion = packageToolbox(releaseType, versionString)
% packageToolbox Package a new version of a toolbox. Package a new version
% of the toolbox based on the toolbox packaging (.prj) file in current
% working directory. MLTBX file is put in ./release directory. 
%
% packageToolbox() Build is automatically incremented.  
%
% packageTookbox(releaseType) RELEASETYPE  can be "major", "minor", or "patch" 
% to update semantic version number appropriately.  Build (fourth element in 
% semantic versioning) is always updated automatically.
%
% packageTookbox('specific', versionString) VERSIONSTRING is a string containing
% the specific 3 part semantic version (i.e. "2.3.4") to use.
%
% Adapted from: https://github.com/mathworks/climatedatastore/blob/main/buildUtilities/packageToolbox.m

% Todo:
%  - Create a matlab script that fills in toolbox options for path 
%  - and requirements

    arguments
        releaseType {mustBeTextScalar,mustBeMember(releaseType,["build","major","minor","patch","specific"])} = "build"
        versionString {mustBeTextScalar} = "";
    end

    includeBuildNumer = strcmp(releaseType, 'build');

    % Get updated version number
    projectRootPath = ommtools.getProjectRootDir();
    previousVersion = utility.getVersionFromContents(fullfile(projectRootPath, 'code'));
    newVersion = utility.updateVersionNumber(previousVersion, releaseType, ...
        versionString, "IncludeBuildNumber", includeBuildNumer);

    % Create/retrieve options for packaging toolbox 
    toolboxOptions = toolbox.createToolboxOptions(newVersion);

    % Update Contents.m header based on toolbox options and new version number
    contentHeader = utility.createContentsHeader(...
        "Name", toolboxOptions.ToolboxName, ...
        "VersionNumber", newVersion, ...
        "MinimumMatlabRelease", toolboxOptions.MinimumMatlabRelease, ...
        "Owner", toolboxOptions.AuthorCompany);

    % Write contents header
    utility.updateContentsHeader(fullfile(projectRootPath, 'code'), contentHeader);
    
    % Package toolbox
    if ~isfolder( fileparts(toolboxOptions.OutputFile) )
        mkdir( fileparts(toolboxOptions.OutputFile) ); 
    end
    matlab.addons.toolbox.packageToolbox(toolboxOptions);
end
