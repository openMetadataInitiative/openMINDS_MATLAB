classdef ModificationProfile < openminds.base.MixedTypeSet
    properties (Constant, Hidden)
        ALLOWED_TYPES = [ ...
            "openminds.controlledterms.ModificationConsentRequirement", ...
            "openminds.controlledterms.ModificationConstraint", ...
            "openminds.controlledterms.ModificationForm", ...
            "openminds.controlledterms.ModificationScope" ...
        ]
        IS_SCALAR = false
    end

    methods (Static)
        function obj = empty(varargin)
            obj = openminds.internal.mixedtype.usageagreement.ModificationProfile();
        end
    end
end
