classdef PropertyValuePair < openminds.internal.abstract.MixedTypeSet
    properties (Constant, Hidden)
        ALLOWED_TYPES = [ ...
            "openminds.core.research.NumericalProperty", ...
            "openminds.core.research.StringProperty" ...
        ]
        IS_SCALAR = false
    end
end