classdef Publisher < openminds.internal.abstract.LinkedCategory
    properties (Constant, Hidden)
        ALLOWED_TYPES = ["openminds.core.Consortium", "openminds.core.Organization", "openminds.core.Person"]
        IS_SCALAR = true
    end
end
