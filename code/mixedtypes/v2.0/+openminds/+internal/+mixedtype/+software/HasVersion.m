classdef HasVersion < openminds.internal.abstract.LinkedCategory
    properties (Constant, Hidden)
        ALLOWED_TYPES = "openminds.core.SoftwareVersion"
        IS_SCALAR = false
    end
end
