classdef DigitalIdentifier < openminds.base.MixedTypeSet
    properties (Constant, Hidden)
        ALLOWED_TYPES = [ ...
            "openminds.core.digitalidentifier.GRIDID", ...
            "openminds.core.digitalidentifier.RORID", ...
            "openminds.core.digitalidentifier.RRID" ...
        ]
        IS_SCALAR = false
    end

    methods (Static)
        function obj = empty(varargin)
            obj = openminds.internal.mixedtype.organization.DigitalIdentifier();
        end
    end
end
