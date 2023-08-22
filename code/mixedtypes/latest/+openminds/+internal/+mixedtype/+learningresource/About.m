classdef About < openminds.internal.abstract.LinkedCategory
    properties (Constant, Hidden)
        ALLOWED_TYPES = ["openminds.computation.ValidationTest", "openminds.computation.ValidationTestVersion", "openminds.computation.WorkflowRecipe", "openminds.computation.WorkflowRecipeVersion", "openminds.core.Dataset", "openminds.core.DatasetVersion", "openminds.core.MetaDataModel", "openminds.core.MetaDataModelVersion", "openminds.core.Model", "openminds.core.ModelVersion", "openminds.core.Software", "openminds.core.SoftwareVersion", "openminds.core.WebService", "openminds.core.WebServiceVersion", "openminds.publications.LivePaper", "openminds.publications.LivePaperVersion", "openminds.sands.BrainAtlas", "openminds.sands.BrainAtlasVersion", "openminds.sands.CommonCoordinateSpace", "openminds.sands.CommonCoordinateSpaceVersion"]
        IS_SCALAR = false
    end
end
