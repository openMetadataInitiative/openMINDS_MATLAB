classdef RelatedUBERONTerm < openminds.base.MixedTypeSet
    properties (Constant, Hidden)
        ALLOWED_TYPES = [ ...
            "openminds.controlledterms.Organ", ...
            "openminds.controlledterms.UBERONParcellation" ...
        ]
        IS_SCALAR = true
    end

    methods (Static)
        function obj = empty(varargin)
            obj = openminds.internal.mixedtype.customanatomicalentity.RelatedUBERONTerm();
        end
    end
end
