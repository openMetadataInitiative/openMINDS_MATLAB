classdef HasPart < openminds.internal.abstract.LinkedCategory
    properties (Constant, Hidden)
        ALLOWED_TYPES = "openminds.chemicals.AmountOfChemical"
        IS_SCALAR = false
    end
end
