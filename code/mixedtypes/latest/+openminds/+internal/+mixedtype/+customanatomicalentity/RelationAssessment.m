classdef RelationAssessment < openminds.internal.abstract.LinkedCategory
    properties (Constant, Hidden)
        ALLOWED_TYPES = [ ...
            "openminds.sands.miscellaneous.QualitativeRelationAssessment", ...
            "openminds.sands.miscellaneous.QuantitativeRelationAssessment" ...
        ]
        IS_SCALAR = false
    end
end