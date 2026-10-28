classdef BaseShape < openminds.base.MixedTypeSet
    properties (Constant, Hidden)
        ALLOWED_TYPES = [ ...
            "openminds.sands.mathematicalshape.Circle", ...
            "openminds.sands.mathematicalshape.Ellipse" ...
        ]
        IS_SCALAR = true
    end

    methods (Static)
        function obj = empty(varargin)
            obj = openminds.internal.mixedtype.rightcylinder.BaseShape();
        end
    end
end
