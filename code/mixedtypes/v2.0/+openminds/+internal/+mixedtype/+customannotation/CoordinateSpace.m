classdef CoordinateSpace < openminds.internal.abstract.LinkedCategory
    properties (Constant, Hidden)
        ALLOWED_TYPES = ["openminds.sands.CommonCoordinateSpace", "openminds.sands.CustomCoordinateSpace"]
        IS_SCALAR = true
    end
end
