classdef StudyTarget < openminds.internal.abstract.LinkedCategory
    properties (Constant, Hidden)
        ALLOWED_TYPES = [ ...
            "openminds.controlledterms.AuditoryStimulusType", ...
            "openminds.controlledterms.BiologicalOrder", ...
            "openminds.controlledterms.BiologicalSex", ...
            "openminds.controlledterms.BreedingType", ...
            "openminds.controlledterms.CellCultureType", ...
            "openminds.controlledterms.CellType", ...
            "openminds.controlledterms.Disease", ...
            "openminds.controlledterms.DiseaseModel", ...
            "openminds.controlledterms.ElectricalStimulusType", ...
            "openminds.controlledterms.GeneticStrainType", ...
            "openminds.controlledterms.GustatoryStimulusType", ...
            "openminds.controlledterms.Handedness", ...
            "openminds.controlledterms.MolecularEntity", ...
            "openminds.controlledterms.OlfactoryStimulusType", ...
            "openminds.controlledterms.OpticalStimulusType", ...
            "openminds.controlledterms.Organ", ...
            "openminds.controlledterms.OrganismSubstance", ...
            "openminds.controlledterms.OrganismSystem", ...
            "openminds.controlledterms.Species", ...
            "openminds.controlledterms.SubcellularEntity", ...
            "openminds.controlledterms.TactileStimulusType", ...
            "openminds.controlledterms.TermSuggestion", ...
            "openminds.controlledterms.TissueSampleType", ...
            "openminds.controlledterms.UBERONParcellation", ...
            "openminds.controlledterms.VisualStimulusType", ...
            "openminds.sands.atlas.ParcellationEntity", ...
            "openminds.sands.atlas.ParcellationEntityVersion", ...
            "openminds.sands.nonatlas.CustomAnatomicalEntity" ...
        ]
        IS_SCALAR = false
    end
end