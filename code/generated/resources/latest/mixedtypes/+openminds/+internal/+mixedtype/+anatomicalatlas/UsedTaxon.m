classdef UsedTaxon < openminds.base.MixedTypeSet
    properties (Constant, Hidden)
        ALLOWED_TYPES = [ ...
            "openminds.controlledterms.BiologicalOrder", ...
            "openminds.controlledterms.Species" ...
        ]
        IS_SCALAR = true
    end

    methods (Static)
        function obj = empty(varargin)
            obj = openminds.internal.mixedtype.anatomicalatlas.UsedTaxon();
        end
    end
end
