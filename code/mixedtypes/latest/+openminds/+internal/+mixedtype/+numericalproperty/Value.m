classdef Value < openminds.internal.abstract.LinkedCategory
    properties (Constant, Hidden)
        ALLOWED_TYPES = ["openminds.core.QuantitativeValue", "openminds.core.QuantitativeValueRange"]
        IS_SCALAR = false
    end
end
