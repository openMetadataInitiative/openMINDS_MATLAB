classdef Environment < openminds.base.MixedTypeSet
    properties (Constant, Hidden)
        ALLOWED_TYPES = [ ...
            "openminds.computation.Environment", ...
            "openminds.core.products.WebServiceVersion" ...
        ]
        IS_SCALAR = true
    end

    methods (Static)
        function obj = empty(varargin)
            obj = openminds.internal.mixedtype.modelvalidation.Environment();
        end
    end
end
