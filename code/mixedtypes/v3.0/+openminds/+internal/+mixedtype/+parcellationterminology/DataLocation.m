classdef DataLocation < openminds.internal.abstract.LinkedCategory
    properties (Constant, Hidden)
        ALLOWED_TYPES = "openminds.core.File"
        IS_SCALAR = false
    end
end
