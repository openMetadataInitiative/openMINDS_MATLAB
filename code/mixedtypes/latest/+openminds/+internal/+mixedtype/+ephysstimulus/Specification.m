classdef Specification < openminds.internal.abstract.LinkedCategory
    properties (Constant, Hidden)
        ALLOWED_TYPES = ["openminds.core.Configuration", "openminds.core.File", "openminds.core.FileBundle", "openminds.core.PropertyValueList"]
        IS_SCALAR = false
    end
end
