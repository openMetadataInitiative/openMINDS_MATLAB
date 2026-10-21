classdef Device < openminds.base.MixedTypeSet
    properties (Constant, Hidden)
        ALLOWED_TYPES = [ ...
            "openminds.ephys.device.ElectrodeArrayUsage", ...
            "openminds.ephys.device.ElectrodeUsage", ...
            "openminds.ephys.device.PipetteUsage" ...
        ]
        IS_SCALAR = false
    end

    methods (Static)
        function obj = empty(varargin)
            obj = openminds.internal.mixedtype.recordingactivity.Device();
        end
    end
end
