classdef Input < openminds.internal.abstract.LinkedCategory
    properties (Constant, Hidden)
        ALLOWED_TYPES = ["openminds.computation.LocalFile", "openminds.core.File", "openminds.core.FileBundle", "openminds.core.SoftwareVersion"]
        IS_SCALAR = false
    end
end
