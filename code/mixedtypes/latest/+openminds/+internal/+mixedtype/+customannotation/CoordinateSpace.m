classdef CoordinateSpace < openminds.internal.abstract.MixedTypeSet
    properties (Constant, Hidden)
        ALLOWED_TYPES = [ ...
            "openminds.sands.atlas.CommonCoordinateSpaceVersion", ...
            "openminds.sands.nonatlas.CustomCoordinateSpace" ...
        ]
        IS_SCALAR = true
    end
end