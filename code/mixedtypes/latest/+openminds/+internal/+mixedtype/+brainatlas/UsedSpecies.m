classdef UsedSpecies < openminds.internal.abstract.LinkedCategory
    properties (Constant, Hidden)
        ALLOWED_TYPES = "openminds.controlledterms.Species"
        IS_SCALAR = true
    end
end
