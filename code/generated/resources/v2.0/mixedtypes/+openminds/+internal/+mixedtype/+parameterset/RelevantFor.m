classdef RelevantFor < openminds.base.MixedTypeSet
    properties (Constant, Hidden)
        ALLOWED_TYPES = [ ...
            "openminds.controlledterms.BehavioralTask", ...
            "openminds.controlledterms.Technique" ...
        ]
        IS_SCALAR = true
    end

    methods (Static)
        function obj = empty(varargin)
            obj = openminds.internal.mixedtype.parameterset.RelevantFor();
        end
    end
end
