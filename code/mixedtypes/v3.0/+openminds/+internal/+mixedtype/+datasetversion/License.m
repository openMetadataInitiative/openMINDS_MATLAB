classdef License < openminds.internal.abstract.LinkedCategory
    properties (Constant, Hidden)
        ALLOWED_TYPES = [ ...
            "openminds.core.data.License", ...
            "openminds.core.miscellaneous.WebResource" ...
        ]
        IS_SCALAR = true
    end
end