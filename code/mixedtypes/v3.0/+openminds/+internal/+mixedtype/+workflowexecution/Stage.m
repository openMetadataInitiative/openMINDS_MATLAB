classdef Stage < openminds.internal.abstract.LinkedCategory
    properties (Constant, Hidden)
        ALLOWED_TYPES = ["openminds.computation.DataAnalysis", "openminds.computation.DataCopy", "openminds.computation.GenericComputation", "openminds.computation.ModelValidation", "openminds.computation.Optimization", "openminds.computation.Simulation", "openminds.computation.Visualization"]
        IS_SCALAR = false
    end
end
