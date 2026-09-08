classdef CoordinateFramework < openminds.base.MixedTypeSet
    properties (Constant, Hidden)
        ALLOWED_TYPES = [ ...
            "openminds.sands.atlas.CommonCoordinateFrameworkVersion", ...
            "openminds.sands.nonatlas.CustomCoordinateFramework" ...
        ]
        IS_SCALAR = true
    end

    methods (Static)
        function obj = empty(varargin)
            obj = openminds.internal.mixedtype.customannotation.CoordinateFramework();
        end
    end
end
