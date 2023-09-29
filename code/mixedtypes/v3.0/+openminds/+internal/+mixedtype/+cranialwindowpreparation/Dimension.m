classdef Dimension < openminds.internal.abstract.LinkedCategory
    properties (Constant, Hidden)
        ALLOWED_TYPES = ["openminds.sands.Circle", "openminds.sands.Ellipse", "openminds.sands.Rectangle"]
        IS_SCALAR = true
    end
end
