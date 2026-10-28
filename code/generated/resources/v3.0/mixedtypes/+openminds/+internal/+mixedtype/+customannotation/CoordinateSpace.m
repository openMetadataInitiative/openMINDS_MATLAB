classdef CoordinateSpace < openminds.base.MixedTypeSet
    properties (Constant, Hidden)
        ALLOWED_TYPES = [ ...
            "openminds.sands.atlas.CommonCoordinateSpaceVersion", ...
            "openminds.sands.nonatlas.CustomCoordinateSpace" ...
        ]
        IS_SCALAR = true
    end

    methods (Static)
        function obj = empty(varargin)
            obj = openminds.internal.mixedtype.customannotation.CoordinateSpace();
        end
    end
end
