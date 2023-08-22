classdef PreviousRecording < openminds.internal.abstract.LinkedCategory
    properties (Constant, Hidden)
        ALLOWED_TYPES = "openminds.ephys.Recording"
        IS_SCALAR = true
    end
end
