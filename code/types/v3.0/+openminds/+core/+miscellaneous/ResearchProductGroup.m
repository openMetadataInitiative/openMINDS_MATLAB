classdef ResearchProductGroup < openminds.abstract.Schema
%ResearchProductGroup - No description available.
%
%   PROPERTIES:
%
%   context : (1,1) string
%             Enter the common context for this research product group.
%
%   hasPart : (1,:) <a href="matlab:help openminds.computation.ValidationTest" style="font-weight:bold">ValidationTest</a>, <a href="matlab:help openminds.computation.ValidationTestVersion" style="font-weight:bold">ValidationTestVersion</a>, <a href="matlab:help openminds.computation.WorkflowRecipe" style="font-weight:bold">WorkflowRecipe</a>, <a href="matlab:help openminds.computation.WorkflowRecipeVersion" style="font-weight:bold">WorkflowRecipeVersion</a>, <a href="matlab:help openminds.core.products.Dataset" style="font-weight:bold">Dataset</a>, <a href="matlab:help openminds.core.products.DatasetVersion" style="font-weight:bold">DatasetVersion</a>, <a href="matlab:help openminds.core.products.MetaDataModel" style="font-weight:bold">MetaDataModel</a>, <a href="matlab:help openminds.core.products.MetaDataModelVersion" style="font-weight:bold">MetaDataModelVersion</a>, <a href="matlab:help openminds.core.products.Model" style="font-weight:bold">Model</a>, <a href="matlab:help openminds.core.products.ModelVersion" style="font-weight:bold">ModelVersion</a>, <a href="matlab:help openminds.core.products.Software" style="font-weight:bold">Software</a>, <a href="matlab:help openminds.core.products.SoftwareVersion" style="font-weight:bold">SoftwareVersion</a>, <a href="matlab:help openminds.core.products.WebService" style="font-weight:bold">WebService</a>, <a href="matlab:help openminds.core.products.WebServiceVersion" style="font-weight:bold">WebServiceVersion</a>, <a href="matlab:help openminds.publications.LivePaper" style="font-weight:bold">LivePaper</a>, <a href="matlab:help openminds.publications.LivePaperVersion" style="font-weight:bold">LivePaperVersion</a>, <a href="matlab:help openminds.sands.atlas.BrainAtlas" style="font-weight:bold">BrainAtlas</a>, <a href="matlab:help openminds.sands.atlas.BrainAtlasVersion" style="font-weight:bold">BrainAtlasVersion</a>, <a href="matlab:help openminds.sands.atlas.CommonCoordinateSpace" style="font-weight:bold">CommonCoordinateSpace</a>, <a href="matlab:help openminds.sands.atlas.CommonCoordinateSpaceVersion" style="font-weight:bold">CommonCoordinateSpaceVersion</a>
%             Add all research products (research product versions) that should be grouped under the given 'context'.

%   This class was auto-generated by the openMINDS pipeline

    properties
        % Enter the common context for this research product group.
        context (1,1) string

        % Add all research products (research product versions) that should be grouped under the given 'context'.
        hasPart (1,:) openminds.internal.mixedtype.researchproductgroup.HasPart ...
            {mustBeListOfUniqueItems(hasPart)}
    end

    properties (Access = protected)
        Required = ["context", "hasPart"]
    end

    properties (Constant, Hidden)
        X_TYPE = "https://openminds.ebrains.eu/core/ResearchProductGroup"
    end

    properties (Constant, Hidden)
        LINKED_PROPERTIES = struct(...
            'hasPart', ["openminds.computation.ValidationTest", "openminds.computation.ValidationTestVersion", "openminds.computation.WorkflowRecipe", "openminds.computation.WorkflowRecipeVersion", "openminds.core.products.Dataset", "openminds.core.products.DatasetVersion", "openminds.core.products.MetaDataModel", "openminds.core.products.MetaDataModelVersion", "openminds.core.products.Model", "openminds.core.products.ModelVersion", "openminds.core.products.Software", "openminds.core.products.SoftwareVersion", "openminds.core.products.WebService", "openminds.core.products.WebServiceVersion", "openminds.publications.LivePaper", "openminds.publications.LivePaperVersion", "openminds.sands.atlas.BrainAtlas", "openminds.sands.atlas.BrainAtlasVersion", "openminds.sands.atlas.CommonCoordinateSpace", "openminds.sands.atlas.CommonCoordinateSpaceVersion"] ...
        )
        EMBEDDED_PROPERTIES = struct(...
        )
    end

    methods
        function obj = ResearchProductGroup(varargin)
            obj@openminds.abstract.Schema(varargin{:})
        end
    end

    methods (Access = protected)
        function str = getDisplayLabel(obj)
            str = obj.createLabelForMissingLabelDefinition();
        end
    end
end
