classdef HasAnnotation < openminds.internal.abstract.LinkedCategory
    properties (Constant, Hidden)
        ALLOWED_TYPES = "openminds.sands.AtlasAnnotation"
        IS_SCALAR = false
    end
end
