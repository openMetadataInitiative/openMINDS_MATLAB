classdef Specification < openminds.base.MixedTypeSet
    properties (Constant, Hidden)
        ALLOWED_TYPES = [ ...
            "openminds.core.data.File", ...
            "openminds.core.miscellaneous.WebResource" ...
        ]
        IS_SCALAR = true
    end

    methods (Static)
        function obj = empty(varargin)
            obj = openminds.internal.mixedtype.interfaceversion.Specification();
        end
    end
end
