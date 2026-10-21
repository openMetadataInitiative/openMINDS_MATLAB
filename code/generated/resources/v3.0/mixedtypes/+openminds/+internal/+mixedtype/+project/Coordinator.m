classdef Coordinator < openminds.base.MixedTypeSet
    properties (Constant, Hidden)
        ALLOWED_TYPES = [ ...
            "openminds.core.actors.Consortium", ...
            "openminds.core.actors.Organization", ...
            "openminds.core.actors.Person" ...
        ]
        IS_SCALAR = false
    end

    methods (Static)
        function obj = empty(varargin)
            obj = openminds.internal.mixedtype.project.Coordinator();
        end
    end
end
