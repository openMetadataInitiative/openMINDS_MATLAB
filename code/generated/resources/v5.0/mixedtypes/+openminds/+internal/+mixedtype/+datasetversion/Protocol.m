classdef Protocol < openminds.base.MixedTypeSet
    properties (Constant, Hidden)
        ALLOWED_TYPES = [ ...
            "openminds.core.research.BehavioralProtocol", ...
            "openminds.core.research.Protocol" ...
        ]
        IS_SCALAR = false
    end

    methods (Static)
        function obj = empty(varargin)
            obj = openminds.internal.mixedtype.datasetversion.Protocol();
        end
    end
end
