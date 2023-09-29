classdef PropertyValuePair < openminds.internal.abstract.LinkedCategory
    properties (Constant, Hidden)
        ALLOWED_TYPES = ["openminds.core.NumericalProperty", "openminds.core.StringProperty"]
        IS_SCALAR = false
    end
end
