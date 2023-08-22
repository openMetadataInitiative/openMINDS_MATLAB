classdef StudyTarget < openminds.internal.abstract.LinkedCategory
    properties (Constant, Hidden)
        ALLOWED_TYPES = ["openminds.controlledterm.BiologicalSex", "openminds.controlledterm.Disease", "openminds.controlledterm.Genotype", "openminds.controlledterm.Phenotype", "openminds.controlledterm.Species", "openminds.controlledterm.TermSuggestion", "openminds.sands.AnatomicalEntity"]
        IS_SCALAR = false
    end
end
