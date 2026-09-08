classdef Input < openminds.base.MixedTypeSet
    properties (Constant, Hidden)
        ALLOWED_TYPES = [ ...
            "openminds.core.research.SubjectGroupState", ...
            "openminds.core.research.SubjectState", ...
            "openminds.core.research.TissueSampleCollectionState", ...
            "openminds.core.research.TissueSampleState" ...
        ]
        IS_SCALAR = true
    end

    methods (Static)
        function obj = empty(varargin)
            obj = openminds.internal.mixedtype.tissueculturepreparation.Input();
        end
    end
end
