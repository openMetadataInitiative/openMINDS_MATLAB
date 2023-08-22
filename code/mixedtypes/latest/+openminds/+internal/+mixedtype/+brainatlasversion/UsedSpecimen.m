classdef UsedSpecimen < openminds.internal.abstract.LinkedCategory
    properties (Constant, Hidden)
        ALLOWED_TYPES = ["openminds.core.Subject", "openminds.core.SubjectGroup", "openminds.core.TissueSample", "openminds.core.TissueSampleCollection"]
        IS_SCALAR = false
    end
end
