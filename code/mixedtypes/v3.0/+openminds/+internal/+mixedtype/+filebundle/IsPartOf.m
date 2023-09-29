classdef IsPartOf < openminds.internal.abstract.LinkedCategory
    properties (Constant, Hidden)
        ALLOWED_TYPES = ["openminds.core.FileBundle", "openminds.core.FileRepository"]
        IS_SCALAR = true
    end
end
