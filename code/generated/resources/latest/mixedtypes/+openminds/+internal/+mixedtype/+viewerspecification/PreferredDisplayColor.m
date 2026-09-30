classdef PreferredDisplayColor < openminds.base.MixedTypeSet
    properties (Constant, Hidden)
        ALLOWED_TYPES = [ ...
            "openminds.controlledterms.Colormap", ...
            "openminds.sands.miscellaneous.SingleColor" ...
        ]
        IS_SCALAR = true
    end

    methods (Static)
        function obj = empty(varargin)
            obj = openminds.internal.mixedtype.viewerspecification.PreferredDisplayColor();
        end
    end
end
