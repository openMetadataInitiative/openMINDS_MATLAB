classdef Recipe < openminds.internal.abstract.LinkedCategory
    properties (Constant, Hidden)
        ALLOWED_TYPES = "openminds.computation.WorkflowRecipeVersion"
        IS_SCALAR = true
    end
end
