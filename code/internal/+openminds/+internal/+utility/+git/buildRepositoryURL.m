function url = buildRepositoryURL(owner, repositoryName, branchName)

    arguments
        owner (1,1) string
        repositoryName (1,1) string
        branchName (1,1) string = "main"
    end

    urlStr = sprintf(...
        "https://github.com/%s/%s/archive/refs/heads/%s.zip", ...
        owner, repositoryName, branchName);
    url = matlab.net.URI( urlStr );
end
