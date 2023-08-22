classdef AnatomicalLocation < openminds.internal.abstract.LinkedCategory
    properties (Constant, Hidden)
        ALLOWED_TYPES = ["openminds.controlledterms.CellType", "openminds.controlledterms.Organ", "openminds.controlledterms.OrganismSubstance", "openminds.controlledterms.SubcellularEntity", "openminds.controlledterms.UBERONParcellation", "openminds.sands.CustomAnatomicalEntity", "openminds.sands.ParcellationEntity", "openminds.sands.ParcellationEntityVersion"]
        IS_SCALAR = false
    end
end
