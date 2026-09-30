classdef AssociatedProtocol < openminds.base.MixedTypeSet
    properties (Constant, Hidden)
        ALLOWED_TYPES = [ ...
            "openminds.core.research.BehavioralProtocol", ...
            "openminds.core.research.Protocol" ...
        ]
        IS_SCALAR = false
    end

    methods (Static)
        function obj = empty(varargin)
            obj = openminds.internal.mixedtype.tissuesamplecollectionstate.AssociatedProtocol();
        end
    end
end
