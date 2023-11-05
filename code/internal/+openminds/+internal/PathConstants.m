classdef PathConstants < handle

    properties (Constant)
        SourceSchemaFolder = fullfile(openminds.internal.rootpath(), 'downloads', 'openminds_source')
        MatlabSchemaFolder = fullfile(openminds.internal.rootpath(), 'schemas')
        LocalInstanceFolder = fullfile(userpath, "openMINDS_MATLAB", "Repositories", "openMINDS_instances-main", "instances")
        UserPath = fullfile(userpath, "openMINDS_MATLAB")
    end

end
