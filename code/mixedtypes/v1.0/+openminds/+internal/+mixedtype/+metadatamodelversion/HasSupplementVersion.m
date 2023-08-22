classdef HasSupplementVersion < openminds.internal.abstract.LinkedCategory
    properties (Constant, Hidden)
        ALLOWED_TYPES = "openminds.core.DatasetVersion"
        IS_SCALAR = false
    end
end
