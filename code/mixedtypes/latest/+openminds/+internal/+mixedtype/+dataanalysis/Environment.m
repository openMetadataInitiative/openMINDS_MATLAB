classdef Environment < openminds.internal.abstract.LinkedCategory
    properties (Constant, Hidden)
        ALLOWED_TYPES = ["openminds.computation.Environment", "openminds.core.WebServiceVersion"]
        IS_SCALAR = true
    end
end
