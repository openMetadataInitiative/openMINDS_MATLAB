function tf = isLatest(options)

    arguments
        options.RepositoryName = "openMINDS"
        options.BranchName = "main"
        options.Owner = openminds.internal.constants.Github.Organization
    end

    import openminds.internal.utility.git.getCurrentCommitID
    import openminds.internal.utility.git.loadPreviousCommitID

    commitID = getCurrentCommitID(options.RepositoryName, ...
        'BranchName', options.BranchName, 'Owner', options.Owner);

    nvPairs = namedargs2cell(options);
    prevCommitID = loadPreviousCommitID(nvPairs{:});

    tf = strcmp(prevCommitID, commitID);
end
