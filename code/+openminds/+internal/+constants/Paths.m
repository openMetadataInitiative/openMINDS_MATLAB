classdef Paths < handle
%Paths Folders the toolbox reads from and writes to

    properties (Constant)
        % Downloaded openMINDS schema files, the generator's input
        SourceSchemaFolder = fullfile(userpath, "openMINDS_MATLAB", "Repositories", "openMINDS-main", "schemas")

        % Downloaded openMINDS instance library
        LocalInstanceFolder = fullfile(userpath, "openMINDS_MATLAB", "Repositories", "openMINDS_instances-main", "instances")

        % Generated type classes, one subfolder per model version
        TypesFolder = fullfile(openminds.toolboxdir(), 'types')

        % Root of everything this toolbox stores under the user path
        UserPath = fullfile(userpath, "openMINDS_MATLAB")
    end
end
