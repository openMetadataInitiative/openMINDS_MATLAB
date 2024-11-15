classdef Project < openminds.abstract.Schema
%Project - Structured information on a research project.
%
%   PROPERTIES:
%
%   coordinator : (1,:) <a href="matlab:help openminds.core.actors.Consortium" style="font-weight:bold">Consortium</a>, <a href="matlab:help openminds.core.actors.Organization" style="font-weight:bold">Organization</a>, <a href="matlab:help openminds.core.actors.Person" style="font-weight:bold">Person</a>
%                 Add all parties that coordinate this project.
%
%   description : (1,1) string
%                 Enter a description of this project.
%
%   fullName    : (1,1) string
%                 Enter a descriptive full name (or title) for this project.
%
%   hasPart     : (1,:) <a href="matlab:help openminds.computation.ValidationTest" style="font-weight:bold">ValidationTest</a>, <a href="matlab:help openminds.computation.ValidationTestVersion" style="font-weight:bold">ValidationTestVersion</a>, <a href="matlab:help openminds.computation.WorkflowRecipe" style="font-weight:bold">WorkflowRecipe</a>, <a href="matlab:help openminds.computation.WorkflowRecipeVersion" style="font-weight:bold">WorkflowRecipeVersion</a>, <a href="matlab:help openminds.core.products.Dataset" style="font-weight:bold">Dataset</a>, <a href="matlab:help openminds.core.products.DatasetVersion" style="font-weight:bold">DatasetVersion</a>, <a href="matlab:help openminds.core.products.MetaDataModel" style="font-weight:bold">MetaDataModel</a>, <a href="matlab:help openminds.core.products.MetaDataModelVersion" style="font-weight:bold">MetaDataModelVersion</a>, <a href="matlab:help openminds.core.products.Model" style="font-weight:bold">Model</a>, <a href="matlab:help openminds.core.products.ModelVersion" style="font-weight:bold">ModelVersion</a>, <a href="matlab:help openminds.core.products.Software" style="font-weight:bold">Software</a>, <a href="matlab:help openminds.core.products.SoftwareVersion" style="font-weight:bold">SoftwareVersion</a>, <a href="matlab:help openminds.core.products.WebService" style="font-weight:bold">WebService</a>, <a href="matlab:help openminds.core.products.WebServiceVersion" style="font-weight:bold">WebServiceVersion</a>, <a href="matlab:help openminds.publications.LivePaper" style="font-weight:bold">LivePaper</a>, <a href="matlab:help openminds.publications.LivePaperVersion" style="font-weight:bold">LivePaperVersion</a>, <a href="matlab:help openminds.sands.atlas.BrainAtlas" style="font-weight:bold">BrainAtlas</a>, <a href="matlab:help openminds.sands.atlas.BrainAtlasVersion" style="font-weight:bold">BrainAtlasVersion</a>, <a href="matlab:help openminds.sands.atlas.CommonCoordinateSpace" style="font-weight:bold">CommonCoordinateSpace</a>, <a href="matlab:help openminds.sands.atlas.CommonCoordinateSpaceVersion" style="font-weight:bold">CommonCoordinateSpaceVersion</a>
%                 Add all research product (versions) that are part of this project.
%
%   homepage    : (1,1) string
%                 Enter the internationalized resource identifier (IRI) to the homepage of this project.
%
%   shortName   : (1,1) string
%                 Enter a short name (or alias) for this project that could be used as a shortened display title (e.g., for web services with too little space to display the full name).

%   This class was auto-generated by the openMINDS pipeline

    properties
        % Add all parties that coordinate this project.
        coordinator (1,:) openminds.internal.mixedtype.project.Coordinator ...
            {mustBeListOfUniqueItems(coordinator)}

        % Enter a description of this project.
        description (1,1) string

        % Enter a descriptive full name (or title) for this project.
        fullName (1,1) string

        % Add all research product (versions) that are part of this project.
        hasPart (1,:) openminds.internal.mixedtype.project.HasPart ...
            {mustBeListOfUniqueItems(hasPart)}

        % Enter the internationalized resource identifier (IRI) to the homepage of this project.
        homepage (1,1) string

        % Enter a short name (or alias) for this project that could be used as a shortened display title (e.g., for web services with too little space to display the full name).
        shortName (1,1) string
    end

    properties (Access = protected)
        Required = ["description", "fullName", "hasPart", "shortName"]
    end

    properties (Constant, Hidden)
        X_TYPE = "https://openminds.ebrains.eu/core/Project"
    end

    properties (Constant, Hidden)
        LINKED_PROPERTIES = struct(...
            'coordinator', ["openminds.core.actors.Consortium", "openminds.core.actors.Organization", "openminds.core.actors.Person"], ...
            'hasPart', ["openminds.computation.ValidationTest", "openminds.computation.ValidationTestVersion", "openminds.computation.WorkflowRecipe", "openminds.computation.WorkflowRecipeVersion", "openminds.core.products.Dataset", "openminds.core.products.DatasetVersion", "openminds.core.products.MetaDataModel", "openminds.core.products.MetaDataModelVersion", "openminds.core.products.Model", "openminds.core.products.ModelVersion", "openminds.core.products.Software", "openminds.core.products.SoftwareVersion", "openminds.core.products.WebService", "openminds.core.products.WebServiceVersion", "openminds.publications.LivePaper", "openminds.publications.LivePaperVersion", "openminds.sands.atlas.BrainAtlas", "openminds.sands.atlas.BrainAtlasVersion", "openminds.sands.atlas.CommonCoordinateSpace", "openminds.sands.atlas.CommonCoordinateSpaceVersion"] ...
        )
        EMBEDDED_PROPERTIES = struct(...
        )
    end

    methods
        function obj = Project(varargin)
            obj@openminds.abstract.Schema(varargin{:})
        end
    end

    methods (Access = protected)
        function str = getDisplayLabel(obj)
            str = sprintf('%s', obj.fullName);
        end
    end
end