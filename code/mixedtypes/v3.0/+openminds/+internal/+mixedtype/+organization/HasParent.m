classdef HasParent < openminds.internal.abstract.LinkedCategory
    properties (Constant, Hidden)
        ALLOWED_TYPES = "openminds.core.Organization"
        IS_SCALAR = false
    end
end
