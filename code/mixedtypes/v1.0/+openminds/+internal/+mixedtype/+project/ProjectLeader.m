classdef ProjectLeader < openminds.internal.abstract.LinkedCategory
    properties (Constant, Hidden)
        ALLOWED_TYPES = ["openminds.core.Organization", "openminds.core.Person"]
        IS_SCALAR = false
    end
end
