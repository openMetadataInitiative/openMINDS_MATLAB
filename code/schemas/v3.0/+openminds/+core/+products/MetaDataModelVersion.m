classdef MetaDataModelVersion < openminds.abstract.Schema
%MetaDataModelVersion - No description available.
%
%   PROPERTIES:
%
%   accessibility          : (1,1) <a href="matlab:help openminds.controlledterms.ProductAccessibility" style="font-weight:bold">ProductAccessibility</a>
%                            Add the accessibility of the data for this research product version.
%
%   copyright              : (1,1) <a href="matlab:help openminds.core.Copyright" style="font-weight:bold">Copyright</a>
%                            Enter the copyright information of this research product version.
%
%   custodian              : (1,:) <a href="matlab:help openminds.core.Consortium" style="font-weight:bold">Consortium</a>, <a href="matlab:help openminds.core.Organization" style="font-weight:bold">Organization</a>, <a href="matlab:help openminds.core.Person" style="font-weight:bold">Person</a>
%                            Add all parties that fulfill the role of a custodian for the research product version (e.g., a research group leader or principle investigator). Custodians are typically the main contact in case of misconduct, obtain permission from the contributors to publish personal information, and maintain the content and quality of the data, metadata, and/or code of the research product version.
%
%   description            : (1,1) string
%                            Enter a description (or abstract) of this research product version. Note that this version specific description will overwrite the description for the overarching dataset.
%
%   developer              : (1,:) <a href="matlab:help openminds.core.Consortium" style="font-weight:bold">Consortium</a>, <a href="matlab:help openminds.core.Organization" style="font-weight:bold">Organization</a>, <a href="matlab:help openminds.core.Person" style="font-weight:bold">Person</a>
%                            Add all parties that developed this (meta)data model version. Note that these developers will overwrite the developer list provided for the overarching (meta)data model.
%
%   digitalIdentifier      : (1,1) <a href="matlab:help openminds.core.DOI" style="font-weight:bold">DOI</a>, <a href="matlab:help openminds.core.SWHID" style="font-weight:bold">SWHID</a>
%                            Add the globally unique and persistent digital identifier of this research product version.
%
%   fullDocumentation      : (1,1) <a href="matlab:help openminds.core.DOI" style="font-weight:bold">DOI</a>, <a href="matlab:help openminds.core.File" style="font-weight:bold">File</a>, <a href="matlab:help openminds.core.WebResource" style="font-weight:bold">WebResource</a>
%                            Add the publication or file that acts as the full documentation of this research product version.
%
%   fullName               : (1,1) string
%                            Enter a descriptive full name (or title) for this research product version. Note that this version specific full name will overwrite the full name for the overarching dataset.
%
%   funding                : (1,:) <a href="matlab:help openminds.core.Funding" style="font-weight:bold">Funding</a>
%                            Add all funding information of this research product version.
%
%   homepage               : (1,1) string
%                            Enter the internationalized resource identifier (IRI) to the homepage of this research product version.
%
%   howToCite              : (1,1) string
%                            Enter the preferred citation text for this research product version. Leave blank if citation text can be extracted from the assigned digital identifier.
%
%   isAlternativeVersionOf : (1,:) <a href="matlab:help openminds.core.MetaDataModelVersion" style="font-weight:bold">MetaDataModelVersion</a>
%                            Add all (meta)data model versions that can be used alternatively to this (meta)data model version.
%
%   isNewVersionOf         : (1,1) <a href="matlab:help openminds.core.MetaDataModelVersion" style="font-weight:bold">MetaDataModelVersion</a>
%                            Add the (meta)data version preceding this (meta)data model version.
%
%   keyword                : (1,:) <a href="matlab:help openminds.controlledterms.ActionStatusType" style="font-weight:bold">ActionStatusType</a>, <a href="matlab:help openminds.controlledterms.AgeCategory" style="font-weight:bold">AgeCategory</a>, <a href="matlab:help openminds.controlledterms.AnalysisTechnique" style="font-weight:bold">AnalysisTechnique</a>, <a href="matlab:help openminds.controlledterms.AnatomicalAxesOrientation" style="font-weight:bold">AnatomicalAxesOrientation</a>, <a href="matlab:help openminds.controlledterms.AnatomicalIdentificationType" style="font-weight:bold">AnatomicalIdentificationType</a>, <a href="matlab:help openminds.controlledterms.AnatomicalPlane" style="font-weight:bold">AnatomicalPlane</a>, <a href="matlab:help openminds.controlledterms.AnnotationCriteriaType" style="font-weight:bold">AnnotationCriteriaType</a>, <a href="matlab:help openminds.controlledterms.AnnotationType" style="font-weight:bold">AnnotationType</a>, <a href="matlab:help openminds.controlledterms.AtlasType" style="font-weight:bold">AtlasType</a>, <a href="matlab:help openminds.controlledterms.AuditoryStimulusType" style="font-weight:bold">AuditoryStimulusType</a>, <a href="matlab:help openminds.controlledterms.BiologicalOrder" style="font-weight:bold">BiologicalOrder</a>, <a href="matlab:help openminds.controlledterms.BiologicalProcess" style="font-weight:bold">BiologicalProcess</a>, <a href="matlab:help openminds.controlledterms.BiologicalSex" style="font-weight:bold">BiologicalSex</a>, <a href="matlab:help openminds.controlledterms.BreedingType" style="font-weight:bold">BreedingType</a>, <a href="matlab:help openminds.controlledterms.CellCultureType" style="font-weight:bold">CellCultureType</a>, <a href="matlab:help openminds.controlledterms.CellType" style="font-weight:bold">CellType</a>, <a href="matlab:help openminds.controlledterms.ChemicalMixtureType" style="font-weight:bold">ChemicalMixtureType</a>, <a href="matlab:help openminds.controlledterms.Colormap" style="font-weight:bold">Colormap</a>, <a href="matlab:help openminds.controlledterms.ContributionType" style="font-weight:bold">ContributionType</a>, <a href="matlab:help openminds.controlledterms.CranialWindowConstructionType" style="font-weight:bold">CranialWindowConstructionType</a>, <a href="matlab:help openminds.controlledterms.CranialWindowReinforcementType" style="font-weight:bold">CranialWindowReinforcementType</a>, <a href="matlab:help openminds.controlledterms.CriteriaQualityType" style="font-weight:bold">CriteriaQualityType</a>, <a href="matlab:help openminds.controlledterms.DataType" style="font-weight:bold">DataType</a>, <a href="matlab:help openminds.controlledterms.DeviceType" style="font-weight:bold">DeviceType</a>, <a href="matlab:help openminds.controlledterms.DifferenceMeasure" style="font-weight:bold">DifferenceMeasure</a>, <a href="matlab:help openminds.controlledterms.Disease" style="font-weight:bold">Disease</a>, <a href="matlab:help openminds.controlledterms.DiseaseModel" style="font-weight:bold">DiseaseModel</a>, <a href="matlab:help openminds.controlledterms.EducationalLevel" style="font-weight:bold">EducationalLevel</a>, <a href="matlab:help openminds.controlledterms.ElectricalStimulusType" style="font-weight:bold">ElectricalStimulusType</a>, <a href="matlab:help openminds.controlledterms.EthicsAssessment" style="font-weight:bold">EthicsAssessment</a>, <a href="matlab:help openminds.controlledterms.ExperimentalApproach" style="font-weight:bold">ExperimentalApproach</a>, <a href="matlab:help openminds.controlledterms.FileBundleGrouping" style="font-weight:bold">FileBundleGrouping</a>, <a href="matlab:help openminds.controlledterms.FileRepositoryType" style="font-weight:bold">FileRepositoryType</a>, <a href="matlab:help openminds.controlledterms.FileUsageRole" style="font-weight:bold">FileUsageRole</a>, <a href="matlab:help openminds.controlledterms.GeneticStrainType" style="font-weight:bold">GeneticStrainType</a>, <a href="matlab:help openminds.controlledterms.GustatoryStimulusType" style="font-weight:bold">GustatoryStimulusType</a>, <a href="matlab:help openminds.controlledterms.Handedness" style="font-weight:bold">Handedness</a>, <a href="matlab:help openminds.controlledterms.Language" style="font-weight:bold">Language</a>, <a href="matlab:help openminds.controlledterms.Laterality" style="font-weight:bold">Laterality</a>, <a href="matlab:help openminds.controlledterms.LearningResourceType" style="font-weight:bold">LearningResourceType</a>, <a href="matlab:help openminds.controlledterms.MeasuredQuantity" style="font-weight:bold">MeasuredQuantity</a>, <a href="matlab:help openminds.controlledterms.MeasuredSignalType" style="font-weight:bold">MeasuredSignalType</a>, <a href="matlab:help openminds.controlledterms.MetaDataModelType" style="font-weight:bold">MetaDataModelType</a>, <a href="matlab:help openminds.controlledterms.ModelAbstractionLevel" style="font-weight:bold">ModelAbstractionLevel</a>, <a href="matlab:help openminds.controlledterms.ModelScope" style="font-weight:bold">ModelScope</a>, <a href="matlab:help openminds.controlledterms.MolecularEntity" style="font-weight:bold">MolecularEntity</a>, <a href="matlab:help openminds.controlledterms.OlfactoryStimulusType" style="font-weight:bold">OlfactoryStimulusType</a>, <a href="matlab:help openminds.controlledterms.OperatingDevice" style="font-weight:bold">OperatingDevice</a>, <a href="matlab:help openminds.controlledterms.OperatingSystem" style="font-weight:bold">OperatingSystem</a>, <a href="matlab:help openminds.controlledterms.OpticalStimulusType" style="font-weight:bold">OpticalStimulusType</a>, <a href="matlab:help openminds.controlledterms.Organ" style="font-weight:bold">Organ</a>, <a href="matlab:help openminds.controlledterms.OrganismSubstance" style="font-weight:bold">OrganismSubstance</a>, <a href="matlab:help openminds.controlledterms.OrganismSystem" style="font-weight:bold">OrganismSystem</a>, <a href="matlab:help openminds.controlledterms.PatchClampVariation" style="font-weight:bold">PatchClampVariation</a>, <a href="matlab:help openminds.controlledterms.PreparationType" style="font-weight:bold">PreparationType</a>, <a href="matlab:help openminds.controlledterms.ProductAccessibility" style="font-weight:bold">ProductAccessibility</a>, <a href="matlab:help openminds.controlledterms.ProgrammingLanguage" style="font-weight:bold">ProgrammingLanguage</a>, <a href="matlab:help openminds.controlledterms.QualitativeOverlap" style="font-weight:bold">QualitativeOverlap</a>, <a href="matlab:help openminds.controlledterms.SemanticDataType" style="font-weight:bold">SemanticDataType</a>, <a href="matlab:help openminds.controlledterms.Service" style="font-weight:bold">Service</a>, <a href="matlab:help openminds.controlledterms.SetupType" style="font-weight:bold">SetupType</a>, <a href="matlab:help openminds.controlledterms.SoftwareApplicationCategory" style="font-weight:bold">SoftwareApplicationCategory</a>, <a href="matlab:help openminds.controlledterms.SoftwareFeature" style="font-weight:bold">SoftwareFeature</a>, <a href="matlab:help openminds.controlledterms.Species" style="font-weight:bold">Species</a>, <a href="matlab:help openminds.controlledterms.StimulationApproach" style="font-weight:bold">StimulationApproach</a>, <a href="matlab:help openminds.controlledterms.StimulationTechnique" style="font-weight:bold">StimulationTechnique</a>, <a href="matlab:help openminds.controlledterms.SubcellularEntity" style="font-weight:bold">SubcellularEntity</a>, <a href="matlab:help openminds.controlledterms.SubjectAttribute" style="font-weight:bold">SubjectAttribute</a>, <a href="matlab:help openminds.controlledterms.TactileStimulusType" style="font-weight:bold">TactileStimulusType</a>, <a href="matlab:help openminds.controlledterms.Technique" style="font-weight:bold">Technique</a>, <a href="matlab:help openminds.controlledterms.TermSuggestion" style="font-weight:bold">TermSuggestion</a>, <a href="matlab:help openminds.controlledterms.Terminology" style="font-weight:bold">Terminology</a>, <a href="matlab:help openminds.controlledterms.TissueSampleAttribute" style="font-weight:bold">TissueSampleAttribute</a>, <a href="matlab:help openminds.controlledterms.TissueSampleType" style="font-weight:bold">TissueSampleType</a>, <a href="matlab:help openminds.controlledterms.TypeOfUncertainty" style="font-weight:bold">TypeOfUncertainty</a>, <a href="matlab:help openminds.controlledterms.UBERONParcellation" style="font-weight:bold">UBERONParcellation</a>, <a href="matlab:help openminds.controlledterms.UnitOfMeasurement" style="font-weight:bold">UnitOfMeasurement</a>, <a href="matlab:help openminds.controlledterms.VisualStimulusType" style="font-weight:bold">VisualStimulusType</a>
%                            Add all relevant keywords to this research product version either by adding controlled terms or by suggesting new terms.
%
%   license                : (1,1) <a href="matlab:help openminds.core.License" style="font-weight:bold">License</a>
%                            Add the license of this (meta)data model version.
%
%   otherContribution      : (1,:) <a href="matlab:help openminds.core.Contribution" style="font-weight:bold">Contribution</a>
%                            Add any other contributions to this research product version that are not covered under 'author'/'developer' or 'custodian'.
%
%   relatedPublication     : (1,:) <a href="matlab:help openminds.core.DOI" style="font-weight:bold">DOI</a>, <a href="matlab:help openminds.core.HANDLE" style="font-weight:bold">HANDLE</a>, <a href="matlab:help openminds.core.ISBN" style="font-weight:bold">ISBN</a>, <a href="matlab:help openminds.core.ISSN" style="font-weight:bold">ISSN</a>, <a href="matlab:help openminds.publications.Book" style="font-weight:bold">Book</a>, <a href="matlab:help openminds.publications.Chapter" style="font-weight:bold">Chapter</a>, <a href="matlab:help openminds.publications.ScholarlyArticle" style="font-weight:bold">ScholarlyArticle</a>
%                            Add all further publications besides the full documentation that provide the original context for the production of this research product version (e.g., an original research article that used or produced the data of this research product version).
%
%   releaseDate            : (1,1) datetime
%                            Enter the date (actual or intended) on which this research product version was first release, formatted as 'YYYY-MM-DD'.
%
%   repository             : (1,1) <a href="matlab:help openminds.core.FileRepository" style="font-weight:bold">FileRepository</a>
%                            Add the file repository of this research product version.
%
%   serializationFormat    : (1,:) <a href="matlab:help openminds.core.ContentType" style="font-weight:bold">ContentType</a>
%                            Add all content types in which (meta)data compliant with this (meta)data model version can be stored in.
%
%   shortName              : (1,1) string
%                            Enter a short name (or alias) for this research product version that could be used as a shortened display title (e.g., for web services with too little space to display the full name).
%
%   specificationFormat    : (1,:) <a href="matlab:help openminds.core.ContentType" style="font-weight:bold">ContentType</a>
%                            Add all content types in which the schemas of this (meta)data model version are stored in.
%
%   supportChannel         : (1,:) string
%                            Enter all channels through which a user can receive support for handling this research product version.
%
%   type                   : (1,1) <a href="matlab:help openminds.controlledterms.MetaDataModelType" style="font-weight:bold">MetaDataModelType</a>
%                            Add the type of this (meta)data model version.
%
%   versionIdentifier      : (1,1) string
%                            Enter the version identifier of this research product version.
%
%   versionInnovation      : (1,1) string
%                            Enter a short description (or summary) of the novelties/peculiarities of this research product version in comparison to its preceding versions. If this research product version is the first version, you can enter the following disclaimer 'This is the first version of this research product'.

%   This class was auto-generated by the openMINDS pipeline

    properties
        % Add the accessibility of the data for this research product version.
        accessibility (1,:) openminds.controlledterms.ProductAccessibility ...
            {mustBeSpecifiedLength(accessibility, 0, 1)}

        % Enter the copyright information of this research product version.
        copyright (1,:) openminds.core.Copyright ...
            {mustBeSpecifiedLength(copyright, 0, 1)}

        % Add all parties that fulfill the role of a custodian for the research product version (e.g., a research group leader or principle investigator). Custodians are typically the main contact in case of misconduct, obtain permission from the contributors to publish personal information, and maintain the content and quality of the data, metadata, and/or code of the research product version.
        custodian (1,:) openminds.internal.mixedtype.metadatamodelversion.Custodian ...
            {mustBeListOfUniqueItems(custodian)}

        % Enter a description (or abstract) of this research product version. Note that this version specific description will overwrite the description for the overarching dataset.
        description (1,1) string

        % Add all parties that developed this (meta)data model version. Note that these developers will overwrite the developer list provided for the overarching (meta)data model.
        developer (1,:) openminds.internal.mixedtype.metadatamodelversion.Developer ...
            {mustBeListOfUniqueItems(developer)}

        % Add the globally unique and persistent digital identifier of this research product version.
        digitalIdentifier (1,:) openminds.internal.mixedtype.metadatamodelversion.DigitalIdentifier ...
            {mustBeSpecifiedLength(digitalIdentifier, 0, 1)}

        % Add the publication or file that acts as the full documentation of this research product version.
        fullDocumentation (1,:) openminds.internal.mixedtype.metadatamodelversion.FullDocumentation ...
            {mustBeSpecifiedLength(fullDocumentation, 0, 1)}

        % Enter a descriptive full name (or title) for this research product version. Note that this version specific full name will overwrite the full name for the overarching dataset.
        fullName (1,1) string

        % Add all funding information of this research product version.
        funding (1,:) openminds.core.Funding ...
            {mustBeListOfUniqueItems(funding)}

        % Enter the internationalized resource identifier (IRI) to the homepage of this research product version.
        homepage (1,1) string

        % Enter the preferred citation text for this research product version. Leave blank if citation text can be extracted from the assigned digital identifier.
        howToCite (1,1) string

        % Add all (meta)data model versions that can be used alternatively to this (meta)data model version.
        isAlternativeVersionOf (1,:) openminds.core.MetaDataModelVersion ...
            {mustBeListOfUniqueItems(isAlternativeVersionOf)}

        % Add the (meta)data version preceding this (meta)data model version.
        isNewVersionOf (1,:) openminds.core.MetaDataModelVersion ...
            {mustBeSpecifiedLength(isNewVersionOf, 0, 1)}

        % Add all relevant keywords to this research product version either by adding controlled terms or by suggesting new terms.
        keyword (1,:) openminds.internal.mixedtype.metadatamodelversion.Keyword ...
            {mustBeListOfUniqueItems(keyword)}

        % Add the license of this (meta)data model version.
        license (1,:) openminds.core.License ...
            {mustBeSpecifiedLength(license, 0, 1)}

        % Add any other contributions to this research product version that are not covered under 'author'/'developer' or 'custodian'.
        otherContribution (1,:) openminds.core.Contribution ...
            {mustBeListOfUniqueItems(otherContribution)}

        % Add all further publications besides the full documentation that provide the original context for the production of this research product version (e.g., an original research article that used or produced the data of this research product version).
        relatedPublication (1,:) openminds.internal.mixedtype.metadatamodelversion.RelatedPublication ...
            {mustBeListOfUniqueItems(relatedPublication)}

        % Enter the date (actual or intended) on which this research product version was first release, formatted as 'YYYY-MM-DD'.
        releaseDate (1,:) datetime ...
            {mustBeSpecifiedLength(releaseDate, 0, 1), mustBeValidDate(releaseDate)}

        % Add the file repository of this research product version.
        repository (1,:) openminds.core.FileRepository ...
            {mustBeSpecifiedLength(repository, 0, 1)}

        % Add all content types in which (meta)data compliant with this (meta)data model version can be stored in.
        serializationFormat (1,:) openminds.core.ContentType ...
            {mustBeListOfUniqueItems(serializationFormat)}

        % Enter a short name (or alias) for this research product version that could be used as a shortened display title (e.g., for web services with too little space to display the full name).
        shortName (1,1) string

        % Add all content types in which the schemas of this (meta)data model version are stored in.
        specificationFormat (1,:) openminds.core.ContentType ...
            {mustBeListOfUniqueItems(specificationFormat)}

        % Enter all channels through which a user can receive support for handling this research product version.
        supportChannel (1,:) string ...
            {mustBeListOfUniqueItems(supportChannel)}

        % Add the type of this (meta)data model version.
        type (1,:) openminds.controlledterms.MetaDataModelType ...
            {mustBeSpecifiedLength(type, 0, 1)}

        % Enter the version identifier of this research product version.
        versionIdentifier (1,1) string

        % Enter a short description (or summary) of the novelties/peculiarities of this research product version in comparison to its preceding versions. If this research product version is the first version, you can enter the following disclaimer 'This is the first version of this research product'.
        versionInnovation (1,1) string
    end

    properties (Access = protected)
        Required = ["accessibility", "fullDocumentation", "license", "releaseDate", "shortName", "type", "versionIdentifier", "versionInnovation"]
    end

    properties (Constant, Hidden)
        X_TYPE = "https://openminds.ebrains.eu/core/MetaDataModelVersion"
    end

    properties (Constant, Hidden)
        LINKED_PROPERTIES = struct(...
            'accessibility', "openminds.controlledterms.ProductAccessibility", ...
            'custodian', ["openminds.core.Consortium", "openminds.core.Organization", "openminds.core.Person"], ...
            'developer', ["openminds.core.Consortium", "openminds.core.Organization", "openminds.core.Person"], ...
            'digitalIdentifier', ["openminds.core.DOI", "openminds.core.SWHID"], ...
            'fullDocumentation', ["openminds.core.DOI", "openminds.core.File", "openminds.core.WebResource"], ...
            'funding', "openminds.core.Funding", ...
            'isAlternativeVersionOf', "openminds.core.MetaDataModelVersion", ...
            'isNewVersionOf', "openminds.core.MetaDataModelVersion", ...
            'keyword', ["openminds.controlledterms.ActionStatusType", "openminds.controlledterms.AgeCategory", "openminds.controlledterms.AnalysisTechnique", "openminds.controlledterms.AnatomicalAxesOrientation", "openminds.controlledterms.AnatomicalIdentificationType", "openminds.controlledterms.AnatomicalPlane", "openminds.controlledterms.AnnotationCriteriaType", "openminds.controlledterms.AnnotationType", "openminds.controlledterms.AtlasType", "openminds.controlledterms.AuditoryStimulusType", "openminds.controlledterms.BiologicalOrder", "openminds.controlledterms.BiologicalProcess", "openminds.controlledterms.BiologicalSex", "openminds.controlledterms.BreedingType", "openminds.controlledterms.CellCultureType", "openminds.controlledterms.CellType", "openminds.controlledterms.ChemicalMixtureType", "openminds.controlledterms.Colormap", "openminds.controlledterms.ContributionType", "openminds.controlledterms.CranialWindowConstructionType", "openminds.controlledterms.CranialWindowReinforcementType", "openminds.controlledterms.CriteriaQualityType", "openminds.controlledterms.DataType", "openminds.controlledterms.DeviceType", "openminds.controlledterms.DifferenceMeasure", "openminds.controlledterms.Disease", "openminds.controlledterms.DiseaseModel", "openminds.controlledterms.EducationalLevel", "openminds.controlledterms.ElectricalStimulusType", "openminds.controlledterms.EthicsAssessment", "openminds.controlledterms.ExperimentalApproach", "openminds.controlledterms.FileBundleGrouping", "openminds.controlledterms.FileRepositoryType", "openminds.controlledterms.FileUsageRole", "openminds.controlledterms.GeneticStrainType", "openminds.controlledterms.GustatoryStimulusType", "openminds.controlledterms.Handedness", "openminds.controlledterms.Language", "openminds.controlledterms.Laterality", "openminds.controlledterms.LearningResourceType", "openminds.controlledterms.MeasuredQuantity", "openminds.controlledterms.MeasuredSignalType", "openminds.controlledterms.MetaDataModelType", "openminds.controlledterms.ModelAbstractionLevel", "openminds.controlledterms.ModelScope", "openminds.controlledterms.MolecularEntity", "openminds.controlledterms.OlfactoryStimulusType", "openminds.controlledterms.OperatingDevice", "openminds.controlledterms.OperatingSystem", "openminds.controlledterms.OpticalStimulusType", "openminds.controlledterms.Organ", "openminds.controlledterms.OrganismSubstance", "openminds.controlledterms.OrganismSystem", "openminds.controlledterms.PatchClampVariation", "openminds.controlledterms.PreparationType", "openminds.controlledterms.ProductAccessibility", "openminds.controlledterms.ProgrammingLanguage", "openminds.controlledterms.QualitativeOverlap", "openminds.controlledterms.SemanticDataType", "openminds.controlledterms.Service", "openminds.controlledterms.SetupType", "openminds.controlledterms.SoftwareApplicationCategory", "openminds.controlledterms.SoftwareFeature", "openminds.controlledterms.Species", "openminds.controlledterms.StimulationApproach", "openminds.controlledterms.StimulationTechnique", "openminds.controlledterms.SubcellularEntity", "openminds.controlledterms.SubjectAttribute", "openminds.controlledterms.TactileStimulusType", "openminds.controlledterms.Technique", "openminds.controlledterms.TermSuggestion", "openminds.controlledterms.Terminology", "openminds.controlledterms.TissueSampleAttribute", "openminds.controlledterms.TissueSampleType", "openminds.controlledterms.TypeOfUncertainty", "openminds.controlledterms.UBERONParcellation", "openminds.controlledterms.UnitOfMeasurement", "openminds.controlledterms.VisualStimulusType"], ...
            'license', "openminds.core.License", ...
            'relatedPublication', ["openminds.core.DOI", "openminds.core.HANDLE", "openminds.core.ISBN", "openminds.core.ISSN", "openminds.publications.Book", "openminds.publications.Chapter", "openminds.publications.ScholarlyArticle"], ...
            'repository', "openminds.core.FileRepository", ...
            'serializationFormat', "openminds.core.ContentType", ...
            'specificationFormat', "openminds.core.ContentType", ...
            'type', "openminds.controlledterms.MetaDataModelType" ...
        )
        EMBEDDED_PROPERTIES = struct(...
            'copyright', "openminds.core.Copyright", ...
            'otherContribution', "openminds.core.Contribution" ...
        )
    end

    methods
        function obj = MetaDataModelVersion(varargin)
            obj@openminds.abstract.Schema(varargin{:})
        end
    end

    methods (Access = protected)
        function str = getDisplayLabel(obj)
            str = sprintf('%s', obj.fullName);
        end
    end

end