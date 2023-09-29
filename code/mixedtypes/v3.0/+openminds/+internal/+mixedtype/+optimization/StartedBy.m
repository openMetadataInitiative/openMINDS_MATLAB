classdef StartedBy < openminds.internal.abstract.LinkedCategory
    properties (Constant, Hidden)
        ALLOWED_TYPES = ["openminds.computation.SoftwareAgent", "openminds.core.Person"]
        IS_SCALAR = true
    end
end
