classdef HasEntity < openminds.internal.abstract.LinkedCategory
    properties (Constant, Hidden)
        ALLOWED_TYPES = "openminds.sands.ParcellationEntity"
        IS_SCALAR = false
    end
end
