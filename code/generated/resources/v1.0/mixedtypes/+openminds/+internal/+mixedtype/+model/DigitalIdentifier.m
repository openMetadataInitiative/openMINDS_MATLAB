classdef DigitalIdentifier < openminds.base.MixedTypeSet
    properties (Constant, Hidden)
        ALLOWED_TYPES = [ ...
            "openminds.core.miscellaneous.DOI", ...
            "openminds.core.miscellaneous.SWHID" ...
        ]
        IS_SCALAR = true
    end

    methods (Static)
        function obj = empty(varargin)
            obj = openminds.internal.mixedtype.model.DigitalIdentifier();
        end
    end
end
