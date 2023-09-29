classdef Input < openminds.internal.abstract.LinkedCategory
    properties (Constant, Hidden)
        ALLOWED_TYPES = ["openminds.core.File", "openminds.core.FileBundle", "openminds.core.SubjectGroupState", "openminds.core.SubjectState", "openminds.core.TissueSampleCollectionState", "openminds.core.TissueSampleState", "openminds.sands.BrainAtlasVersion", "openminds.sands.CommonCoordinateSpaceVersion"]
        IS_SCALAR = false
    end
end
