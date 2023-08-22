function saveCurrentCommitID(commitID)
    
    if ~nargin
        commitID = openminds.internal.utility.git.getCurrentCommitID('documentation');
    end
    
    openMindsFolderPath = openminds.internal.rootpath();
    filePath = fullfile(openMindsFolderPath, 'schema_prev_commit_id.json');

    S = struct('LastUpdate', datestr(now), 'CommitID', commitID);
    str = jsonencode(S, 'PrettyPrint', true);
    fid = fopen(filePath, 'w');
    fwrite(fid, str);
    fclose(fid);
end
    