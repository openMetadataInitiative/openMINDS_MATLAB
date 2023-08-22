classdef HasPart < openminds.internal.abstract.LinkedCategory
    properties (Constant, Hidden)
        ALLOWED_TYPES = ["openminds.core.Setup", "openminds.core.SoftwareVersion", "openminds.ephys.Electrode", "openminds.ephys.ElectrodeArray", "openminds.ephys.Pipette", "openminds.specimenprep.SlicingDevice"]
        IS_SCALAR = false
    end
end
