classdef PathConstants < handle

    properties (Constant)
        SourceSchemaFolder = fullfile(userpath, "openMINDS_MATLAB", "Repositories", "openMINDS-main", "schemas")
        LocalInstanceFolder = fullfile(userpath, "openMINDS_MATLAB", "Repositories", "openMINDS_instances-main", "instances")
        MatlabSchemaFolder = fullfile(openminds.internal.rootpath(), 'types')
        UserPath = fullfile(userpath, "openMINDS_MATLAB")
    end
end
