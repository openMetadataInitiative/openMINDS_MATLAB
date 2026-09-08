classdef PerformedBy < openminds.base.MixedTypeSet
    properties (Constant, Hidden)
        ALLOWED_TYPES = [ ...
            "openminds.computation.SoftwareAgent", ...
            "openminds.core.actors.Person" ...
        ]
        IS_SCALAR = false
    end

    methods (Static)
        function obj = empty(varargin)
            obj = openminds.internal.mixedtype.visualization.PerformedBy();
        end
    end
end
