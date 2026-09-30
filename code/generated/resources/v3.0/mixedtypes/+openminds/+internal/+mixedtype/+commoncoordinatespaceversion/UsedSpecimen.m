classdef UsedSpecimen < openminds.base.MixedTypeSet
    properties (Constant, Hidden)
        ALLOWED_TYPES = [ ...
            "openminds.core.research.Subject", ...
            "openminds.core.research.SubjectGroup", ...
            "openminds.core.research.TissueSample", ...
            "openminds.core.research.TissueSampleCollection" ...
        ]
        IS_SCALAR = false
    end

    methods (Static)
        function obj = empty(varargin)
            obj = openminds.internal.mixedtype.commoncoordinatespaceversion.UsedSpecimen();
        end
    end
end
