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
            obj = openminds.internal.mixedtype.rightcone.BaseShape();
        end
    end
end
