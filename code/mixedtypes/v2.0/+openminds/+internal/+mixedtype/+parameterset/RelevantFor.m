classdef RelevantFor < openminds.internal.abstract.LinkedCategory
    properties (Constant, Hidden)
        ALLOWED_TYPES = ["openminds.controlledterms.BehavioralTask", "openminds.controlledterms.Technique"]
        IS_SCALAR = true
    end
end
