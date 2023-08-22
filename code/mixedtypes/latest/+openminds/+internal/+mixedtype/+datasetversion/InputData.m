classdef InputData < openminds.internal.abstract.LinkedCategory
    properties (Constant, Hidden)
        ALLOWED_TYPES = ["openminds.core.DOI", "openminds.core.File", "openminds.core.FileBundle", "openminds.core.WebResource", "openminds.sands.BrainAtlas", "openminds.sands.BrainAtlasVersion", "openminds.sands.CommonCoordinateSpace", "openminds.sands.CommonCoordinateSpaceVersion"]
        IS_SCALAR = false
    end
end
