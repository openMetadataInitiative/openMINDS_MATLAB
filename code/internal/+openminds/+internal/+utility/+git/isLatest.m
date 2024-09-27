function tf = isLatest(options)

    arguments
        options.RepositoryName = "openMINDS"
        options.BranchName = "main"
        options.Organization = "openMetadataInitiative"
    end

    import openminds.internal.utility.git.getCurrentCommitID
    import openminds.internal.utility.git.loadPreviousCommitID

    commitID = getCurrentCommitID(options.RepositoryName, ...
        'BranchName', options.BranchName, 'Organization', options.Organization);

    nvPairs = namedargs2cell(options);
    prevCommitID = loadPreviousCommitID(nvPairs{:});

    tf = strcmp(prevCommitID, commitID);
end
