classdef Stimulation < openminds.internal.abstract.LinkedCategory
    properties (Constant, Hidden)
        ALLOWED_TYPES = [ ...
            "openminds.controlledterms.StimulationApproach", ...
            "openminds.controlledterms.StimulationTechnique" ...
        ]
        IS_SCALAR = false
    end
end