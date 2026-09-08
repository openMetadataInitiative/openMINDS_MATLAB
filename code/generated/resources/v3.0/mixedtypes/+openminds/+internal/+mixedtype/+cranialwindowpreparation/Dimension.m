classdef Dimension < openminds.base.MixedTypeSet
    properties (Constant, Hidden)
        ALLOWED_TYPES = [ ...
            "openminds.sands.mathematicalshapes.Circle", ...
            "openminds.sands.mathematicalshapes.Ellipse", ...
            "openminds.sands.mathematicalshapes.Rectangle" ...
        ]
        IS_SCALAR = true
    end

    methods (Static)
        function obj = empty(varargin)
            obj = openminds.internal.mixedtype.cranialwindowpreparation.Dimension();
        end
    end
end
