classdef Paths < handle
%Paths Folders the toolbox reads from and writes to

    properties (Constant)
        % Downloaded openMINDS schema files, the generator's input
        SourceSchemaFolder = fullfile(userpath, "openMINDS_MATLAB", "Repositories", "openMINDS-main", "schemas")

        % Downloaded openMINDS instance library
        LocalInstanceFolder = fullfile(userpath, "openMINDS_MATLAB", "Repositories", "openMINDS_instances-main", "instances")

        % Everything written by the openMINDS pipeline, one subfolder per
        % model version. Named "resources" so that genpath skips it and no
        % addpath can put two model versions on the path at once.
        GeneratedFolder = fullfile(openminds.internal.rootpath(), 'generated', 'resources')

        % Root of everything this toolbox stores under the user path
        UserPath = fullfile(userpath, "openMINDS_MATLAB")
    end
end
