classdef FullDocumentation < openminds.internal.abstract.LinkedCategory
    properties (Constant, Hidden)
        ALLOWED_TYPES = [ ...
            "openminds.core.data.File", ...
            "openminds.core.digitalidentifier.DOI", ...
            "openminds.core.digitalidentifier.ISBN", ...
            "openminds.core.miscellaneous.WebResource" ...
        ]
        IS_SCALAR = true
    end
end