classdef UsedSpecimen < openminds.base.MixedTypeSet
    properties (Constant, Hidden)
        ALLOWED_TYPES = [ ...
            "openminds.core.research.SubjectState", ...
            "openminds.core.research.TissueSampleState" ...
        ]
        IS_SCALAR = true
    end

    methods (Static)
        function obj = empty(varargin)
            obj = openminds.internal.mixedtype.pipetteusage.UsedSpecimen();
        end
    end
end
