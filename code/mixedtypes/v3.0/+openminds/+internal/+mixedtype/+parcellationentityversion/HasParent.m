classdef HasParent < openminds.internal.abstract.LinkedCategory
    properties (Constant, Hidden)
        ALLOWED_TYPES = ["openminds.sands.ParcellationEntity", "openminds.sands.ParcellationEntityVersion"]
        IS_SCALAR = false
    end
end
