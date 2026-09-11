classdef RelationAssessment < openminds.base.MixedTypeSet
    properties (Constant, Hidden)
        ALLOWED_TYPES = [ ...
            "openminds.sands.miscellaneous.QualitativeRelationAssessment", ...
            "openminds.sands.miscellaneous.QuantitativeRelationAssessment" ...
        ]
        IS_SCALAR = false
    end

    methods (Static)
        function obj = empty(varargin)
            obj = openminds.internal.mixedtype.customanatomicalentity.RelationAssessment();
        end
    end
end
