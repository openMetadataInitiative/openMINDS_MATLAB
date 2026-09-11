classdef RelevantFor < openminds.base.MixedTypeSet
    properties (Constant, Hidden)
        ALLOWED_TYPES = [ ...
            "openminds.controlledterms.AnalysisTechnique", ...
            "openminds.controlledterms.StimulationApproach", ...
            "openminds.controlledterms.StimulationTechnique", ...
            "openminds.controlledterms.Technique" ...
        ]
        IS_SCALAR = true
    end

    methods (Static)
        function obj = empty(varargin)
            obj = openminds.internal.mixedtype.custompropertyset.RelevantFor();
        end
    end
end
