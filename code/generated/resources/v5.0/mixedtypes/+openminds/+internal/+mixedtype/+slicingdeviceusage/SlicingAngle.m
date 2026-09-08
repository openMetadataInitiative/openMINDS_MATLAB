classdef SlicingAngle < openminds.base.MixedTypeSet
    properties (Constant, Hidden)
        ALLOWED_TYPES = [ ...
            "openminds.core.miscellaneous.QuantitativeValue", ...
            "openminds.core.research.NumericalProperty" ...
        ]
        IS_SCALAR = false
    end

    methods (Static)
        function obj = empty(varargin)
            obj = openminds.internal.mixedtype.slicingdeviceusage.SlicingAngle();
        end
    end
end
