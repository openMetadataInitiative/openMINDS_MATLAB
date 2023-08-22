classdef PreferredDisplayColor < openminds.internal.abstract.LinkedCategory
    properties (Constant, Hidden)
        ALLOWED_TYPES = ["openminds.controlledterms.Colormap", "openminds.sands.SingleColor"]
        IS_SCALAR = true
    end
end
