classdef LabelingCompound < openminds.base.MixedTypeSet
    properties (Constant, Hidden)
        ALLOWED_TYPES = [ ...
            "openminds.chemicals.ChemicalMixture", ...
            "openminds.chemicals.ChemicalSubstance", ...
            "openminds.controlledterms.MolecularEntity" ...
        ]
        IS_SCALAR = true
    end

    methods (Static)
        function obj = empty(varargin)
            obj = openminds.internal.mixedtype.pipetteusage.LabelingCompound();
        end
    end
end
