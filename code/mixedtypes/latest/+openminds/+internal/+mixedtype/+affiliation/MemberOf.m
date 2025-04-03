classdef MemberOf < openminds.internal.abstract.LinkedCategory
    properties (Constant, Hidden)
        ALLOWED_TYPES = [ ...
            "openminds.core.actors.Consortium", ...
            "openminds.core.actors.Organization" ...
        ]
        IS_SCALAR = true
    end
end