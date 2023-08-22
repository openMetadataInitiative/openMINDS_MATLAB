classdef PathConstants < handle

    properties (Constant)
        SourceSchemaFolder = fullfile(openminds.internal.rootpath(), 'downloads', 'openminds_source')
        MatlabSchemaFolder = fullfile(openminds.internal.rootpath(), 'schemas')
    end

end
