classdef Channel < openminds.internal.abstract.LinkedCategory
    properties (Constant, Hidden)
        ALLOWED_TYPES = "openminds.ephys.Channel"
        IS_SCALAR = false
    end
end
