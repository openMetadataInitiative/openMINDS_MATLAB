classdef ContactResistance < openminds.internal.abstract.LinkedCategory
    properties (Constant, Hidden)
        ALLOWED_TYPES = [ ...
            "openminds.core.miscellaneous.QuantitativeValue", ...
            "openminds.core.miscellaneous.QuantitativeValueRange" ...
        ]
        IS_SCALAR = true
    end
end