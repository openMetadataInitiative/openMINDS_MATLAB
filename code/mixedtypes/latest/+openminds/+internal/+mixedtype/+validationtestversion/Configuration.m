classdef Configuration < openminds.internal.abstract.LinkedCategory
    properties (Constant, Hidden)
        ALLOWED_TYPES = ["openminds.core.Configuration", "openminds.core.File", "openminds.core.PropertyValueList", "openminds.core.WebResource"]
        IS_SCALAR = true
    end
end
