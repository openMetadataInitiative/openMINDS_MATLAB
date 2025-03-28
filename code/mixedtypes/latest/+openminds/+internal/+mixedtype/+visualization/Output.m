classdef Output < openminds.internal.abstract.LinkedCategory
    properties (Constant, Hidden)
        ALLOWED_TYPES = [ ...
            "openminds.computation.LocalFile", ...
            "openminds.core.data.File", ...
            "openminds.core.data.FileArchive", ...
            "openminds.core.data.FileBundle" ...
        ]
        IS_SCALAR = false
    end
end