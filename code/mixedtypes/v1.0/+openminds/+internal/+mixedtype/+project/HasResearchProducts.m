classdef HasResearchProducts < openminds.internal.abstract.LinkedCategory
    properties (Constant, Hidden)
        ALLOWED_TYPES = [ ...
            "openminds.core.products.Dataset", ...
            "openminds.core.products.DatasetVersion", ...
            "openminds.core.products.MetaDataModel", ...
            "openminds.core.products.MetaDataModelVersion", ...
            "openminds.core.products.Model", ...
            "openminds.core.products.ModelVersion", ...
            "openminds.core.products.Software", ...
            "openminds.core.products.SoftwareVersion" ...
        ]
        IS_SCALAR = false
    end
end