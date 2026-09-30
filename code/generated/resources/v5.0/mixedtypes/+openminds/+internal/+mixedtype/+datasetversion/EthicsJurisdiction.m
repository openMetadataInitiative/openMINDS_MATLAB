classdef EthicsJurisdiction < openminds.base.MixedTypeSet
    properties (Constant, Hidden)
        ALLOWED_TYPES = [ ...
            "openminds.controlledterms.SovereignState", ...
            "openminds.controlledterms.SupranationalBody" ...
        ]
        IS_SCALAR = true
    end

    methods (Static)
        function obj = empty(varargin)
            obj = openminds.internal.mixedtype.datasetversion.EthicsJurisdiction();
        end
    end
end
