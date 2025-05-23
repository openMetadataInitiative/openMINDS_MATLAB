classdef About < openminds.internal.abstract.MixedTypeSet
    properties (Constant, Hidden)
        ALLOWED_TYPES = [ ...
            "openminds.core.products.DatasetVersion", ...
            "openminds.core.products.ModelVersion", ...
            "openminds.core.products.SoftwareVersion" ...
        ]
        IS_SCALAR = false
    end
end