classdef Parameter < openminds.internal.abstract.LinkedCategory
    properties (Constant, Hidden)
        ALLOWED_TYPES = [ ...
            "openminds.core.research.NumericalParameter", ...
            "openminds.core.research.StringParameter" ...
        ]
        IS_SCALAR = false
    end
end