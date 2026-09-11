classdef PropertyValuePair < openminds.base.MixedTypeSet
    properties (Constant, Hidden)
        ALLOWED_TYPES = [ ...
            "openminds.core.research.NumericalProperty", ...
            "openminds.core.research.StringProperty" ...
        ]
        IS_SCALAR = false
    end

    methods (Static)
        function obj = empty(varargin)
            obj = openminds.internal.mixedtype.propertyvaluelist.PropertyValuePair();
        end
    end
end
