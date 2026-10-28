classdef Specification < openminds.base.MixedTypeSet
    properties (Constant, Hidden)
        ALLOWED_TYPES = [ ...
            "openminds.core.data.File", ...
            "openminds.core.data.FileBundle", ...
            "openminds.core.research.Configuration", ...
            "openminds.core.research.PropertyValueList" ...
        ]
        IS_SCALAR = false
    end

    methods (Static)
        function obj = empty(varargin)
            obj = openminds.internal.mixedtype.ephysstimulus.Specification();
        end
    end
end
