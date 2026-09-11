classdef MeasuredWith < openminds.base.MixedTypeSet
    properties (Constant, Hidden)
        ALLOWED_TYPES = [ ...
            "openminds.ephys.device.ElectrodeArrayUsage", ...
            "openminds.ephys.device.ElectrodeUsage", ...
            "openminds.ephys.device.PipetteUsage", ...
            "openminds.specimenprep.device.SlicingDeviceUsage" ...
        ]
        IS_SCALAR = true
    end

    methods (Static)
        function obj = empty(varargin)
            obj = openminds.internal.mixedtype.measurement.MeasuredWith();
        end
    end
end
