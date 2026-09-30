classdef DigitalIdentifier < openminds.base.MixedTypeSet
    properties (Constant, Hidden)
        ALLOWED_TYPES = [ ...
            "openminds.core.digitalidentifier.DOI", ...
            "openminds.core.digitalidentifier.GenericIdentifier", ...
            "openminds.core.digitalidentifier.IdentifiersDotOrgID", ...
            "openminds.core.digitalidentifier.RRID" ...
        ]
        IS_SCALAR = true
    end

    methods (Static)
        function obj = empty(varargin)
            obj = openminds.internal.mixedtype.dataset.DigitalIdentifier();
        end
    end
end
