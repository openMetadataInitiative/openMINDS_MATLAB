function testToolbox(varargin)
% testToolbox - Run tests for openMINDS_MATLAB toolbox

    % Prepare
    ommtools.installMatBox("commit")
    projectRootDirectory = ommtools.projectdir();
    % matbox.installRequirements(projectRootDirectory) % No requirements...

    % Use the openMINDS_MATLAB setup to download controlled instances
    run( fullfile(projectRootDirectory, 'code', 'setup.m') )

    codeFolder = fullfile(projectRootDirectory, "code");
    codecoverageFileList = getCodeCoverageFileList(codeFolder); % local function

    warnStateA = warning('off', 'MATLAB:alias:DuplicateAlias');
    warnStateB = warning('off', 'MATLAB:alias:MissingNewClass');
    warningCleanup = onCleanup(@() warning([warnStateA, warnStateB]));

    if strcmp(getenv('GITHUB_ACTIONS'), 'true')
        verbosity = "Terse";
    else
        verbosity = "Concise";
    end

    matbox.tasks.testToolbox(...
        projectRootDirectory, ...
        "CreateBadge", true, ...
        "CoverageFileList", codecoverageFileList, ...
        "Verbosity", verbosity, ...
        varargin{:} ...
        )
end

function fileList = getCodeCoverageFileList(codeFolder)
    L = cat(1, ...
        dir( fullfile(codeFolder, '+openminds', '**', '*.m') ), ...
        dir( fullfile(codeFolder, 'internal', '**', '*.m') ), ...
        dir( fullfile(codeFolder, 'types', 'latest', '**', '*.m') ));

    fileList = fullfile(string({L.folder}'),string({L.name}'));
    relativePaths = replace(fileList, codeFolder + filesep, '');

    coverageIgnoreFile = fullfile(ommtools.projectdir(), 'tools', '.coverageignore');
    ignorePatterns = string(splitlines( fileread(coverageIgnoreFile) ));
    ignorePatterns(ignorePatterns=="") = [];

    keep = ~startsWith(relativePaths, ignorePatterns);
    fileList = fileList(keep);
end
