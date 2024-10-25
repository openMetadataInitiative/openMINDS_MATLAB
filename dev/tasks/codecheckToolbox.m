function codecheckToolbox()
% codecheckToolbox - Identify code issues for openMINDS_MATLAB toolbox

    ommtools.installMatBox("commit")
    projectRootDirectory = ommtools.projectdir();
    
    matbox.tasks.codecheckToolbox(projectRootDirectory, ...
        "CreateBadge", true)
end
