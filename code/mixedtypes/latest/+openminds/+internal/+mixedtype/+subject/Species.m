classdef Species < openminds.internal.abstract.LinkedCategory
    properties (Constant, Hidden)
        ALLOWED_TYPES = ["openminds.controlledterms.Species", "openminds.core.Strain"]
        IS_SCALAR = true
    end
end
