classdef PerformedBy < openminds.internal.abstract.LinkedCategory
    properties (Constant, Hidden)
        ALLOWED_TYPES = ["openminds.computation.SoftwareAgent", "openminds.core.Person"]
        IS_SCALAR = false
    end
end
