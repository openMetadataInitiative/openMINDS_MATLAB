classdef Origin < openminds.internal.abstract.LinkedCategory
    properties (Constant, Hidden)
        ALLOWED_TYPES = ["openminds.controlledterms.CellType", "openminds.controlledterms.Organ"]
        IS_SCALAR = true
    end
end
