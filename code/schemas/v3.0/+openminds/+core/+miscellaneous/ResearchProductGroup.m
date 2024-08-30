classdef ResearchProductGroup < openminds.abstract.Schema
%ResearchProductGroup - No description available.
%
%   PROPERTIES:
%
%   context : (1,1) string
%             Enter the common context for this research product group.
%
%   hasPart : (1,:) <a href="matlab:help openminds.computation.ValidationTest" style="font-weight:bold">ValidationTest</a>, <a href="matlab:help openminds.computation.ValidationTestVersion" style="font-weight:bold">ValidationTestVersion</a>, <a href="matlab:help openminds.computation.WorkflowRecipe" style="font-weight:bold">WorkflowRecipe</a>, <a href="matlab:help openminds.computation.WorkflowRecipeVersion" style="font-weight:bold">WorkflowRecipeVersion</a>, <a href="matlab:help openminds.core.Dataset" style="font-weight:bold">Dataset</a>, <a href="matlab:help openminds.core.DatasetVersion" style="font-weight:bold">DatasetVersion</a>, <a href="matlab:help openminds.core.MetaDataModel" style="font-weight:bold">MetaDataModel</a>, <a href="matlab:help openminds.core.MetaDataModelVersion" style="font-weight:bold">MetaDataModelVersion</a>, <a href="matlab:help openminds.core.Model" style="font-weight:bold">Model</a>, <a href="matlab:help openminds.core.ModelVersion" style="font-weight:bold">ModelVersion</a>, <a href="matlab:help openminds.core.Software" style="font-weight:bold">Software</a>, <a href="matlab:help openminds.core.SoftwareVersion" style="font-weight:bold">SoftwareVersion</a>, <a href="matlab:help openminds.core.WebService" style="font-weight:bold">WebService</a>, <a href="matlab:help openminds.core.WebServiceVersion" style="font-weight:bold">WebServiceVersion</a>, <a href="matlab:help openminds.publications.LivePaper" style="font-weight:bold">LivePaper</a>, <a href="matlab:help openminds.publications.LivePaperVersion" style="font-weight:bold">LivePaperVersion</a>, <a href="matlab:help openminds.sands.BrainAtlas" style="font-weight:bold">BrainAtlas</a>, <a href="matlab:help openminds.sands.BrainAtlasVersion" style="font-weight:bold">BrainAtlasVersion</a>, <a href="matlab:help openminds.sands.CommonCoordinateSpace" style="font-weight:bold">CommonCoordinateSpace</a>, <a href="matlab:help openminds.sands.CommonCoordinateSpaceVersion" style="font-weight:bold">CommonCoordinateSpaceVersion</a>
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
            'hasPart', ["openminds.computation.ValidationTest", "openminds.computation.ValidationTestVersion", "openminds.computation.WorkflowRecipe", "openminds.computation.WorkflowRecipeVersion", "openminds.core.Dataset", "openminds.core.DatasetVersion", "openminds.core.MetaDataModel", "openminds.core.MetaDataModelVersion", "openminds.core.Model", "openminds.core.ModelVersion", "openminds.core.Software", "openminds.core.SoftwareVersion", "openminds.core.WebService", "openminds.core.WebServiceVersion", "openminds.publications.LivePaper", "openminds.publications.LivePaperVersion", "openminds.sands.BrainAtlas", "openminds.sands.BrainAtlasVersion", "openminds.sands.CommonCoordinateSpace", "openminds.sands.CommonCoordinateSpaceVersion"] ...
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
            str = '<missing name>';
        end
    end

end