classdef Constants < handle

    properties (Constant)
        GithubURL    = "https://github.com/HumanBrainProject/openMINDS"
        ReleaseURL   = openminds.internal.Constants.GithubURL + "/raw/documentation"
        VocabURL     = openminds.internal.Constants.GithubURL + "/raw/main/vocab"
        LogoLightURL = openminds.internal.Constants.GithubURL + "/raw/main/img/light_openMINDS-logo.png";
        LogoDarkURL  = openminds.internal.Constants.GithubURL + "/raw/main/img/dark_openMINDS-logo.png";
        SchemaFolder = fullfile(openminds.internal.rootpath(), 'schemas')
    end

end
