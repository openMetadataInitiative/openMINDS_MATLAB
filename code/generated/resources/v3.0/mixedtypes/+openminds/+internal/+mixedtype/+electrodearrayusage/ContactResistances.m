classdef ContactResistances < openminds.base.MixedTypeSet
    properties (Constant, Hidden)
        ALLOWED_TYPES = [ ...
            "openminds.core.miscellaneous.QuantitativeValue", ...
            "openminds.core.miscellaneous.QuantitativeValueRange" ...
        ]
        IS_SCALAR = false
    end

    methods (Static)
        function obj = empty(varargin)
            obj = openminds.internal.mixedtype.electrodearrayusage.ContactResistances();
        end
    end
end
