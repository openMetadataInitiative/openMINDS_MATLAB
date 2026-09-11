classdef CitedPublication < openminds.base.MixedTypeSet
    properties (Constant, Hidden)
        ALLOWED_TYPES = [ ...
            "openminds.core.digitalidentifier.DOI", ...
            "openminds.core.digitalidentifier.ISBN" ...
        ]
        IS_SCALAR = false
    end

    methods (Static)
        function obj = empty(varargin)
            obj = openminds.internal.mixedtype.scholarlyarticle.CitedPublication();
        end
    end
end
