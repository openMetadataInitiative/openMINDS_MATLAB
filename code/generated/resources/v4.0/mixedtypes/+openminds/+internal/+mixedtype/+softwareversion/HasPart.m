classdef HasPart < openminds.base.MixedTypeSet
    properties (Constant, Hidden)
        ALLOWED_TYPES = [ ...
            "openminds.core.products.ModelVersion", ...
            "openminds.core.products.SoftwareVersion", ...
            "openminds.sands.atlas.BrainAtlasVersion", ...
            "openminds.sands.atlas.CommonCoordinateSpaceVersion" ...
        ]
        IS_SCALAR = false
    end

    methods (Static)
        function obj = empty(varargin)
            obj = openminds.internal.mixedtype.softwareversion.HasPart();
        end
    end
end
