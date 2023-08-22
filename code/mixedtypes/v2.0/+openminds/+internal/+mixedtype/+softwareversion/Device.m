classdef Device < openminds.internal.abstract.LinkedCategory
    properties (Constant, Hidden)
        ALLOWED_TYPES = "openminds.controlledterms.OperatingDevice"
        IS_SCALAR = false
    end
end
