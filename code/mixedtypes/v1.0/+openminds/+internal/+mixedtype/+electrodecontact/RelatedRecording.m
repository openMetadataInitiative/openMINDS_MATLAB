classdef RelatedRecording < openminds.internal.abstract.LinkedCategory
    properties (Constant, Hidden)
        ALLOWED_TYPES = "openminds.core.FileInstance"
        IS_SCALAR = false
    end
end
