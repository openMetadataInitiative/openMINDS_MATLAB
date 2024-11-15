classdef HasParent < openminds.internal.abstract.LinkedCategory
    properties (Constant, Hidden)
        ALLOWED_TYPES = [ ...
            "openminds.sands.atlas.ParcellationEntity", ...
            "openminds.sands.atlas.ParcellationEntityVersion" ...
        ]
        IS_SCALAR = false
    end
end