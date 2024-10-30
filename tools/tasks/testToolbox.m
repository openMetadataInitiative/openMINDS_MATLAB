function testToolbox(varargin)
% testToolbox - Run tests for openMINDS_MATLAB toolbox

    % Prepare
    ommtools.installMatBox("commit")
    projectRootDirectory = ommtools.projectdir();
    % matbox.installRequirements(projectRootDirectory) % No requirements...

    % Use the openMINDS_MATLAB setup to download controlled instances
    run( fullfile(projectRootDirectory, 'code', 'setup.m') )

    matbox.tasks.testToolbox(...
        projectRootDirectory, ...
        "CreateBadge", true, ...
        varargin{:} ...
        )
end
