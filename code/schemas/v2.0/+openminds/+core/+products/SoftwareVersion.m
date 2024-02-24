classdef SoftwareVersion < openminds.abstract.Schema
%SoftwareVersion - No description available.
%
%   PROPERTIES:
%
%   accessibility          : (1,1) <a href="matlab:help openminds.controlledterms.ProductAccessibility" style="font-weight:bold">ProductAccessibility</a>
%                            Add the accessibility of the data for this research product version.
%
%   applicationCategory    : (1,:) <a href="matlab:help openminds.controlledterms.SoftwareApplicationCategory" style="font-weight:bold">SoftwareApplicationCategory</a>
%                            Add all categories to which this software version belongs.
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
%   developer              : (1,:) <a href="matlab:help openminds.core.Organization" style="font-weight:bold">Organization</a>, <a href="matlab:help openminds.core.Person" style="font-weight:bold">Person</a>
%                            If necessary, add one or several developers (person or organization) that contributed to the code implementation of this software version. Note that these developers will overwrite the once provided in the software product this version belongs to.
%
%   device                 : (1,:) <a href="matlab:help openminds.controlledterms.OperatingDevice" style="font-weight:bold">OperatingDevice</a>
%                            Add all hardware devices compatible with this software version.
%
%   digitalIdentifier      : (1,1) <a href="matlab:help openminds.core.DOI" style="font-weight:bold">DOI</a>, <a href="matlab:help openminds.core.SWHID" style="font-weight:bold">SWHID</a>
%                            Add the globally unique and persistent digital identifier of this research product version.
%
%   feature                : (1,:) <a href="matlab:help openminds.controlledterms.SoftwareFeature" style="font-weight:bold">SoftwareFeature</a>
%                            Add all distinguishing characteristics of this software version (e.g. performance, portability, or functionality).
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
%   hasComponent           : (1,:) <a href="matlab:help openminds.core.SoftwareVersion" style="font-weight:bold">SoftwareVersion</a>
%                            Add all software versions that supplement this software version.
%
%   homepage               : (1,1) <a href="matlab:help openminds.core.URL" style="font-weight:bold">URL</a>
%                            Add the uniform resource locator (URL) to the homepage of this research product version.
%
%   howToCite              : (1,1) string
%                            Enter the preferred citation text for this research product version. Leave blank if citation text can be extracted from the assigned digital identifier.
%
%   inputFormat            : (1,:) <a href="matlab:help openminds.core.ContentType" style="font-weight:bold">ContentType</a>
%                            Add the content types of all possible input formats for this software version.
%
%   isAlternativeVersionOf : (1,:) <a href="matlab:help openminds.core.SoftwareVersion" style="font-weight:bold">SoftwareVersion</a>
%                            Add all software versions that can be used alternatively to this software version.
%
%   isNewVersionOf         : (1,1) <a href="matlab:help openminds.core.SoftwareVersion" style="font-weight:bold">SoftwareVersion</a>
%                            Add the software version preceding this software version.
%
%   keyword                : (1,:) string
%                            Enter custom keywords to this research product version.
%
%   language               : (1,:) <a href="matlab:help openminds.controlledterms.Language" style="font-weight:bold">Language</a>
%                            Add all languages supported by this software version.
%
%   license                : (1,:) <a href="matlab:help openminds.core.License" style="font-weight:bold">License</a>
%                            Add at least one license for this software version.
%
%   operatingSystem        : (1,:) <a href="matlab:help openminds.controlledterms.OperatingSystem" style="font-weight:bold">OperatingSystem</a>
%                            Add all operating systems supported by this software version.
%
%   otherContribution      : (1,:) <a href="matlab:help openminds.core.Contribution" style="font-weight:bold">Contribution</a>
%                            Add the contributions for each involved person or organization going beyond being an author, custodian or developer of this research product version.
%
%   outputFormat           : (1,:) <a href="matlab:help openminds.core.ContentType" style="font-weight:bold">ContentType</a>
%                            Add the content types of all possible input formats for this software version.
%
%   programmingLanguage    : (1,:) <a href="matlab:help openminds.controlledterms.ProgrammingLanguage" style="font-weight:bold">ProgrammingLanguage</a>
%                            Add all programming languages used for this software version.
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
%   requirement            : (1,:) string
%                            Enter all requirements of this software version.
%
%   shortName              : (1,1) string
%                            Enter a short name (alias) for this research product version (max. 30 characters, no space).
%
%   supportChannel         : (1,:) string
%                            Enter all channels through which a user can receive support for handling this research product.
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

        % Add all categories to which this software version belongs.
        applicationCategory (1,:) openminds.controlledterms.SoftwareApplicationCategory ...
            {mustBeListOfUniqueItems(applicationCategory)}

        % Add the copyright information of this research product version.
        copyright (1,:) openminds.core.Copyright ...
            {mustBeSpecifiedLength(copyright, 0, 1)}

        % Add one or several custodians (person or organization) that are responsible for this research product version.
        custodian (1,:) openminds.internal.mixedtype.softwareversion.Custodian ...
            {mustBeListOfUniqueItems(custodian)}

        % If necessary, enter a version specific description (abstract) for this research product version (max. 2000 characters, incl. spaces; no references). If left blank, the research product version will inherit the 'description' of it's corresponding research product.
        description (1,1) string ...
            {mustBeValidStringLength(description, 0, 2000)}

        % If necessary, add one or several developers (person or organization) that contributed to the code implementation of this software version. Note that these developers will overwrite the once provided in the software product this version belongs to.
        developer (1,:) openminds.internal.mixedtype.softwareversion.Developer ...
            {mustBeListOfUniqueItems(developer)}

        % Add all hardware devices compatible with this software version.
        device (1,:) openminds.controlledterms.OperatingDevice ...
            {mustBeListOfUniqueItems(device)}

        % Add the globally unique and persistent digital identifier of this research product version.
        digitalIdentifier (1,:) openminds.internal.mixedtype.softwareversion.DigitalIdentifier ...
            {mustBeSpecifiedLength(digitalIdentifier, 0, 1)}

        % Add all distinguishing characteristics of this software version (e.g. performance, portability, or functionality).
        feature (1,:) openminds.controlledterms.SoftwareFeature ...
            {mustBeListOfUniqueItems(feature)}

        % Add the DOI, file or URL that points to a full documentation of this research product version.
        fullDocumentation (1,:) openminds.internal.mixedtype.softwareversion.FullDocumentation ...
            {mustBeSpecifiedLength(fullDocumentation, 0, 1)}

        % If necessary, enter a version specific descriptive full name (title) for this research product version. If left blank, the research product version will inherit the 'fullName' of it's corresponding research product.
        fullName (1,1) string

        % Add all funding information of this research product version.
        funding (1,:) openminds.core.Funding ...
            {mustBeListOfUniqueItems(funding)}

        % Add all software versions that supplement this software version.
        hasComponent (1,:) openminds.core.SoftwareVersion ...
            {mustBeListOfUniqueItems(hasComponent)}

        % Add the uniform resource locator (URL) to the homepage of this research product version.
        homepage (1,:) openminds.core.URL ...
            {mustBeSpecifiedLength(homepage, 0, 1)}

        % Enter the preferred citation text for this research product version. Leave blank if citation text can be extracted from the assigned digital identifier.
        howToCite (1,1) string

        % Add the content types of all possible input formats for this software version.
        inputFormat (1,:) openminds.core.ContentType ...
            {mustBeListOfUniqueItems(inputFormat)}

        % Add all software versions that can be used alternatively to this software version.
        isAlternativeVersionOf (1,:) openminds.core.SoftwareVersion ...
            {mustBeListOfUniqueItems(isAlternativeVersionOf)}

        % Add the software version preceding this software version.
        isNewVersionOf (1,:) openminds.core.SoftwareVersion ...
            {mustBeSpecifiedLength(isNewVersionOf, 0, 1)}

        % Enter custom keywords to this research product version.
        keyword (1,:) string ...
            {mustBeSpecifiedLength(keyword, 1, 5)}

        % Add all languages supported by this software version.
        language (1,:) openminds.controlledterms.Language ...
            {mustBeListOfUniqueItems(language)}

        % Add at least one license for this software version.
        license (1,:) openminds.core.License ...
            {mustBeListOfUniqueItems(license)}

        % Add all operating systems supported by this software version.
        operatingSystem (1,:) openminds.controlledterms.OperatingSystem ...
            {mustBeListOfUniqueItems(operatingSystem)}

        % Add the contributions for each involved person or organization going beyond being an author, custodian or developer of this research product version.
        otherContribution (1,:) openminds.core.Contribution ...
            {mustBeListOfUniqueItems(otherContribution)}

        % Add the content types of all possible input formats for this software version.
        outputFormat (1,:) openminds.core.ContentType ...
            {mustBeListOfUniqueItems(outputFormat)}

        % Add all programming languages used for this software version.
        programmingLanguage (1,:) openminds.controlledterms.ProgrammingLanguage ...
            {mustBeListOfUniqueItems(programmingLanguage)}

        % Add further publications besides the documentation (e.g. an original research article) providing the original context for the production of this research product version.
        relatedPublication (1,:) openminds.internal.mixedtype.softwareversion.RelatedPublication ...
            {mustBeListOfUniqueItems(relatedPublication)}

        % Enter the date (actual or intended) of the first broadcast/publication of this research product version.
        releaseDate (1,:) datetime ...
            {mustBeSpecifiedLength(releaseDate, 0, 1), mustBeValidDate(releaseDate)}

        % Add the file repository of this research product version.
        repository (1,:) openminds.core.FileRepository ...
            {mustBeSpecifiedLength(repository, 0, 1)}

        % Enter all requirements of this software version.
        requirement (1,:) string ...
            {mustBeListOfUniqueItems(requirement)}

        % Enter a short name (alias) for this research product version (max. 30 characters, no space).
        shortName (1,1) string ...
            {mustBeValidStringLength(shortName, 0, 30)}

        % Enter all channels through which a user can receive support for handling this research product.
        supportChannel (1,:) string ...
            {mustBeListOfUniqueItems(supportChannel)}

        % Enter the version identifier of this research product version.
        versionIdentifier (1,1) string

        % Enter a summary/description of the novelties/peculiarities of this research product version in comparison to other versions of it's research product. If this research product version is the first released version, you can enter the following disclaimer 'This is the first version of this research product.'
        versionInnovation (1,1) string
    end

    properties (Access = protected)
        Required = ["accessibility", "applicationCategory", "device", "feature", "fullDocumentation", "funding", "language", "license", "operatingSystem", "programmingLanguage", "releaseDate", "shortName", "versionIdentifier", "versionInnovation"]
    end

    properties (Constant, Hidden)
        X_TYPE = "https://openminds.ebrains.eu/core/SoftwareVersion"
    end

    properties (Constant, Hidden)
        LINKED_PROPERTIES = struct(...
            'accessibility', "openminds.controlledterms.ProductAccessibility", ...
            'applicationCategory', "openminds.controlledterms.SoftwareApplicationCategory", ...
            'custodian', ["openminds.core.Organization", "openminds.core.Person"], ...
            'developer', ["openminds.core.Organization", "openminds.core.Person"], ...
            'device', "openminds.controlledterms.OperatingDevice", ...
            'digitalIdentifier', ["openminds.core.DOI", "openminds.core.SWHID"], ...
            'feature', "openminds.controlledterms.SoftwareFeature", ...
            'fullDocumentation', ["openminds.core.DOI", "openminds.core.File", "openminds.core.URL"], ...
            'funding', "openminds.core.Funding", ...
            'hasComponent', "openminds.core.SoftwareVersion", ...
            'homepage', "openminds.core.URL", ...
            'inputFormat', "openminds.core.ContentType", ...
            'isAlternativeVersionOf', "openminds.core.SoftwareVersion", ...
            'isNewVersionOf', "openminds.core.SoftwareVersion", ...
            'language', "openminds.controlledterms.Language", ...
            'license', "openminds.core.License", ...
            'operatingSystem', "openminds.controlledterms.OperatingSystem", ...
            'outputFormat', "openminds.core.ContentType", ...
            'programmingLanguage', "openminds.controlledterms.ProgrammingLanguage", ...
            'relatedPublication', ["openminds.core.DOI", "openminds.core.ISBN"], ...
            'repository', "openminds.core.FileRepository" ...
        )
        EMBEDDED_PROPERTIES = struct(...
            'copyright', "openminds.core.Copyright", ...
            'otherContribution', "openminds.core.Contribution" ...
        )
    end

    methods
        function obj = SoftwareVersion(varargin)
            obj@openminds.abstract.Schema(varargin{:})
        end
    end

    methods (Access = protected)
        function str = getDisplayLabel(obj)
            str = sprintf('%s', obj.fullName);
        end
    end

end