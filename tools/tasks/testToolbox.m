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

    warnState = warning('off', 'MATLAB:alias:DuplicateAlias');
    warningCleanup = onCleanup(@() warning(warnState));

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
        dir( fullfile(codeFolder, 'schemas', 'latest', '**', '*.m') ));

    fileList = fullfile(string({L.folder}'),string({L.name}'));
end
