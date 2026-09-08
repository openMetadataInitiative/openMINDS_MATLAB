classdef Output < openminds.base.MixedTypeSet
    properties (Constant, Hidden)
        ALLOWED_TYPES = [ ...
            "openminds.core.research.TissueSampleCollectionState", ...
            "openminds.core.research.TissueSampleState" ...
        ]
        IS_SCALAR = false
    end

    methods (Static)
        function obj = empty(varargin)
            obj = openminds.internal.mixedtype.tissuesampleslicing.Output();
        end
    end
end
