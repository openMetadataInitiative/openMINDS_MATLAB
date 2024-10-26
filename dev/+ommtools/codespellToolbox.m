function codespellToolbox()
    
    ommtools.installMatBox("commit")
    projectRootDirectory = ommtools.projectdir();
    codeDirectory = fullfile(projectRootDirectory, "code");

    matbox.tasks.codespellToolbox(codeDirectory, ...
        "RequireCodespellPassing", true, ...
        "Skip", "./schemas/**", ...
        "IgnoreFilePath", fullfile(projectRootDirectory, 'dev', '.codespell_ignore'))
end
