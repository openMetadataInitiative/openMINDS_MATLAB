classdef Input < openminds.internal.abstract.LinkedCategory
    properties (Constant, Hidden)
        ALLOWED_TYPES = ["openminds.core.SubjectGroupState", "openminds.core.SubjectState", "openminds.core.TissueSampleCollectionState", "openminds.core.TissueSampleState"]
        IS_SCALAR = true
    end
end
