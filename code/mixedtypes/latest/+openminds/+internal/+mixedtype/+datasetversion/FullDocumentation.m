classdef FullDocumentation < openminds.internal.abstract.LinkedCategory
    properties (Constant, Hidden)
        ALLOWED_TYPES = ["openminds.core.DOI", "openminds.core.File", "openminds.core.ISBN", "openminds.core.WebResource"]
        IS_SCALAR = true
    end
end
