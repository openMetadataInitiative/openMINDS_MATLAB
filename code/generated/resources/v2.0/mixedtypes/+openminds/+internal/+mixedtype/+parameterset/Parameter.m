classdef Parameter < openminds.base.MixedTypeSet
    properties (Constant, Hidden)
        ALLOWED_TYPES = [ ...
            "openminds.core.research.NumericalParameter", ...
            "openminds.core.research.StringParameter" ...
        ]
        IS_SCALAR = false
    end

    methods (Static)
        function obj = empty(varargin)
            obj = openminds.internal.mixedtype.parameterset.Parameter();
        end
    end
end
