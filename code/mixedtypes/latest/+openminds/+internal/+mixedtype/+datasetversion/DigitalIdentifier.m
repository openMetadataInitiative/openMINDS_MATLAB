classdef DigitalIdentifier < openminds.internal.abstract.LinkedCategory
    properties (Constant, Hidden)
        ALLOWED_TYPES = ["openminds.core.DOI", "openminds.core.IdentifiersDotOrgID"]
        IS_SCALAR = true
    end
end
