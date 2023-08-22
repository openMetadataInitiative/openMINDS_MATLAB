classdef StudyTarget < openminds.internal.abstract.LinkedCategory
    properties (Constant, Hidden)
        ALLOWED_TYPES = ["openminds.controlledterms.BiologicalSex", "openminds.controlledterms.Disease", "openminds.controlledterms.Genotype", "openminds.controlledterms.Phenotype", "openminds.controlledterms.Species", "openminds.controlledterms.TermSuggestion", "openminds.sands.AnatomicalEntity"]
        IS_SCALAR = false
    end
end
