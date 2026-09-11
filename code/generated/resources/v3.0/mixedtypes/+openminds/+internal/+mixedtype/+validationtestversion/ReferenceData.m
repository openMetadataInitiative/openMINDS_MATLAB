classdef ReferenceData < openminds.base.MixedTypeSet
    properties (Constant, Hidden)
        ALLOWED_TYPES = [ ...
            "openminds.core.data.File", ...
            "openminds.core.data.FileBundle", ...
            "openminds.core.digitalidentifier.DOI", ...
            "openminds.core.miscellaneous.WebResource" ...
        ]
        IS_SCALAR = false
    end

    methods (Static)
        function obj = empty(varargin)
            obj = openminds.internal.mixedtype.validationtestversion.ReferenceData();
        end
    end
end
