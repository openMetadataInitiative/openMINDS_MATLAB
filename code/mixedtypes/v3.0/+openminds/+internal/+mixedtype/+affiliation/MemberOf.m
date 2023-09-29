classdef MemberOf < openminds.internal.abstract.LinkedCategory
    properties (Constant, Hidden)
        ALLOWED_TYPES = ["openminds.core.Consortium", "openminds.core.Organization"]
        IS_SCALAR = true
    end
end
