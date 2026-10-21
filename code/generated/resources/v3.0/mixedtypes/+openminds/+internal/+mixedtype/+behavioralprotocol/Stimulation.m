classdef Stimulation < openminds.base.MixedTypeSet
    properties (Constant, Hidden)
        ALLOWED_TYPES = [ ...
            "openminds.controlledterms.StimulationApproach", ...
            "openminds.controlledterms.StimulationTechnique" ...
        ]
        IS_SCALAR = false
    end

    methods (Static)
        function obj = empty(varargin)
            obj = openminds.internal.mixedtype.behavioralprotocol.Stimulation();
        end
    end
end
