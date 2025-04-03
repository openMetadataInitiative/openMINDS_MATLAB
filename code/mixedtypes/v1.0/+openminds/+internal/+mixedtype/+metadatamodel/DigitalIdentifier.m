classdef DigitalIdentifier < openminds.internal.abstract.LinkedCategory
    properties (Constant, Hidden)
        ALLOWED_TYPES = [ ...
            "openminds.core.miscellaneous.DOI", ...
            "openminds.core.miscellaneous.SWHID" ...
        ]
        IS_SCALAR = true
    end
end