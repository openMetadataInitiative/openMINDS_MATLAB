classdef Origin < openminds.internal.abstract.LinkedCategory
    properties (Constant, Hidden)
        ALLOWED_TYPES = [ ...
            "openminds.controlledterms.CellType", ...
            "openminds.controlledterms.Organ", ...
            "openminds.controlledterms.OrganismSubstance" ...
        ]
        IS_SCALAR = false
    end
end