classdef HostedBy < openminds.base.MixedTypeSet
    properties (Constant, Hidden)
        ALLOWED_TYPES = [ ...
            "openminds.core.actors.Organization", ...
            "openminds.core.products.Service", ...
            "openminds.core.products.Service" ...
        ]
        IS_SCALAR = true
    end

    methods (Static)
        function obj = empty(varargin)
            obj = openminds.internal.mixedtype.livepaperresourceitem.HostedBy();
        end
    end
end
