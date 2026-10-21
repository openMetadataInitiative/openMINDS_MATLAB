classdef RelativeTimeIndication < openminds.base.MixedTypeSet
    properties (Constant, Hidden)
        ALLOWED_TYPES = [ ...
            "openminds.core.miscellaneous.QuantitativeValue", ...
            "openminds.core.miscellaneous.QuantitativeValueRange" ...
        ]
        IS_SCALAR = true
    end

    methods (Static)
        function obj = empty(varargin)
            obj = openminds.internal.mixedtype.subjectgroupstate.RelativeTimeIndication();
        end
    end
end
