classdef Repository < openminds.internal.abstract.LinkedCategory
    properties (Constant, Hidden)
        ALLOWED_TYPES = "openminds.core.FileRepository"
        IS_SCALAR = true
    end
end
