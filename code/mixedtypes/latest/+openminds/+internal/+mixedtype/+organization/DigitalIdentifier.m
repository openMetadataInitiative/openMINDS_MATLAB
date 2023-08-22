classdef DigitalIdentifier < openminds.internal.abstract.LinkedCategory
    properties (Constant, Hidden)
        ALLOWED_TYPES = ["openminds.core.GRIDID", "openminds.core.RORID", "openminds.core.RRID"]
        IS_SCALAR = false
    end
end
