classdef Author < openminds.internal.abstract.LinkedCategory
    properties (Constant, Hidden)
        ALLOWED_TYPES = [ ...
            "openminds.core.actors.Organization", ...
            "openminds.core.actors.Person" ...
        ]
        IS_SCALAR = false
    end
end