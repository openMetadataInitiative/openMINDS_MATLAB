classdef Output < openminds.base.MixedTypeSet
    properties (Constant, Hidden)
        ALLOWED_TYPES = [ ...
            "openminds.computation.LocalFile", ...
            "openminds.core.data.File", ...
            "openminds.core.data.FileArchive", ...
            "openminds.core.data.FileBundle" ...
        ]
        IS_SCALAR = false
    end

    methods (Static)
        function obj = empty(varargin)
            obj = openminds.internal.mixedtype.genericcomputation.Output();
        end
    end
end
