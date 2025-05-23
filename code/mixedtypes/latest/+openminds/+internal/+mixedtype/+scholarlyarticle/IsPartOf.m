classdef IsPartOf < openminds.internal.abstract.MixedTypeSet
    properties (Constant, Hidden)
        ALLOWED_TYPES = [ ...
            "openminds.publications.PublicationIssue", ...
            "openminds.publications.PublicationVolume" ...
        ]
        IS_SCALAR = true
    end
end