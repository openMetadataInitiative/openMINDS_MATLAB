classdef Provider < openminds.base.MixedTypeSet
    properties (Constant, Hidden)
        ALLOWED_TYPES = [ ...
            "openminds.core.actors.Consortium", ...
            "openminds.core.actors.Organization", ...
            "openminds.core.actors.Person" ...
        ]
        IS_SCALAR = true
    end

    methods (Static)
        function obj = empty(varargin)
            obj = openminds.internal.mixedtype.productsource.Provider();
        end
    end
end
