function saveCurrentCommitID(commitDetails)
% saveCurrentCommitID - Save commit id for current version of a repository
%
%   Input arguments:
%       commitDetails - a struct with the following fields:
%           CommitID - Commit ID (sha1)
%           RepositoryName - Name of repository
%           BranchName - Name of branch
%           Organization - Name of organization
%

    openMindsFolderPath = fullfile(userpath, 'openMINDS_MATLAB', 'Repositories');
    if ~isfolder(openMindsFolderPath); mkdir(openMindsFolderPath); end
    
    filePath = fullfile(openMindsFolderPath, 'repository_versions.json');
    
    fields = {'RepositoryName', 'BranchName', 'Organization'};
    commitDetails.LastUpdate = string(datetime("now"));

    if isfile(filePath)
        S = jsondecode(fileread(filePath));

        isPresent = arrayfun(@(s) structcmp(s, commitDetails, fields), S.repositories);
        if any(isPresent)
            S.repositories(isPresent) = commitDetails;
        else
            S.repositories(end+1) = commitDetails;
        end

    else
        S = struct();
        S.type = 'github_repository_latest_commit_id';
        S.description = 'A list of commitIDs for downloaded Github repositories';
        S.repositories = commitDetails;
    end

    str = jsonencode(S, 'PrettyPrint', true);
    fid = fopen(filePath, 'w');
    fwrite(fid, str);
    fclose(fid);
end

function tf = structcmp(S1, S2, fields)

    tf = false(1, numel(fields));

    for i = 1:numel(fields)
        tf(i) = isequal(S1.(fields{i}), S2.(fields{i}));
    end
    
    tf = all(tf);
end
