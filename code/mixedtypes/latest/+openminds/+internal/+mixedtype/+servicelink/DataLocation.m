classdef DataLocation < openminds.internal.abstract.LinkedCategory
    properties (Constant, Hidden)
        ALLOWED_TYPES = ["openminds.core.File", "openminds.core.FileArchive", "openminds.core.FileBundle", "openminds.core.ModelVersion", "openminds.publications.LivePaperResourceItem", "openminds.sands.ParcellationEntityVersion"]
        IS_SCALAR = true
    end
end
