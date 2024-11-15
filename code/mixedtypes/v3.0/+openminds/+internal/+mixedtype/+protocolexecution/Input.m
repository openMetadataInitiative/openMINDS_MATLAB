classdef Input < openminds.internal.abstract.LinkedCategory
    properties (Constant, Hidden)
        ALLOWED_TYPES = [ ...
            "openminds.core.data.File", ...
            "openminds.core.data.FileBundle", ...
            "openminds.core.research.SubjectGroupState", ...
            "openminds.core.research.SubjectState", ...
            "openminds.core.research.TissueSampleCollectionState", ...
            "openminds.core.research.TissueSampleState", ...
            "openminds.sands.atlas.BrainAtlasVersion", ...
            "openminds.sands.atlas.CommonCoordinateSpaceVersion" ...
        ]
        IS_SCALAR = false
    end
end