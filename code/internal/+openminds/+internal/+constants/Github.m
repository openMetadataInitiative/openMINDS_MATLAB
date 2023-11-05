classdef Github < handle

    properties (Constant)
        BaseURL = "https://github.com"
        RawContentUrl = "https://raw.githubusercontent.com"
        Organization = "openMetadataInitiative"
        Instances = "openMINDS_instances"
        Schemas = "openMINDS"
    end

    methods (Static)
        
        function url = getRepositoryUrl(repoName)
            import openminds.internal.utility.string.uriJoin
            import openminds.internal.constants.Github

            switch repoName
                case {'openMINDS_instances', 'instances'}
                    url = uriJoin(Github.BaseURL, Github.Instances);
            end
        end

        function url = getRawFileUrl(repoName, pathString)
            import openminds.internal.utility.string.uriJoin
            import openminds.internal.constants.Github

            switch repoName
                case {'openMINDS_instances', 'instances'}
                    baseUrl = uriJoin(Github.RawContentUrl, Github.Organization, Github.Instances);
            end

            url = uriJoin(baseUrl, pathString);
        end
    end
end