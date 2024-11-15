classdef DataLocation < openminds.internal.abstract.LinkedCategory
    properties (Constant, Hidden)
        ALLOWED_TYPES = [ ...
            "openminds.core.data.File", ...
            "openminds.core.research.Configuration", ...
            "openminds.core.research.PropertyValueList" ...
        ]
        IS_SCALAR = true
    end
end