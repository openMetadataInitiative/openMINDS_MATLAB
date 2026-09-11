classdef CoordinateSpace < openminds.base.MixedTypeSet
    properties (Constant, Hidden)
        ALLOWED_TYPES = [ ...
            "openminds.sands.atlas.CommonCoordinateSpace", ...
            "openminds.sands.nonatlas.CustomCoordinateSpace" ...
        ]
        IS_SCALAR = true
    end

    methods (Static)
        function obj = empty(varargin)
            obj = openminds.internal.mixedtype.coordinatepoint.CoordinateSpace();
        end
    end
end
