function commitID = loadPreviousCommitID()

    openMindsFolderPath = openminds.internal.rootpath();
    filePath = fullfile(openMindsFolderPath, 'schema_prev_commit_id.json');
    
    if isfile(filePath)
        S = jsondecode( fileread(filePath) );
        commitID = S.CommitID;
    else
        commitID = '';
    end
end