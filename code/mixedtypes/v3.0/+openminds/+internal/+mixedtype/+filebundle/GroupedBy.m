classdef GroupedBy < openminds.internal.abstract.LinkedCategory
    properties (Constant, Hidden)
        ALLOWED_TYPES = [ ...
            "openminds.computation.LocalFile", ...
            "openminds.controlledterms.AnalysisTechnique", ...
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
            "openminds.controlledterms.StimulationApproach", ...
            "openminds.controlledterms.StimulationTechnique", ...
            "openminds.controlledterms.SubcellularEntity", ...
            "openminds.controlledterms.TactileStimulusType", ...
            "openminds.controlledterms.Technique", ...
            "openminds.controlledterms.TermSuggestion", ...
            "openminds.controlledterms.UBERONParcellation", ...
            "openminds.controlledterms.VisualStimulusType", ...
            "openminds.core.data.File", ...
            "openminds.core.data.FileBundle", ...
            "openminds.core.research.BehavioralProtocol", ...
            "openminds.core.research.Subject", ...
            "openminds.core.research.SubjectGroup", ...
            "openminds.core.research.SubjectGroupState", ...
            "openminds.core.research.SubjectState", ...
            "openminds.core.research.TissueSample", ...
            "openminds.core.research.TissueSampleCollection", ...
            "openminds.core.research.TissueSampleCollectionState", ...
            "openminds.core.research.TissueSampleState", ...
            "openminds.sands.atlas.CommonCoordinateSpace", ...
            "openminds.sands.atlas.CommonCoordinateSpaceVersion", ...
            "openminds.sands.atlas.ParcellationEntity", ...
            "openminds.sands.atlas.ParcellationEntityVersion", ...
            "openminds.sands.nonatlas.CustomAnatomicalEntity", ...
            "openminds.sands.nonatlas.CustomCoordinateSpace" ...
        ]
        IS_SCALAR = false
    end
end