function toolboxOptions = createToolboxOptions(versionNumber)
% Script for setting up toolbox (mltbx) options for openMINDS_MATLAB
%
%   Example:
%       toolboxOptions = getToolboxOptions('0.9.2')

    arguments
        versionNumber (1,1) string {mustBeValidVersionNumber(versionNumber)}
    end

    MLTBX_NAME = "openMINDS_MATLAB";
    
    % Read the toolbox info from MLToolboxInfo.json
    [toolboxInfo, identifier] = toolbox.readToolboxInfo;
    
    % Initialize the ToolboxOptions from the code folder and initial metadata
    projectRootDir = ommtools.getProjectRootDir();
    toolboxFolder = fullfile(projectRootDir, "code");
    opts = matlab.addons.toolbox.ToolboxOptions(toolboxFolder, identifier, toolboxInfo);
    
    % Set the toolbox version
    opts.ToolboxVersion = versionNumber;

    % Ignore some file
    toIgnore = contains(opts.ToolboxFiles, '_dev');
    opts.ToolboxFiles = opts.ToolboxFiles(~toIgnore);

    opts.ToolboxImageFile = fullfile(projectRootDir, "img", "light_openMINDS-MATLAB-logo_toolbox.png");
    opts.ToolboxGettingStartedGuide = fullfile(projectRootDir, "code", "gettingStarted.mlx");

    % Specify toolbox path TODO: empty folders
    toolboxPathFolders = [...
        fullfile(projectRootDir, "code"), ...
        fullfile(projectRootDir, "code", "internal"), ...
        fullfile(projectRootDir, "code", "internal", "property_validation"), ...
        fullfile(projectRootDir, "code", "livescripts"), ...
        fullfile(projectRootDir, "code", "schemas", "latest"), ...
        fullfile(projectRootDir, "code", "mixedtypes", "latest"), ...
        fullfile(projectRootDir, "code", "enumerations", "latest") ...
    ];
    opts.ToolboxMatlabPath = toolboxPathFolders;
    
    opts.SupportedPlatforms.Win64 = true;
    opts.SupportedPlatforms.Maci64 = true;
    opts.SupportedPlatforms.Glnxa64 = true;
    opts.SupportedPlatforms.MatlabOnline = true;
    
    % Todo: populate required addons from requirements file

    % Specify name for output .mltbx file.
    versionNumber = strrep(opts.ToolboxVersion, '.', '_');
    outputFileName = sprintf('%s_v%s.mltbx', MLTBX_NAME, versionNumber);
    opts.OutputFile = fullfile(projectRootDir, "releases", outputFileName);

    toolboxOptions = opts;
end
