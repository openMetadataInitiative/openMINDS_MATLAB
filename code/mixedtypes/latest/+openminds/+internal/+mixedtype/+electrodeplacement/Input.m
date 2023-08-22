classdef Input < openminds.internal.abstract.LinkedCategory
    properties (Constant, Hidden)
        ALLOWED_TYPES = ["openminds.core.SubjectState", "openminds.core.TissueSampleState"]
        IS_SCALAR = false
    end
end
