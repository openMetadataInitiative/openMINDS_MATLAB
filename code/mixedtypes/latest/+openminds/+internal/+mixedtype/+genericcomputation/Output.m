classdef Output < openminds.internal.abstract.LinkedCategory
    properties (Constant, Hidden)
        ALLOWED_TYPES = ["openminds.computation.LocalFile", "openminds.core.File", "openminds.core.FileArchive", "openminds.core.FileBundle"]
        IS_SCALAR = false
    end
end
