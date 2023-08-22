classdef DigitalIdentifier < openminds.internal.abstract.LinkedCategory
    properties (Constant, Hidden)
        ALLOWED_TYPES = ["openminds.core.DOI", "openminds.core.SWHID"]
        IS_SCALAR = true
    end
end
