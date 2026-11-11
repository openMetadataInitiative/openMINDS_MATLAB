function issues = codecheckToolbox(options)
% codecheckToolbox - Identify code issues for openMINDS_MATLAB toolbox
%
%   issues = codecheckToolbox() checks every .m file in the repository and
%   throws an error if an issue of severity warning or error remains.
%
%   issues = codecheckToolbox(FoldersToCheck=folders) checks only the .m
%   files in the given folders, which are relative to the repository root.
%   The ehennestad/matbox-actions check-code action passes this argument.
%
%   The ignoredFiles setting in code/resources/codeAnalyzerConfiguration.json
%   lists files that Code Analyzer skips (MATLAB R2026b or later).

    arguments
        options.FoldersToCheck (1,:) string = string.empty
    end

    ommtools.installMatBox("commit")
    projectRootDirectory = ommtools.projectdir();

    if isempty(options.FoldersToCheck)
        foldersToCheck = string.empty;
    else
        foldersToCheck = fullfile(projectRootDirectory, options.FoldersToCheck);
    end

    % ShowIssues prints the table of remaining issues, so a failed CI run
    % shows which files to fix. The status of the Analyse code workflow is
    % the README badge, so no badge file is created.
    issues = matbox.tasks.codecheckToolbox(projectRootDirectory, ...
        FoldersToCheck=foldersToCheck, ...
        CreateBadge=false, ...
        RequireIssuesResolved=true, ...
        ShowIssues=true);
end
