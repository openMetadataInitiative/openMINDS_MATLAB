function codespellToolbox()
    
    ommtools.installMatBox("commit")
    projectRootDirectory = ommtools.projectdir();
    codeDirectory = fullfile(projectRootDirectory, "code");

    matbox.tasks.codespellToolbox(codeDirectory, ...
        "RequireCodespellPassing", true, ...
        "Skip", "./types/**", ...
        "IgnoreFilePath", fullfile(projectRootDirectory, 'tools', '.codespell_ignore'))
end
