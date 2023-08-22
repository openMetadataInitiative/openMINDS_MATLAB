classdef DigitalIdentifier < openminds.internal.abstract.LinkedCategory
    properties (Constant, Hidden)
        ALLOWED_TYPES = ["openminds.core.GRIDID", "openminds.core.RORID"]
        IS_SCALAR = false
    end
end
