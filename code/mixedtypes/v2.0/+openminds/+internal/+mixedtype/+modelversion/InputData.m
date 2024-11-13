classdef InputData < openminds.internal.abstract.LinkedCategory
    properties (Constant, Hidden)
        ALLOWED_TYPES = [ ...
            "openminds.core.data.File", ...
            "openminds.core.data.FileBundle", ...
            "openminds.core.miscellaneous.DOI" ...
        ]
        IS_SCALAR = false
    end
end