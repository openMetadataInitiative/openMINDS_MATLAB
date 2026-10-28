classdef InRelationTo < openminds.base.MixedTypeSet
    properties (Constant, Hidden)
        ALLOWED_TYPES = [ ...
            "openminds.sands.atlas.ParcellationEntity", ...
            "openminds.sands.atlas.ParcellationEntityVersion", ...
            "openminds.sands.nonatlas.CustomAnatomicalEntity" ...
        ]
        IS_SCALAR = true
    end

    methods (Static)
        function obj = empty(varargin)
            obj = openminds.internal.mixedtype.qualitativerelationassessment.InRelationTo();
        end
    end
end
