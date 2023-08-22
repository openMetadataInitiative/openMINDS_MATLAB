classdef IsNewVersionOf < openminds.internal.abstract.LinkedCategory
    properties (Constant, Hidden)
        ALLOWED_TYPES = "openminds.core.WebServiceVersion"
        IS_SCALAR = true
    end
end
