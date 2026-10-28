classdef FullDocumentation < openminds.base.MixedTypeSet
    properties (Constant, Hidden)
        ALLOWED_TYPES = [ ...
            "openminds.core.data.File", ...
            "openminds.core.miscellaneous.DOI", ...
            "openminds.core.miscellaneous.URL" ...
        ]
        IS_SCALAR = true
    end

    methods (Static)
        function obj = empty(varargin)
            obj = openminds.internal.mixedtype.datasetversion.FullDocumentation();
        end
    end
end
