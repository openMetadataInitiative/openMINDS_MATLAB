classdef SpatialLocation < openminds.internal.abstract.LinkedCategory
    properties (Constant, Hidden)
        ALLOWED_TYPES = "openminds.sands.CoordinatePoint"
        IS_SCALAR = false
    end
end
