function commitID = loadPreviousCommitID(options)

    arguments
        options.RepositoryName = "openMINDS"
        options.BranchName = "main"
        options.Organization = "openMetadataInitiative"
    end

    openMindsFolderPath = fullfile(userpath, 'openMINDS_MATLAB', 'Repositories');
    filePath = fullfile(openMindsFolderPath, 'repository_versions.json');
    
    if isfile(filePath)
        S = jsondecode( fileread(filePath) );

        fields = {'repositoryName', 'branchName', 'organization'};
        isPresent = arrayfun(@(s) structcmp(s, options, fields), S.repositories);
        if any(isPresent)
            commitID = S.repositories(isPresent).commitID;
        else
            commitID = '';
        end
    else
        commitID = '';
    end
end

function tf = structcmp(S1, S2, fields)

    tf = false(1, numel(fields));

    for i = 1:numel(fields)
        tf(i) = isequal(S1.(fields{i}), S2.(fields{i}));
    end
    
    tf = all(tf);
end
