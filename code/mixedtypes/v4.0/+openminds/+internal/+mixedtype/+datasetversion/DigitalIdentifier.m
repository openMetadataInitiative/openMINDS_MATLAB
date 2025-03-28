classdef DigitalIdentifier < openminds.internal.abstract.LinkedCategory
    properties (Constant, Hidden)
        ALLOWED_TYPES = [ ...
            "openminds.core.digitalidentifier.DOI", ...
            "openminds.core.digitalidentifier.IdentifiersDotOrgID" ...
        ]
        IS_SCALAR = true
    end
end