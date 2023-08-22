classdef Funder < openminds.internal.abstract.LinkedCategory
    properties (Constant, Hidden)
        ALLOWED_TYPES = ["openminds.core.Organization", "openminds.core.Person"]
        IS_SCALAR = true
    end
end
