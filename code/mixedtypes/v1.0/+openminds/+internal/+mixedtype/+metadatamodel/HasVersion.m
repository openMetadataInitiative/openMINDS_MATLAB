classdef HasVersion < openminds.internal.abstract.LinkedCategory
    properties (Constant, Hidden)
        ALLOWED_TYPES = "openminds.core.MetaDataModelVersion"
        IS_SCALAR = false
    end
end
