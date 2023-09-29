classdef Specification < openminds.internal.abstract.LinkedCategory
    properties (Constant, Hidden)
        ALLOWED_TYPES = ["openminds.core.File", "openminds.core.PropertyValueList"]
        IS_SCALAR = true
    end
end
