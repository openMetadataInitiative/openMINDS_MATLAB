classdef HasResearchProducts < openminds.internal.abstract.LinkedCategory
    properties (Constant, Hidden)
        ALLOWED_TYPES = ["openminds.core.Dataset", "openminds.core.DatasetVersion", "openminds.core.MetaDataModel", "openminds.core.MetaDataModelVersion", "openminds.core.Model", "openminds.core.ModelVersion", "openminds.core.Software", "openminds.core.SoftwareVersion"]
        IS_SCALAR = false
    end
end
