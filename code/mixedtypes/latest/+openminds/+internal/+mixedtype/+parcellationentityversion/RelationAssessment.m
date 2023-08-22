classdef RelationAssessment < openminds.internal.abstract.LinkedCategory
    properties (Constant, Hidden)
        ALLOWED_TYPES = ["openminds.sands.QualitativeRelationAssessment", "openminds.sands.QuantitativeRelationAssessment"]
        IS_SCALAR = false
    end
end
