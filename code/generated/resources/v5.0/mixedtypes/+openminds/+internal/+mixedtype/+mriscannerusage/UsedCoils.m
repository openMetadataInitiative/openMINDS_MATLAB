classdef UsedCoils < openminds.base.MixedTypeSet
    properties (Constant, Hidden)
        ALLOWED_TYPES = [ ...
            "openminds.controlledterms.DeviceType", ...
            "openminds.neuroimaging.device.MRICoilUsage" ...
        ]
        IS_SCALAR = false
    end

    methods (Static)
        function obj = empty(varargin)
            obj = openminds.internal.mixedtype.mriscannerusage.UsedCoils();
        end
    end
end
