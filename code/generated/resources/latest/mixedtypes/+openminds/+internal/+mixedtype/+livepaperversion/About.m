classdef About < openminds.base.MixedTypeSet
    properties (Constant, Hidden)
        ALLOWED_TYPES = [ ...
            "openminds.core.products.DatasetVersion", ...
            "openminds.core.products.ModelVersion", ...
            "openminds.core.products.SoftwareVersion" ...
        ]
        IS_SCALAR = false
    end

    methods (Static)
        function obj = empty(varargin)
            obj = openminds.internal.mixedtype.livepaperversion.About();
        end
    end
end
