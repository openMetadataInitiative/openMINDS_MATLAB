classdef HasPart < openminds.internal.abstract.LinkedCategory
    properties (Constant, Hidden)
        ALLOWED_TYPES = [ ...
            "openminds.core.products.ModelVersion", ...
            "openminds.core.products.SoftwareVersion", ...
            "openminds.sands.atlas.BrainAtlasVersion", ...
            "openminds.sands.atlas.CommonCoordinateSpaceVersion" ...
        ]
        IS_SCALAR = false
    end
end