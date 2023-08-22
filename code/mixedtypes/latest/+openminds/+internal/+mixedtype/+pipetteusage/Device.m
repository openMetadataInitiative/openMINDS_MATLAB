classdef Device < openminds.internal.abstract.LinkedCategory
    properties (Constant, Hidden)
        ALLOWED_TYPES = "openminds.ephys.Pipette"
        IS_SCALAR = true
    end
end
