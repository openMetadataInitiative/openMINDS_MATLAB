classdef DigitalIdentifier < openminds.internal.abstract.LinkedCategory
    properties (Constant, Hidden)
        ALLOWED_TYPES = ["openminds.core.DOI", "openminds.core.ISBN", "openminds.core.RRID"]
        IS_SCALAR = true
    end
end
