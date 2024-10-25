function codecheckToolbox()
% codecheckToolbox - Identify code issues for openMINDS_MATLAB toolbox

    installMatBox("commit")
    projectRootDirectory = ommtools.projectdir();
    
    matbox.tasks.codecheckToolbox(projectRootDirectory, ...
        "CreateBadge", true)
end
