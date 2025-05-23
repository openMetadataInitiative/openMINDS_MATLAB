classdef InRelationTo < openminds.internal.abstract.MixedTypeSet
    properties (Constant, Hidden)
        ALLOWED_TYPES = [ ...
            "openminds.sands.atlas.ParcellationEntity", ...
            "openminds.sands.atlas.ParcellationEntityVersion", ...
            "openminds.sands.nonatlas.CustomAnatomicalEntity" ...
        ]
        IS_SCALAR = true
    end
end