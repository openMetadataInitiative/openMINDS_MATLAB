classdef HasPart < openminds.internal.abstract.LinkedCategory
    properties (Constant, Hidden)
        ALLOWED_TYPES = [ ...
            "openminds.computation.ValidationTest", ...
            "openminds.computation.ValidationTestVersion", ...
            "openminds.computation.WorkflowRecipe", ...
            "openminds.computation.WorkflowRecipeVersion", ...
            "openminds.core.products.Dataset", ...
            "openminds.core.products.DatasetVersion", ...
            "openminds.core.products.MetaDataModel", ...
            "openminds.core.products.MetaDataModelVersion", ...
            "openminds.core.products.Model", ...
            "openminds.core.products.ModelVersion", ...
            "openminds.core.products.Software", ...
            "openminds.core.products.SoftwareVersion", ...
            "openminds.core.products.WebService", ...
            "openminds.core.products.WebServiceVersion", ...
            "openminds.publications.LivePaper", ...
            "openminds.publications.LivePaperVersion", ...
            "openminds.sands.atlas.BrainAtlas", ...
            "openminds.sands.atlas.BrainAtlasVersion", ...
            "openminds.sands.atlas.CommonCoordinateSpace", ...
            "openminds.sands.atlas.CommonCoordinateSpaceVersion" ...
        ]
        IS_SCALAR = false
    end
end