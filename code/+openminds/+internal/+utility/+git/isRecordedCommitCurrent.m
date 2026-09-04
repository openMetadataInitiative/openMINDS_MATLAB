function tf = isRecordedCommitCurrent(options)
%isRecordedCommitCurrent True when the recorded commit is still the branch tip

    arguments
        options.RepositoryName = "openMINDS"
        options.BranchName = "main"
        options.Owner = openminds.internal.constants.Github.Organization
    end

    import openminds.internal.utility.git.getCurrentCommitID
    import openminds.internal.utility.git.readRecordedCommitID

    commitID = getCurrentCommitID(options.RepositoryName, ...
        'BranchName', options.BranchName, 'Owner', options.Owner);

    nvPairs = namedargs2cell(options);
    recordedCommitID = readRecordedCommitID(nvPairs{:});

    tf = strcmp(recordedCommitID, commitID);
end
