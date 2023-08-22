function commitID = getCurrentCommitID(branchName, repositoryName)
%getCurrentCommitID Get current commit id for a branch of the openminds repo
%
%   commitID = getCurrentCommitID(branchName) returns the commitID for the 
%   specified branch as a character vector

    arguments
        branchName = "documentation"
        repositoryName = "openMINDS"
    end

    API_BASE_URL = sprintf("https://api.github.com/repos/HumanBrainProject/%s", repositoryName);
    
    apiURL = strjoin( [API_BASE_URL, "commits", branchName], '/');

    % Get info about latest commit:
    %data = webread(apiURL);
    %commitID = data.sha;

    % More specific api call to only get the sha-1 hash:
    requestOpts = weboptions();
    requestOpts.HeaderFields = {'Accept', 'application/vnd.github.sha'};

    data = webread(apiURL, requestOpts);
    commitID = char(data');

%     commitDetails = struct();
%     commitDetails.repositoryName = repositoryName;
%     commitDetails.branchName = branchName;
%     commitDetails.commitID = commitID;
end