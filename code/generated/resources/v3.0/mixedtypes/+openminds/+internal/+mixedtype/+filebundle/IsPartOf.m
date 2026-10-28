classdef IsPartOf < openminds.base.MixedTypeSet
    properties (Constant, Hidden)
        ALLOWED_TYPES = [ ...
            "openminds.core.data.FileBundle", ...
            "openminds.core.data.FileRepository" ...
        ]
        IS_SCALAR = true
    end

    methods (Static)
        function obj = empty(varargin)
            obj = openminds.internal.mixedtype.filebundle.IsPartOf();
        end
    end
end
