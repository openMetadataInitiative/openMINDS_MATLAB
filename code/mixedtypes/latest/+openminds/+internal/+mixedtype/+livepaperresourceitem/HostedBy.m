classdef HostedBy < openminds.internal.abstract.LinkedCategory
    properties (Constant, Hidden)
        ALLOWED_TYPES = ["openminds.controlledterms.Service", "openminds.core.Organization", "openminds.core.WebService"]
        IS_SCALAR = true
    end
end
