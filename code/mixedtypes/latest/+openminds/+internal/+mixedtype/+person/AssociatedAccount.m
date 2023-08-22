classdef AssociatedAccount < openminds.internal.abstract.LinkedCategory
    properties (Constant, Hidden)
        ALLOWED_TYPES = "openminds.core.AccountInformation"
        IS_SCALAR = false
    end
end
