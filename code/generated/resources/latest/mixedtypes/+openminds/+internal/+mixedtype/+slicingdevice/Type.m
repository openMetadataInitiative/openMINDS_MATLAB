classdef Type < openminds.base.MixedTypeSet
    properties (Constant, Hidden)
        ALLOWED_TYPES = [ ...
            "openminds.controlledterms.DeviceType", ...
            "openminds.core.products.HardwareProduct" ...
        ]
        IS_SCALAR = true
    end

    methods (Static)
        function obj = empty(varargin)
            obj = openminds.internal.mixedtype.slicingdevice.Type();
        end
    end
end
