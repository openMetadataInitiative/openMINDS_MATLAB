classdef DatasetVersion < openminds.abstract.Schema
%DatasetVersion - Structured information on data originating from human/animal studies or simulations (version level).
%
%   PROPERTIES:
%
%   accessibility          : (1,1) <a href="matlab:help openminds.controlledterms.ProductAccessibility" style="font-weight:bold">ProductAccessibility</a>
%                            Add the accessibility of the data for this research product version.
%
%   author                 : (1,:) <a href="matlab:help openminds.core.Organization" style="font-weight:bold">Organization</a>, <a href="matlab:help openminds.core.Person" style="font-weight:bold">Person</a>
%                            If necessary, add one or several authors (person or organization) that contributed to the production and publication of this dataset version. Note that these authors will overwrite the once provided in the dataset product this version belongs to.
%
%   copyright              : (1,1) <a href="matlab:help openminds.core.Copyright" style="font-weight:bold">Copyright</a>
%                            Add the copyright information of this research product version.
%
%   custodian              : (1,:) <a href="matlab:help openminds.core.Organization" style="font-weight:bold">Organization</a>, <a href="matlab:help openminds.core.Person" style="font-weight:bold">Person</a>
%                            Add one or several custodians (person or organization) that are responsible for this research product version.
%
%   description            : (1,1) string
%                            If necessary, enter a version specific description (abstract) for this research product version (max. 2000 characters, incl. spaces; no references). If left blank, the research product version will inherit the 'description' of it's corresponding research product.
%
%   digitalIdentifier      : (1,1) <a href="matlab:help openminds.core.DOI" style="font-weight:bold">DOI</a>
%                            Add the globally unique and persistent digital identifier of this research product version.
%
%   ethicsAssessment       : (1,1) <a href="matlab:help openminds.controlledterms.EthicsAssessment" style="font-weight:bold">EthicsAssessment</a>
%                            Add the result of the ethics assessment of this dataset version.
%
%   experimentalApproach   : (1,:) <a href="matlab:help openminds.controlledterms.ExperimentalApproach" style="font-weight:bold">ExperimentalApproach</a>
%                            Add all experimental approaches which this dataset version has deployed.
%
%   fullDocumentation      : (1,1) <a href="matlab:help openminds.core.DOI" style="font-weight:bold">DOI</a>, <a href="matlab:help openminds.core.File" style="font-weight:bold">File</a>, <a href="matlab:help openminds.core.URL" style="font-weight:bold">URL</a>
%                            Add the DOI, file or URL that points to a full documentation of this research product version.
%
%   fullName               : (1,1) string
%                            If necessary, enter a version specific descriptive full name (title) for this research product version. If left blank, the research product version will inherit the 'fullName' of it's corresponding research product.
%
%   funding                : (1,:) <a href="matlab:help openminds.core.Funding" style="font-weight:bold">Funding</a>
%                            Add all funding information of this research product version.
%
%   homepage               : (1,1) <a href="matlab:help openminds.core.URL" style="font-weight:bold">URL</a>
%                            Add the uniform resource locator (URL) to the homepage of this research product version.
%
%   howToCite              : (1,1) string
%                            Enter the preferred citation text for this research product version. Leave blank if citation text can be extracted from the assigned digital identifier.
%
%   inputData              : (1,:) <a href="matlab:help openminds.core.DOI" style="font-weight:bold">DOI</a>, <a href="matlab:help openminds.core.File" style="font-weight:bold">File</a>, <a href="matlab:help openminds.core.FileBundle" style="font-weight:bold">FileBundle</a>
%                            Add the data that was used as input for this dataset version.
%
%   isAlternativeVersionOf : (1,:) <a href="matlab:help openminds.core.DatasetVersion" style="font-weight:bold">DatasetVersion</a>
%                            Add all dataset versions that can be used alternatively to this dataset version.
%
%   isNewVersionOf         : (1,1) <a href="matlab:help openminds.core.DatasetVersion" style="font-weight:bold">DatasetVersion</a>
%                            Add the dataset version preceding this dataset version.
%
%   keyword                : (1,:) string
%                            Enter custom keywords to this research product version.
%
%   license                : (1,1) <a href="matlab:help openminds.core.License" style="font-weight:bold">License</a>
%                            Add the license for this dataset version.
%
%   otherContribution      : (1,:) <a href="matlab:help openminds.core.Contribution" style="font-weight:bold">Contribution</a>
%                            Add the contributions for each involved person or organization going beyond being an author, custodian or developer of this research product version.
%
%   protocol               : (1,:) <a href="matlab:help openminds.core.Protocol" style="font-weight:bold">Protocol</a>
%                            Add one or several protocols that were used in this dataset version.
%
%   relatedPublication     : (1,:) <a href="matlab:help openminds.core.DOI" style="font-weight:bold">DOI</a>, <a href="matlab:help openminds.core.ISBN" style="font-weight:bold">ISBN</a>
%                            Add further publications besides the documentation (e.g. an original research article) providing the original context for the production of this research product version.
%
%   releaseDate            : (1,1) datetime
%                            Enter the date (actual or intended) of the first broadcast/publication of this research product version.
%
%   repository             : (1,1) <a href="matlab:help openminds.core.FileRepository" style="font-weight:bold">FileRepository</a>
%                            Add the file repository of this research product version.
%
%   shortName              : (1,1) string
%                            Enter a short name (alias) for this research product version (max. 30 characters, no space).
%
%   studiedSpecimen        : (1,:) <a href="matlab:help openminds.core.Subject" style="font-weight:bold">Subject</a>, <a href="matlab:help openminds.core.SubjectGroup" style="font-weight:bold">SubjectGroup</a>, <a href="matlab:help openminds.core.TissueSample" style="font-weight:bold">TissueSample</a>, <a href="matlab:help openminds.core.TissueSampleCollection" style="font-weight:bold">TissueSampleCollection</a>
%                            Add one or several specimen (subjects and/or tissue samples) or specimen sets (subject groups and/or tissue sample collections) that were studied in this dataset.
%
%   supportChannel         : (1,:) string
%                            Enter all channels through which a user can receive support for handling this research product.
%
%   type                   : (1,:) <a href="matlab:help openminds.controlledterms.SemanticDataType" style="font-weight:bold">SemanticDataType</a>
%                            Add all data types (raw, derived or simulated) provided in this dataset version.
%
%   versionIdentifier      : (1,1) string
%                            Enter the version identifier of this research product version.
%
%   versionInnovation      : (1,1) string
%                            Enter a summary/description of the novelties/peculiarities of this research product version in comparison to other versions of it's research product. If this research product version is the first released version, you can enter the following disclaimer 'This is the first version of this research product.'

%   This class was auto-generated by the openMINDS pipeline

    properties
        % Add the accessibility of the data for this research product version.
        accessibility (1,:) openminds.controlledterms.ProductAccessibility ...
            {mustBeSpecifiedLength(accessibility, 0, 1)}

        % If necessary, add one or several authors (person or organization) that contributed to the production and publication of this dataset version. Note that these authors will overwrite the once provided in the dataset product this version belongs to.
        author (1,:) openminds.internal.mixedtype.datasetversion.Author ...
            {mustBeListOfUniqueItems(author)}

        % Add the copyright information of this research product version.
        copyright (1,:) openminds.core.Copyright ...
            {mustBeSpecifiedLength(copyright, 0, 1)}

        % Add one or several custodians (person or organization) that are responsible for this research product version.
        custodian (1,:) openminds.internal.mixedtype.datasetversion.Custodian ...
            {mustBeListOfUniqueItems(custodian)}

        % If necessary, enter a version specific description (abstract) for this research product version (max. 2000 characters, incl. spaces; no references). If left blank, the research product version will inherit the 'description' of it's corresponding research product.
        description (1,1) string ...
            {mustBeValidStringLength(description, 0, 2000)}

        % Add the globally unique and persistent digital identifier of this research product version.
        digitalIdentifier (1,:) openminds.core.DOI ...
            {mustBeSpecifiedLength(digitalIdentifier, 0, 1)}

        % Add the result of the ethics assessment of this dataset version.
        ethicsAssessment (1,:) openminds.controlledterms.EthicsAssessment ...
            {mustBeSpecifiedLength(ethicsAssessment, 0, 1)}

        % Add all experimental approaches which this dataset version has deployed.
        experimentalApproach (1,:) openminds.controlledterms.ExperimentalApproach ...
            {mustBeListOfUniqueItems(experimentalApproach)}

        % Add the DOI, file or URL that points to a full documentation of this research product version.
        fullDocumentation (1,:) openminds.internal.mixedtype.datasetversion.FullDocumentation ...
            {mustBeSpecifiedLength(fullDocumentation, 0, 1)}

        % If necessary, enter a version specific descriptive full name (title) for this research product version. If left blank, the research product version will inherit the 'fullName' of it's corresponding research product.
        fullName (1,1) string

        % Add all funding information of this research product version.
        funding (1,:) openminds.core.Funding ...
            {mustBeListOfUniqueItems(funding)}

        % Add the uniform resource locator (URL) to the homepage of this research product version.
        homepage (1,:) openminds.core.URL ...
            {mustBeSpecifiedLength(homepage, 0, 1)}

        % Enter the preferred citation text for this research product version. Leave blank if citation text can be extracted from the assigned digital identifier.
        howToCite (1,1) string

        % Add the data that was used as input for this dataset version.
        inputData (1,:) openminds.internal.mixedtype.datasetversion.InputData ...
            {mustBeListOfUniqueItems(inputData)}

        % Add all dataset versions that can be used alternatively to this dataset version.
        isAlternativeVersionOf (1,:) openminds.core.DatasetVersion ...
            {mustBeListOfUniqueItems(isAlternativeVersionOf)}

        % Add the dataset version preceding this dataset version.
        isNewVersionOf (1,:) openminds.core.DatasetVersion ...
            {mustBeSpecifiedLength(isNewVersionOf, 0, 1)}

        % Enter custom keywords to this research product version.
        keyword (1,:) string ...
            {mustBeSpecifiedLength(keyword, 1, 5)}

        % Add the license for this dataset version.
        license (1,:) openminds.core.License ...
            {mustBeSpecifiedLength(license, 0, 1)}

        % Add the contributions for each involved person or organization going beyond being an author, custodian or developer of this research product version.
        otherContribution (1,:) openminds.core.Contribution ...
            {mustBeListOfUniqueItems(otherContribution)}

        % Add one or several protocols that were used in this dataset version.
        protocol (1,:) openminds.core.Protocol ...
            {mustBeListOfUniqueItems(protocol)}

        % Add further publications besides the documentation (e.g. an original research article) providing the original context for the production of this research product version.
        relatedPublication (1,:) openminds.internal.mixedtype.datasetversion.RelatedPublication ...
            {mustBeListOfUniqueItems(relatedPublication)}

        % Enter the date (actual or intended) of the first broadcast/publication of this research product version.
        releaseDate (1,1) datetime

        % Add the file repository of this research product version.
        repository (1,:) openminds.core.FileRepository ...
            {mustBeSpecifiedLength(repository, 0, 1)}

        % Enter a short name (alias) for this research product version (max. 30 characters, no space).
        shortName (1,1) string ...
            {mustBeValidStringLength(shortName, 0, 30)}

        % Add one or several specimen (subjects and/or tissue samples) or specimen sets (subject groups and/or tissue sample collections) that were studied in this dataset.
        studiedSpecimen (1,:) openminds.internal.mixedtype.datasetversion.StudiedSpecimen ...
            {mustBeListOfUniqueItems(studiedSpecimen)}

        % Enter all channels through which a user can receive support for handling this research product.
        supportChannel (1,:) string ...
            {mustBeListOfUniqueItems(supportChannel)}

        % Add all data types (raw, derived or simulated) provided in this dataset version.
        type (1,:) openminds.controlledterms.SemanticDataType ...
            {mustBeListOfUniqueItems(type)}

        % Enter the version identifier of this research product version.
        versionIdentifier (1,1) string

        % Enter a summary/description of the novelties/peculiarities of this research product version in comparison to other versions of it's research product. If this research product version is the first released version, you can enter the following disclaimer 'This is the first version of this research product.'
        versionInnovation (1,1) string
    end

    properties (Access = protected)
        Required = ["accessibility", "digitalIdentifier", "ethicsAssessment", "experimentalApproach", "fullDocumentation", "funding", "license", "protocol", "releaseDate", "shortName", "type", "versionIdentifier", "versionInnovation"]
    end

    properties (Constant, Hidden)
        X_TYPE = "https://openminds.ebrains.eu/core/DatasetVersion"
    end

    properties (Constant, Hidden)
        LINKED_PROPERTIES = struct(...
            'accessibility', "openminds.controlledterms.ProductAccessibility", ...
            'author', ["openminds.core.Organization", "openminds.core.Person"], ...
            'custodian', ["openminds.core.Organization", "openminds.core.Person"], ...
            'digitalIdentifier', "openminds.core.DOI", ...
            'ethicsAssessment', "openminds.controlledterms.EthicsAssessment", ...
            'experimentalApproach', "openminds.controlledterms.ExperimentalApproach", ...
            'fullDocumentation', ["openminds.core.DOI", "openminds.core.File", "openminds.core.URL"], ...
            'funding', "openminds.core.Funding", ...
            'homepage', "openminds.core.URL", ...
            'inputData', ["openminds.core.DOI", "openminds.core.File", "openminds.core.FileBundle"], ...
            'isAlternativeVersionOf', "openminds.core.DatasetVersion", ...
            'isNewVersionOf', "openminds.core.DatasetVersion", ...
            'license', "openminds.core.License", ...
            'protocol', "openminds.core.Protocol", ...
            'relatedPublication', ["openminds.core.DOI", "openminds.core.ISBN"], ...
            'repository', "openminds.core.FileRepository", ...
            'studiedSpecimen', ["openminds.core.Subject", "openminds.core.SubjectGroup", "openminds.core.TissueSample", "openminds.core.TissueSampleCollection"], ...
            'type', "openminds.controlledterms.SemanticDataType" ...
        )
        EMBEDDED_PROPERTIES = struct(...
            'copyright', "openminds.core.Copyright", ...
            'otherContribution', "openminds.core.Contribution" ...
        )
    end

    methods
        function obj = DatasetVersion(varargin)
            obj@openminds.abstract.Schema(varargin{:})
        end
    end

    methods (Access = protected)
        function str = getDisplayLabel(obj)
            str = sprintf('%s', obj.fullName);
        end
    end

end