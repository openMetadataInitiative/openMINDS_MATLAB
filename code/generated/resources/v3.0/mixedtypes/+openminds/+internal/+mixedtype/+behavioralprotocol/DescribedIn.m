classdef DescribedIn < openminds.base.MixedTypeSet
    properties (Constant, Hidden)
        ALLOWED_TYPES = [ ...
            "openminds.core.data.File", ...
            "openminds.core.digitalidentifier.DOI", ...
            "openminds.core.miscellaneous.WebResource" ...
        ]
        IS_SCALAR = false
    end

    methods (Static)
        function obj = empty(varargin)
            obj = openminds.internal.mixedtype.behavioralprotocol.DescribedIn();
        end
    end
end
