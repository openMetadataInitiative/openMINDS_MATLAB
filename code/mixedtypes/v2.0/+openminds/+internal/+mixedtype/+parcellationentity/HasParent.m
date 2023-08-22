classdef HasParent < openminds.internal.abstract.LinkedCategory
    properties (Constant, Hidden)
        ALLOWED_TYPES = "openminds.sands.ParcellationEntity"
        IS_SCALAR = true
    end
end
