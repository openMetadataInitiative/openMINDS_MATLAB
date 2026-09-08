classdef IsPartOf < openminds.base.MixedTypeSet
    properties (Constant, Hidden)
        ALLOWED_TYPES = [ ...
            "openminds.publications.PublicationIssue", ...
            "openminds.publications.PublicationVolume" ...
        ]
        IS_SCALAR = true
    end

    methods (Static)
        function obj = empty(varargin)
            obj = openminds.internal.mixedtype.scholarlyarticle.IsPartOf();
        end
    end
end
