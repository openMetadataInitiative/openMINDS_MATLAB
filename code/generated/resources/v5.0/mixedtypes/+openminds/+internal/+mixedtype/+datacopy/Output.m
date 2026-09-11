classdef Output < openminds.base.MixedTypeSet
    properties (Constant, Hidden)
        ALLOWED_TYPES = [ ...
            "openminds.core.data.File", ...
            "openminds.core.data.FileBundle", ...
            "openminds.core.data.LocalFile" ...
        ]
        IS_SCALAR = false
    end

    methods (Static)
        function obj = empty(varargin)
            obj = openminds.internal.mixedtype.datacopy.Output();
        end
    end
end
