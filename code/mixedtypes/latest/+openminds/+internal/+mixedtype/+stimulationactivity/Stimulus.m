classdef Stimulus < openminds.internal.abstract.LinkedCategory
    properties (Constant, Hidden)
        ALLOWED_TYPES = "openminds.stimulation.EphysStimulus"
        IS_SCALAR = false
    end
end
