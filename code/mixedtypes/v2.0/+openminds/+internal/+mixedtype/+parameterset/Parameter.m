classdef Parameter < openminds.internal.abstract.LinkedCategory
    properties (Constant, Hidden)
        ALLOWED_TYPES = ["openminds.core.NumericalParameter", "openminds.core.StringParameter"]
        IS_SCALAR = false
    end
end
