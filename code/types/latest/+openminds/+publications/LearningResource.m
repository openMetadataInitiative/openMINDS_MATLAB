classdef LearningResource < openminds.abstract.Schema
%LearningResource - No description available.
%
%   PROPERTIES:
%
%   IRI               : (1,1) string
%                       Enter the internationalized resource identifier (IRI) to this creative work.
%
%   about             : (1,:) <a href="matlab:help openminds.computation.ValidationTest" style="font-weight:bold">ValidationTest</a>, <a href="matlab:help openminds.computation.ValidationTestVersion" style="font-weight:bold">ValidationTestVersion</a>, <a href="matlab:help openminds.computation.WorkflowRecipe" style="font-weight:bold">WorkflowRecipe</a>, <a href="matlab:help openminds.computation.WorkflowRecipeVersion" style="font-weight:bold">WorkflowRecipeVersion</a>, <a href="matlab:help openminds.core.products.Dataset" style="font-weight:bold">Dataset</a>, <a href="matlab:help openminds.core.products.DatasetVersion" style="font-weight:bold">DatasetVersion</a>, <a href="matlab:help openminds.core.products.MetaDataModel" style="font-weight:bold">MetaDataModel</a>, <a href="matlab:help openminds.core.products.MetaDataModelVersion" style="font-weight:bold">MetaDataModelVersion</a>, <a href="matlab:help openminds.core.products.Model" style="font-weight:bold">Model</a>, <a href="matlab:help openminds.core.products.ModelVersion" style="font-weight:bold">ModelVersion</a>, <a href="matlab:help openminds.core.products.Software" style="font-weight:bold">Software</a>, <a href="matlab:help openminds.core.products.SoftwareVersion" style="font-weight:bold">SoftwareVersion</a>, <a href="matlab:help openminds.core.products.WebService" style="font-weight:bold">WebService</a>, <a href="matlab:help openminds.core.products.WebServiceVersion" style="font-weight:bold">WebServiceVersion</a>, <a href="matlab:help openminds.publications.LivePaper" style="font-weight:bold">LivePaper</a>, <a href="matlab:help openminds.publications.LivePaperVersion" style="font-weight:bold">LivePaperVersion</a>, <a href="matlab:help openminds.sands.atlas.BrainAtlas" style="font-weight:bold">BrainAtlas</a>, <a href="matlab:help openminds.sands.atlas.BrainAtlasVersion" style="font-weight:bold">BrainAtlasVersion</a>, <a href="matlab:help openminds.sands.atlas.CommonCoordinateSpace" style="font-weight:bold">CommonCoordinateSpace</a>, <a href="matlab:help openminds.sands.atlas.CommonCoordinateSpaceVersion" style="font-weight:bold">CommonCoordinateSpaceVersion</a>
%                       Add all research product (versions) this learning resource are about. Note that the learning resource should supplement the usage of the research product (versions) with e.g., instructions on their usage or additional information.
%
%   abstract          : (1,1) string
%                       Enter the abstract or a short description of the creative work.
%
%   author            : (1,:) <a href="matlab:help openminds.core.actors.Consortium" style="font-weight:bold">Consortium</a>, <a href="matlab:help openminds.core.actors.Organization" style="font-weight:bold">Organization</a>, <a href="matlab:help openminds.core.actors.Person" style="font-weight:bold">Person</a>
%                       Add all parties that contributed to this creative work as authors.
%
%   citedPublication  : (1,:) <a href="matlab:help openminds.core.digitalidentifier.DOI" style="font-weight:bold">DOI</a>, <a href="matlab:help openminds.core.digitalidentifier.ISBN" style="font-weight:bold">ISBN</a>
%                       Add all references this creative work cites.
%
%   copyright         : (1,1) <a href="matlab:help openminds.core.data.Copyright" style="font-weight:bold">Copyright</a>
%                       Enter the copyright information of this creative work.
%
%   creationDate      : (1,1) datetime
%                       Enter the date on which this creative work was created, formatted as '2023-02-07'.
%
%   custodian         : (1,:) <a href="matlab:help openminds.core.actors.Consortium" style="font-weight:bold">Consortium</a>, <a href="matlab:help openminds.core.actors.Organization" style="font-weight:bold">Organization</a>, <a href="matlab:help openminds.core.actors.Person" style="font-weight:bold">Person</a>
%                       Add all parties that fulfill the role of a custodian for this creative work (e.g., a corresponding author). Custodians are typically the main contact in case of misconduct, obtain permission from the contributors to publish personal information, and maintain the content and quality of the creative work.
%
%   digitalIdentifier : (1,1) <a href="matlab:help openminds.core.digitalidentifier.DOI" style="font-weight:bold">DOI</a>
%                       Add the globally unique and persistent digital identifier of this creative work.
%
%   editor            : (1,:) <a href="matlab:help openminds.core.actors.Person" style="font-weight:bold">Person</a>
%                       Add all persons that edited this creative work.
%
%   educationalLevel  : (1,1) <a href="matlab:help openminds.controlledterms.EducationalLevel" style="font-weight:bold">EducationalLevel</a>
%                       Add the educational level that best summarizes the prerequisite of this learning resource.
%
%   funding           : (1,:) <a href="matlab:help openminds.core.miscellaneous.Funding" style="font-weight:bold">Funding</a>
%                       Add all funding information of this creative work.
%
%   keyword           : (1,:) <a href="matlab:help openminds.controlledterms.ActionStatusType" style="font-weight:bold">ActionStatusType</a>, <a href="matlab:help openminds.controlledterms.AgeCategory" style="font-weight:bold">AgeCategory</a>, <a href="matlab:help openminds.controlledterms.AnalysisTechnique" style="font-weight:bold">AnalysisTechnique</a>, <a href="matlab:help openminds.controlledterms.AnatomicalAxesOrientation" style="font-weight:bold">AnatomicalAxesOrientation</a>, <a href="matlab:help openminds.controlledterms.AnatomicalIdentificationType" style="font-weight:bold">AnatomicalIdentificationType</a>, <a href="matlab:help openminds.controlledterms.AnatomicalPlane" style="font-weight:bold">AnatomicalPlane</a>, <a href="matlab:help openminds.controlledterms.AnnotationCriteriaType" style="font-weight:bold">AnnotationCriteriaType</a>, <a href="matlab:help openminds.controlledterms.AnnotationType" style="font-weight:bold">AnnotationType</a>, <a href="matlab:help openminds.controlledterms.AtlasType" style="font-weight:bold">AtlasType</a>, <a href="matlab:help openminds.controlledterms.AuditoryStimulusType" style="font-weight:bold">AuditoryStimulusType</a>, <a href="matlab:help openminds.controlledterms.BiologicalOrder" style="font-weight:bold">BiologicalOrder</a>, <a href="matlab:help openminds.controlledterms.BiologicalProcess" style="font-weight:bold">BiologicalProcess</a>, <a href="matlab:help openminds.controlledterms.BiologicalSex" style="font-weight:bold">BiologicalSex</a>, <a href="matlab:help openminds.controlledterms.BreedingType" style="font-weight:bold">BreedingType</a>, <a href="matlab:help openminds.controlledterms.CellCultureType" style="font-weight:bold">CellCultureType</a>, <a href="matlab:help openminds.controlledterms.CellType" style="font-weight:bold">CellType</a>, <a href="matlab:help openminds.controlledterms.ChemicalMixtureType" style="font-weight:bold">ChemicalMixtureType</a>, <a href="matlab:help openminds.controlledterms.Colormap" style="font-weight:bold">Colormap</a>, <a href="matlab:help openminds.controlledterms.ContributionType" style="font-weight:bold">ContributionType</a>, <a href="matlab:help openminds.controlledterms.CranialWindowConstructionType" style="font-weight:bold">CranialWindowConstructionType</a>, <a href="matlab:help openminds.controlledterms.CranialWindowReinforcementType" style="font-weight:bold">CranialWindowReinforcementType</a>, <a href="matlab:help openminds.controlledterms.CriteriaQualityType" style="font-weight:bold">CriteriaQualityType</a>, <a href="matlab:help openminds.controlledterms.DataType" style="font-weight:bold">DataType</a>, <a href="matlab:help openminds.controlledterms.DeviceType" style="font-weight:bold">DeviceType</a>, <a href="matlab:help openminds.controlledterms.DifferenceMeasure" style="font-weight:bold">DifferenceMeasure</a>, <a href="matlab:help openminds.controlledterms.Disease" style="font-weight:bold">Disease</a>, <a href="matlab:help openminds.controlledterms.DiseaseModel" style="font-weight:bold">DiseaseModel</a>, <a href="matlab:help openminds.controlledterms.EducationalLevel" style="font-weight:bold">EducationalLevel</a>, <a href="matlab:help openminds.controlledterms.ElectricalStimulusType" style="font-weight:bold">ElectricalStimulusType</a>, <a href="matlab:help openminds.controlledterms.EthicsAssessment" style="font-weight:bold">EthicsAssessment</a>, <a href="matlab:help openminds.controlledterms.ExperimentalApproach" style="font-weight:bold">ExperimentalApproach</a>, <a href="matlab:help openminds.controlledterms.FileBundleGrouping" style="font-weight:bold">FileBundleGrouping</a>, <a href="matlab:help openminds.controlledterms.FileRepositoryType" style="font-weight:bold">FileRepositoryType</a>, <a href="matlab:help openminds.controlledterms.FileUsageRole" style="font-weight:bold">FileUsageRole</a>, <a href="matlab:help openminds.controlledterms.GeneticStrainType" style="font-weight:bold">GeneticStrainType</a>, <a href="matlab:help openminds.controlledterms.GustatoryStimulusType" style="font-weight:bold">GustatoryStimulusType</a>, <a href="matlab:help openminds.controlledterms.Handedness" style="font-weight:bold">Handedness</a>, <a href="matlab:help openminds.controlledterms.Language" style="font-weight:bold">Language</a>, <a href="matlab:help openminds.controlledterms.Laterality" style="font-weight:bold">Laterality</a>, <a href="matlab:help openminds.controlledterms.LearningResourceType" style="font-weight:bold">LearningResourceType</a>, <a href="matlab:help openminds.controlledterms.MRIPulseSequence" style="font-weight:bold">MRIPulseSequence</a>, <a href="matlab:help openminds.controlledterms.MRIWeighting" style="font-weight:bold">MRIWeighting</a>, <a href="matlab:help openminds.controlledterms.MRSpatialEncoding" style="font-weight:bold">MRSpatialEncoding</a>, <a href="matlab:help openminds.controlledterms.MeasuredQuantity" style="font-weight:bold">MeasuredQuantity</a>, <a href="matlab:help openminds.controlledterms.MeasuredSignalType" style="font-weight:bold">MeasuredSignalType</a>, <a href="matlab:help openminds.controlledterms.MetaDataModelType" style="font-weight:bold">MetaDataModelType</a>, <a href="matlab:help openminds.controlledterms.ModelAbstractionLevel" style="font-weight:bold">ModelAbstractionLevel</a>, <a href="matlab:help openminds.controlledterms.ModelScope" style="font-weight:bold">ModelScope</a>, <a href="matlab:help openminds.controlledterms.MolecularEntity" style="font-weight:bold">MolecularEntity</a>, <a href="matlab:help openminds.controlledterms.OlfactoryStimulusType" style="font-weight:bold">OlfactoryStimulusType</a>, <a href="matlab:help openminds.controlledterms.OperatingDevice" style="font-weight:bold">OperatingDevice</a>, <a href="matlab:help openminds.controlledterms.OperatingSystem" style="font-weight:bold">OperatingSystem</a>, <a href="matlab:help openminds.controlledterms.OpticalStimulusType" style="font-weight:bold">OpticalStimulusType</a>, <a href="matlab:help openminds.controlledterms.Organ" style="font-weight:bold">Organ</a>, <a href="matlab:help openminds.controlledterms.OrganismSubstance" style="font-weight:bold">OrganismSubstance</a>, <a href="matlab:help openminds.controlledterms.OrganismSystem" style="font-weight:bold">OrganismSystem</a>, <a href="matlab:help openminds.controlledterms.PatchClampVariation" style="font-weight:bold">PatchClampVariation</a>, <a href="matlab:help openminds.controlledterms.PreparationType" style="font-weight:bold">PreparationType</a>, <a href="matlab:help openminds.controlledterms.ProductAccessibility" style="font-weight:bold">ProductAccessibility</a>, <a href="matlab:help openminds.controlledterms.ProgrammingLanguage" style="font-weight:bold">ProgrammingLanguage</a>, <a href="matlab:help openminds.controlledterms.QualitativeOverlap" style="font-weight:bold">QualitativeOverlap</a>, <a href="matlab:help openminds.controlledterms.SemanticDataType" style="font-weight:bold">SemanticDataType</a>, <a href="matlab:help openminds.controlledterms.Service" style="font-weight:bold">Service</a>, <a href="matlab:help openminds.controlledterms.SetupType" style="font-weight:bold">SetupType</a>, <a href="matlab:help openminds.controlledterms.SoftwareApplicationCategory" style="font-weight:bold">SoftwareApplicationCategory</a>, <a href="matlab:help openminds.controlledterms.SoftwareFeature" style="font-weight:bold">SoftwareFeature</a>, <a href="matlab:help openminds.controlledterms.Species" style="font-weight:bold">Species</a>, <a href="matlab:help openminds.controlledterms.StimulationApproach" style="font-weight:bold">StimulationApproach</a>, <a href="matlab:help openminds.controlledterms.StimulationTechnique" style="font-weight:bold">StimulationTechnique</a>, <a href="matlab:help openminds.controlledterms.SubcellularEntity" style="font-weight:bold">SubcellularEntity</a>, <a href="matlab:help openminds.controlledterms.SubjectAttribute" style="font-weight:bold">SubjectAttribute</a>, <a href="matlab:help openminds.controlledterms.TactileStimulusType" style="font-weight:bold">TactileStimulusType</a>, <a href="matlab:help openminds.controlledterms.Technique" style="font-weight:bold">Technique</a>, <a href="matlab:help openminds.controlledterms.TermSuggestion" style="font-weight:bold">TermSuggestion</a>, <a href="matlab:help openminds.controlledterms.Terminology" style="font-weight:bold">Terminology</a>, <a href="matlab:help openminds.controlledterms.TissueSampleAttribute" style="font-weight:bold">TissueSampleAttribute</a>, <a href="matlab:help openminds.controlledterms.TissueSampleType" style="font-weight:bold">TissueSampleType</a>, <a href="matlab:help openminds.controlledterms.TypeOfUncertainty" style="font-weight:bold">TypeOfUncertainty</a>, <a href="matlab:help openminds.controlledterms.UBERONParcellation" style="font-weight:bold">UBERONParcellation</a>, <a href="matlab:help openminds.controlledterms.UnitOfMeasurement" style="font-weight:bold">UnitOfMeasurement</a>, <a href="matlab:help openminds.controlledterms.VisualStimulusType" style="font-weight:bold">VisualStimulusType</a>
%                       Add all relevant keywords to this creative work either by adding controlled terms or by suggesting new terms.
%
%   learningOutcome   : (1,1) string
%                       Enter a description for the expected learning outcomes of this learning resource.
%
%   license           : (1,1) <a href="matlab:help openminds.core.data.License" style="font-weight:bold">License</a>
%                       Add the license of this creative work.
%
%   modificationDate  : (1,1) datetime
%                       Enter the date on which this creative work was last modified, formatted as '2023-02-07'.
%
%   name              : (1,1) string
%                       Enter the name (or title) of this creative work.
%
%   order             : (1,1) int64
%                       Enter the order in which this resource should appear, relative to other resources with the same topic.
%
%   prerequisite      : (1,1) string
%                       Enter any knowledge, skills, or abilities that are required to be able to use this learning resource.
%
%   publicationDate   : (1,1) datetime
%                       Enter the date on which this creative work was published, formatted as '2023-02-07'.
%
%   publisher         : (1,1) <a href="matlab:help openminds.core.actors.Consortium" style="font-weight:bold">Consortium</a>, <a href="matlab:help openminds.core.actors.Organization" style="font-weight:bold">Organization</a>, <a href="matlab:help openminds.core.actors.Person" style="font-weight:bold">Person</a>
%                       Add the party (private or commercial) that published this creative work.
%
%   requiredTime      : (1,1) <a href="matlab:help openminds.core.miscellaneous.QuantitativeValue" style="font-weight:bold">QuantitativeValue</a>, <a href="matlab:help openminds.core.miscellaneous.QuantitativeValueRange" style="font-weight:bold">QuantitativeValueRange</a>
%                       Enter the time that is required to complete this learning resource.
%
%   topic             : (1,1) string
%                       Enter the name or a short description of the aspect of the research product that is covered by this tutorial
%
%   type              : (1,1) <a href="matlab:help openminds.controlledterms.LearningResourceType" style="font-weight:bold">LearningResourceType</a>
%                       Add the type of this learning resource.
%
%   versionIdentifier : (1,1) string
%                       Enter the version identifier of this creative work.

%   This class was auto-generated by the openMINDS pipeline

    properties
        % Enter the internationalized resource identifier (IRI) to this creative work.
        IRI (1,1) string

        % Add all research product (versions) this learning resource are about. Note that the learning resource should supplement the usage of the research product (versions) with e.g., instructions on their usage or additional information.
        about (1,:) openminds.internal.mixedtype.learningresource.About ...
            {mustBeListOfUniqueItems(about)}

        % Enter the abstract or a short description of the creative work.
        abstract (1,1) string

        % Add all parties that contributed to this creative work as authors.
        author (1,:) openminds.internal.mixedtype.learningresource.Author ...
            {mustBeListOfUniqueItems(author)}

        % Add all references this creative work cites.
        citedPublication (1,:) openminds.internal.mixedtype.learningresource.CitedPublication ...
            {mustBeListOfUniqueItems(citedPublication)}

        % Enter the copyright information of this creative work.
        copyright (1,:) openminds.core.data.Copyright ...
            {mustBeSpecifiedLength(copyright, 0, 1)}

        % Enter the date on which this creative work was created, formatted as '2023-02-07'.
        creationDate (1,:) datetime ...
            {mustBeSpecifiedLength(creationDate, 0, 1), mustBeValidDate(creationDate)}

        % Add all parties that fulfill the role of a custodian for this creative work (e.g., a corresponding author). Custodians are typically the main contact in case of misconduct, obtain permission from the contributors to publish personal information, and maintain the content and quality of the creative work.
        custodian (1,:) openminds.internal.mixedtype.learningresource.Custodian ...
            {mustBeListOfUniqueItems(custodian)}

        % Add the globally unique and persistent digital identifier of this creative work.
        digitalIdentifier (1,:) openminds.core.digitalidentifier.DOI ...
            {mustBeSpecifiedLength(digitalIdentifier, 0, 1)}

        % Add all persons that edited this creative work.
        editor (1,:) openminds.core.actors.Person ...
            {mustBeListOfUniqueItems(editor)}

        % Add the educational level that best summarizes the prerequisite of this learning resource.
        educationalLevel (1,:) openminds.controlledterms.EducationalLevel ...
            {mustBeSpecifiedLength(educationalLevel, 0, 1)}

        % Add all funding information of this creative work.
        funding (1,:) openminds.core.miscellaneous.Funding ...
            {mustBeListOfUniqueItems(funding)}

        % Add all relevant keywords to this creative work either by adding controlled terms or by suggesting new terms.
        keyword (1,:) openminds.internal.mixedtype.learningresource.Keyword ...
            {mustBeListOfUniqueItems(keyword)}

        % Enter a description for the expected learning outcomes of this learning resource.
        learningOutcome (1,1) string

        % Add the license of this creative work.
        license (1,:) openminds.core.data.License ...
            {mustBeSpecifiedLength(license, 0, 1)}

        % Enter the date on which this creative work was last modified, formatted as '2023-02-07'.
        modificationDate (1,:) datetime ...
            {mustBeSpecifiedLength(modificationDate, 0, 1), mustBeValidDate(modificationDate)}

        % Enter the name (or title) of this creative work.
        name (1,1) string

        % Enter the order in which this resource should appear, relative to other resources with the same topic.
        order (1,:) int64 ...
            {mustBeSpecifiedLength(order, 0, 1)}

        % Enter any knowledge, skills, or abilities that are required to be able to use this learning resource.
        prerequisite (1,1) string

        % Enter the date on which this creative work was published, formatted as '2023-02-07'.
        publicationDate (1,:) datetime ...
            {mustBeSpecifiedLength(publicationDate, 0, 1), mustBeValidDate(publicationDate)}

        % Add the party (private or commercial) that published this creative work.
        publisher (1,:) openminds.internal.mixedtype.learningresource.Publisher ...
            {mustBeSpecifiedLength(publisher, 0, 1)}

        % Enter the time that is required to complete this learning resource.
        requiredTime (1,:) openminds.internal.mixedtype.learningresource.RequiredTime ...
            {mustBeSpecifiedLength(requiredTime, 0, 1)}

        % Enter the name or a short description of the aspect of the research product that is covered by this tutorial
        topic (1,1) string

        % Add the type of this learning resource.
        type (1,:) openminds.controlledterms.LearningResourceType ...
            {mustBeSpecifiedLength(type, 0, 1)}

        % Enter the version identifier of this creative work.
        versionIdentifier (1,1) string
    end

    properties (Access = protected)
        Required = ["about", "name", "publicationDate"]
    end

    properties (Constant, Hidden)
        X_TYPE = "https://openminds.om-i.org/types/LearningResource"
    end

    properties (Constant, Hidden)
        LINKED_PROPERTIES = struct(...
            'about', ["openminds.computation.ValidationTest", "openminds.computation.ValidationTestVersion", "openminds.computation.WorkflowRecipe", "openminds.computation.WorkflowRecipeVersion", "openminds.core.products.Dataset", "openminds.core.products.DatasetVersion", "openminds.core.products.MetaDataModel", "openminds.core.products.MetaDataModelVersion", "openminds.core.products.Model", "openminds.core.products.ModelVersion", "openminds.core.products.Software", "openminds.core.products.SoftwareVersion", "openminds.core.products.WebService", "openminds.core.products.WebServiceVersion", "openminds.publications.LivePaper", "openminds.publications.LivePaperVersion", "openminds.sands.atlas.BrainAtlas", "openminds.sands.atlas.BrainAtlasVersion", "openminds.sands.atlas.CommonCoordinateSpace", "openminds.sands.atlas.CommonCoordinateSpaceVersion"], ...
            'author', ["openminds.core.actors.Consortium", "openminds.core.actors.Organization", "openminds.core.actors.Person"], ...
            'citedPublication', ["openminds.core.digitalidentifier.DOI", "openminds.core.digitalidentifier.ISBN"], ...
            'custodian', ["openminds.core.actors.Consortium", "openminds.core.actors.Organization", "openminds.core.actors.Person"], ...
            'digitalIdentifier', "openminds.core.digitalidentifier.DOI", ...
            'editor', "openminds.core.actors.Person", ...
            'educationalLevel', "openminds.controlledterms.EducationalLevel", ...
            'funding', "openminds.core.miscellaneous.Funding", ...
            'keyword', ["openminds.controlledterms.ActionStatusType", "openminds.controlledterms.AgeCategory", "openminds.controlledterms.AnalysisTechnique", "openminds.controlledterms.AnatomicalAxesOrientation", "openminds.controlledterms.AnatomicalIdentificationType", "openminds.controlledterms.AnatomicalPlane", "openminds.controlledterms.AnnotationCriteriaType", "openminds.controlledterms.AnnotationType", "openminds.controlledterms.AtlasType", "openminds.controlledterms.AuditoryStimulusType", "openminds.controlledterms.BiologicalOrder", "openminds.controlledterms.BiologicalProcess", "openminds.controlledterms.BiologicalSex", "openminds.controlledterms.BreedingType", "openminds.controlledterms.CellCultureType", "openminds.controlledterms.CellType", "openminds.controlledterms.ChemicalMixtureType", "openminds.controlledterms.Colormap", "openminds.controlledterms.ContributionType", "openminds.controlledterms.CranialWindowConstructionType", "openminds.controlledterms.CranialWindowReinforcementType", "openminds.controlledterms.CriteriaQualityType", "openminds.controlledterms.DataType", "openminds.controlledterms.DeviceType", "openminds.controlledterms.DifferenceMeasure", "openminds.controlledterms.Disease", "openminds.controlledterms.DiseaseModel", "openminds.controlledterms.EducationalLevel", "openminds.controlledterms.ElectricalStimulusType", "openminds.controlledterms.EthicsAssessment", "openminds.controlledterms.ExperimentalApproach", "openminds.controlledterms.FileBundleGrouping", "openminds.controlledterms.FileRepositoryType", "openminds.controlledterms.FileUsageRole", "openminds.controlledterms.GeneticStrainType", "openminds.controlledterms.GustatoryStimulusType", "openminds.controlledterms.Handedness", "openminds.controlledterms.Language", "openminds.controlledterms.Laterality", "openminds.controlledterms.LearningResourceType", "openminds.controlledterms.MRIPulseSequence", "openminds.controlledterms.MRIWeighting", "openminds.controlledterms.MRSpatialEncoding", "openminds.controlledterms.MeasuredQuantity", "openminds.controlledterms.MeasuredSignalType", "openminds.controlledterms.MetaDataModelType", "openminds.controlledterms.ModelAbstractionLevel", "openminds.controlledterms.ModelScope", "openminds.controlledterms.MolecularEntity", "openminds.controlledterms.OlfactoryStimulusType", "openminds.controlledterms.OperatingDevice", "openminds.controlledterms.OperatingSystem", "openminds.controlledterms.OpticalStimulusType", "openminds.controlledterms.Organ", "openminds.controlledterms.OrganismSubstance", "openminds.controlledterms.OrganismSystem", "openminds.controlledterms.PatchClampVariation", "openminds.controlledterms.PreparationType", "openminds.controlledterms.ProductAccessibility", "openminds.controlledterms.ProgrammingLanguage", "openminds.controlledterms.QualitativeOverlap", "openminds.controlledterms.SemanticDataType", "openminds.controlledterms.Service", "openminds.controlledterms.SetupType", "openminds.controlledterms.SoftwareApplicationCategory", "openminds.controlledterms.SoftwareFeature", "openminds.controlledterms.Species", "openminds.controlledterms.StimulationApproach", "openminds.controlledterms.StimulationTechnique", "openminds.controlledterms.SubcellularEntity", "openminds.controlledterms.SubjectAttribute", "openminds.controlledterms.TactileStimulusType", "openminds.controlledterms.Technique", "openminds.controlledterms.TermSuggestion", "openminds.controlledterms.Terminology", "openminds.controlledterms.TissueSampleAttribute", "openminds.controlledterms.TissueSampleType", "openminds.controlledterms.TypeOfUncertainty", "openminds.controlledterms.UBERONParcellation", "openminds.controlledterms.UnitOfMeasurement", "openminds.controlledterms.VisualStimulusType"], ...
            'license', "openminds.core.data.License", ...
            'publisher', ["openminds.core.actors.Consortium", "openminds.core.actors.Organization", "openminds.core.actors.Person"], ...
            'type', "openminds.controlledterms.LearningResourceType" ...
        )
        EMBEDDED_PROPERTIES = struct(...
            'copyright', "openminds.core.data.Copyright", ...
            'requiredTime', ["openminds.core.miscellaneous.QuantitativeValue", "openminds.core.miscellaneous.QuantitativeValueRange"] ...
        )
    end

    methods
        function obj = LearningResource(structInstance, propValues)
            arguments
                structInstance (1,:) struct = struct.empty
                propValues.?openminds.publications.LearningResource
                propValues.id (1,1) string
            end
            propValues = namedargs2cell(propValues);
            obj@openminds.abstract.Schema(structInstance, propValues{:})
        end
    end

    methods (Access = protected)
        function str = getDisplayLabel(obj)
            str = obj.name;
        end
    end
end
