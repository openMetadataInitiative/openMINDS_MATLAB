classdef StudyOption < openminds.internal.abstract.LinkedCategory
    properties (Constant, Hidden)
        ALLOWED_TYPES = ["openminds.controlledterms.BiologicalSex", "openminds.controlledterms.CellType", "openminds.controlledterms.Disease", "openminds.controlledterms.DiseaseModel", "openminds.controlledterms.Handedness", "openminds.controlledterms.Organ", "openminds.controlledterms.Phenotype", "openminds.controlledterms.Species", "openminds.controlledterms.Strain", "openminds.controlledterms.TermSuggestion", "openminds.sands.CustomAnatomicalEntity", "openminds.sands.ParcellationEntity"]
        IS_SCALAR = false
    end
end
