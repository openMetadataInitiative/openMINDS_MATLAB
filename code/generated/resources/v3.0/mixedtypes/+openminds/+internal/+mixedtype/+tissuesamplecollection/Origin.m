classdef Origin < openminds.base.MixedTypeSet
    properties (Constant, Hidden)
        ALLOWED_TYPES = [ ...
            "openminds.controlledterms.CellType", ...
            "openminds.controlledterms.Organ", ...
            "openminds.controlledterms.OrganismSubstance" ...
        ]
        IS_SCALAR = false
    end

    methods (Static)
        function obj = empty(varargin)
            obj = openminds.internal.mixedtype.tissuesamplecollection.Origin();
        end
    end
end
