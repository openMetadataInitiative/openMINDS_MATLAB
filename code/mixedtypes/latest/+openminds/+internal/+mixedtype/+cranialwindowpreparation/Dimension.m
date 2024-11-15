classdef Dimension < openminds.internal.abstract.LinkedCategory
    properties (Constant, Hidden)
        ALLOWED_TYPES = [ ...
            "openminds.sands.mathematicalshapes.Circle", ...
            "openminds.sands.mathematicalshapes.Ellipse", ...
            "openminds.sands.mathematicalshapes.Rectangle" ...
        ]
        IS_SCALAR = true
    end
end