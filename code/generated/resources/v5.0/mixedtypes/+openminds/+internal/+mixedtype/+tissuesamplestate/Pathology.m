classdef Pathology < openminds.base.MixedTypeSet
    properties (Constant, Hidden)
        ALLOWED_TYPES = [ ...
            "openminds.controlledterms.Disease", ...
            "openminds.controlledterms.DiseaseModel" ...
        ]
        IS_SCALAR = false
    end

    methods (Static)
        function obj = empty(varargin)
            obj = openminds.internal.mixedtype.tissuesamplestate.Pathology();
        end
    end
end
