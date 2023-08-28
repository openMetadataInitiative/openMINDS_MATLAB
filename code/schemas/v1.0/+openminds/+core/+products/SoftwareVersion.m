classdef SoftwareVersion < openminds.abstract.Schema
%SoftwareVersion - No description available.
%
%   PROPERTIES:
%
%   accessibility         : (1,1) <a href="matlab:help openminds.controlledterms.ProductAccessibility" style="font-weight:bold">ProductAccessibility</a>
%                           Add the accessibility of the data for this research product version.
%
%   applicationCategory   : (1,:) <a href="matlab:help openminds.controlledterms.SoftwareApplicationCategory" style="font-weight:bold">SoftwareApplicationCategory</a>
%                           Add all categories to which this software version belongs.
%
%   author                : (1,:) <a href="matlab:help openminds.core.Organization" style="font-weight:bold">Organization</a>, <a href="matlab:help openminds.core.Person" style="font-weight:bold">Person</a>
%                           Add one or several authors (person or organization) that contributed to the production and publication of this research product version.
%
%   copyright             : (1,1) <a href="matlab:help openminds.core.Copyright" style="font-weight:bold">Copyright</a>
%                           Add the copyright information of this research product version.
%
%   custodian             : (1,:) <a href="matlab:help openminds.core.Organization" style="font-weight:bold">Organization</a>, <a href="matlab:help openminds.core.Person" style="font-weight:bold">Person</a>
%                           Add one or several custodians (person or organization) that are responsible for this research product version.
%
%   description           : (1,1) string
%                           Enter a description (abstract) for this research product (max. 2000 characters, incl. spaces; no references).
%
%   developer             : (1,:) <a href="matlab:help openminds.core.Organization" style="font-weight:bold">Organization</a>, <a href="matlab:help openminds.core.Person" style="font-weight:bold">Person</a>
%                           Add one or several developers (person or organization) that contributed to the code implementation of this research product version.
%
%   device                : (1,:) <a href="matlab:help openminds.controlledterms.OperatingDevice" style="font-weight:bold">OperatingDevice</a>
%                           Add all hardware devices compatible with this software version.
%
%   digitalIdentifier     : (1,1) <a href="matlab:help openminds.core.DigitalIdentifier" style="font-weight:bold">DigitalIdentifier</a>
%                           Add the globally unique and persistent digital identifier of this research product version.
%
%   fullDocumentation     : (1,1) <a href="matlab:help openminds.core.DigitalIdentifier" style="font-weight:bold">DigitalIdentifier</a>
%                           Add the globally unique and persistent digital identifier of a full documentation of this research product version.
%
%   fullName              : (1,1) string
%                           Enter a descriptive full name (title) for this research product version.
%
%   funding               : (1,:) <a href="matlab:help openminds.core.Funding" style="font-weight:bold">Funding</a>
%                           Add all funding information of this research product version.
%
%   hasAlternativeVersion : (1,:) <a href="matlab:help openminds.core.SoftwareVersion" style="font-weight:bold">SoftwareVersion</a>
%                           Add all software versions that can be used alternatively to this software version.
%
%   hasFeature            : (1,:) <a href="matlab:help openminds.controlledterms.SoftwareFeature" style="font-weight:bold">SoftwareFeature</a>
%                           Add all features of this software version.
%
%   hasRequirement        : (1,1) string
%                           Enter all requirements of this software version.
%
%   hasSupplementVersion  : (1,:) <a href="matlab:help openminds.core.SoftwareVersion" style="font-weight:bold">SoftwareVersion</a>
%                           Add all software versions that supplement this software version.
%
%   homepage              : (1,1) string
%                           Enter the internationalized resource identifier (IRI) to the homepage of this research product version.
%
%   inputFormat           : (1,:) <a href="matlab:help openminds.core.ContentType" style="font-weight:bold">ContentType</a>
%                           Add the content types of all possible input formats for this software version.
%
%   isNewVersionOf        : (1,1) <a href="matlab:help openminds.core.SoftwareVersion" style="font-weight:bold">SoftwareVersion</a>
%                           Add the software version preceding this software version.
%
%   keyword               : (1,:) string
%                           Enter custom keywords to this research product version.
%
%   language              : (1,:) <a href="matlab:help openminds.controlledterms.Language" style="font-weight:bold">Language</a>
%                           Add all languages supported by this software version.
%
%   license               : (1,1) <a href="matlab:help openminds.core.License" style="font-weight:bold">License</a>
%                           Add the license of this research product version.
%
%   operatingSystem       : (1,:) <a href="matlab:help openminds.controlledterms.OperatingSystem" style="font-weight:bold">OperatingSystem</a>
%                           Add all operating systems supported by this software version.
%
%   otherContribution     : (1,:) <a href="matlab:help openminds.core.Contribution" style="font-weight:bold">Contribution</a>
%                           Add the contributions for each involved person or organization going beyond being an author, custodian or developer of this research product version.
%
%   outputFormat          : (1,:) <a href="matlab:help openminds.core.ContentType" style="font-weight:bold">ContentType</a>
%                           Add the content types of all possible input formats for this software version.
%
%   programmingLanguage   : (1,:) <a href="matlab:help openminds.controlledterms.ProgrammingLanguage" style="font-weight:bold">ProgrammingLanguage</a>
%                           Add all programming languages used for this software version.
%
%   relatedPublication    : (1,:) <a href="matlab:help openminds.core.DigitalIdentifier" style="font-weight:bold">DigitalIdentifier</a>
%                           Add further publications besides the documentation (e.g. an original research article) providing the original context for the production of this research product version.
%
%   releaseDate           : (1,1) string
%                           Enter the date (actual or intended) of the first broadcast/publication of this research product version.
%
%   repository            : (1,1) <a href="matlab:help openminds.core.FileRepository" style="font-weight:bold">FileRepository</a>
%                           Add the file repository of this research product version.
%
%   shortName             : (1,1) string
%                           Enter a short name (alias) for this research product version (max. 30 characters, no space).
%
%   versionIdentifier     : (1,1) string
%                           Enter the version identifier of this research product version.
%
%   versionInnovation     : (1,1) string
%                           Enter a short summary of the novelties/peculiarities of this research product version.

%   This class was auto-generated by the openMINDS pipeline

    properties
        % Add the accessibility of the data for this research product version.
        accessibility (1,:) openminds.controlledterms.ProductAccessibility ...
            {mustBeSpecifiedLength(accessibility, 0, 1)}

        % Add all categories to which this software version belongs.
        applicationCategory (1,:) openminds.controlledterms.SoftwareApplicationCategory ...
            {mustBeListOfUniqueItems(applicationCategory)}

        % Add one or several authors (person or organization) that contributed to the production and publication of this research product version.
        author (1,:) openminds.internal.mixedtype.softwareversion.Author ...
            {mustBeListOfUniqueItems(author)}

        % Add the copyright information of this research product version.
        copyright (1,:) openminds.core.Copyright ...
            {mustBeSpecifiedLength(copyright, 0, 1)}

        % Add one or several custodians (person or organization) that are responsible for this research product version.
        custodian (1,:) openminds.internal.mixedtype.softwareversion.Custodian ...
            {mustBeListOfUniqueItems(custodian)}

        % Enter a description (abstract) for this research product (max. 2000 characters, incl. spaces; no references).
        description (1,1) string ...
            {mustBeValidStringLength(description, 0, 2000)}

        % Add one or several developers (person or organization) that contributed to the code implementation of this research product version.
        developer (1,:) openminds.internal.mixedtype.softwareversion.Developer ...
            {mustBeListOfUniqueItems(developer)}

        % Add all hardware devices compatible with this software version.
        device (1,:) openminds.controlledterms.OperatingDevice ...
            {mustBeListOfUniqueItems(device)}

        % Add the globally unique and persistent digital identifier of this research product version.
        digitalIdentifier (1,:) openminds.core.DigitalIdentifier ...
            {mustBeSpecifiedLength(digitalIdentifier, 0, 1)}

        % Add the globally unique and persistent digital identifier of a full documentation of this research product version.
        fullDocumentation (1,:) openminds.core.DigitalIdentifier ...
            {mustBeSpecifiedLength(fullDocumentation, 0, 1)}

        % Enter a descriptive full name (title) for this research product version.
        fullName (1,1) string

        % Add all funding information of this research product version.
        funding (1,:) openminds.core.Funding ...
            {mustBeListOfUniqueItems(funding)}

        % Add all software versions that can be used alternatively to this software version.
        hasAlternativeVersion (1,:) openminds.core.SoftwareVersion ...
            {mustBeListOfUniqueItems(hasAlternativeVersion)}

        % Add all features of this software version.
        hasFeature (1,:) openminds.controlledterms.SoftwareFeature ...
            {mustBeListOfUniqueItems(hasFeature)}

        % Enter all requirements of this software version.
        hasRequirement (1,1) string

        % Add all software versions that supplement this software version.
        hasSupplementVersion (1,:) openminds.core.SoftwareVersion ...
            {mustBeListOfUniqueItems(hasSupplementVersion)}

        % Enter the internationalized resource identifier (IRI) to the homepage of this research product version.
        homepage (1,1) string

        % Add the content types of all possible input formats for this software version.
        inputFormat (1,:) openminds.core.ContentType ...
            {mustBeListOfUniqueItems(inputFormat)}

        % Add the software version preceding this software version.
        isNewVersionOf (1,:) openminds.core.SoftwareVersion ...
            {mustBeSpecifiedLength(isNewVersionOf, 0, 1)}

        % Enter custom keywords to this research product version.
        keyword (1,:) string ...
            {mustBeSpecifiedLength(keyword, 1, 5)}

        % Add all languages supported by this software version.
        language (1,:) openminds.controlledterms.Language ...
            {mustBeListOfUniqueItems(language)}

        % Add the license of this research product version.
        license (1,:) openminds.core.License ...
            {mustBeSpecifiedLength(license, 0, 1)}

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
        relatedPublication (1,:) openminds.core.DigitalIdentifier ...
            {mustBeListOfUniqueItems(relatedPublication)}

        % Enter the date (actual or intended) of the first broadcast/publication of this research product version.
        releaseDate (1,1) string

        % Add the file repository of this research product version.
        repository (1,:) openminds.core.FileRepository ...
            {mustBeSpecifiedLength(repository, 0, 1)}

        % Enter a short name (alias) for this research product version (max. 30 characters, no space).
        shortName (1,1) string ...
            {mustBeValidStringLength(shortName, 0, 30)}

        % Enter the version identifier of this research product version.
        versionIdentifier (1,1) string

        % Enter a short summary of the novelties/peculiarities of this research product version.
        versionInnovation (1,1) string
    end

    properties (Access = protected)
        Required = ["accessibility", "applicationCategory", "description", "developer", "device", "digitalIdentifier", "fullDocumentation", "fullName", "funding", "hasFeature", "hasRequirement", "inputFormat", "language", "license", "operatingSystem", "outputFormat", "programmingLanguage", "releaseDate", "repository", "shortName", "versionIdentifier"]
    end

    properties (Constant, Hidden)
        X_TYPE = "https://openminds.ebrains.eu/core/SoftwareVersion"
    end

    properties (Constant, Hidden)
        LINKED_PROPERTIES = struct(...
            'accessibility', "openminds.controlledterms.ProductAccessibility", ...
            'applicationCategory', "openminds.controlledterms.SoftwareApplicationCategory", ...
            'author', ["openminds.core.Organization", "openminds.core.Person"], ...
            'custodian', ["openminds.core.Organization", "openminds.core.Person"], ...
            'developer', ["openminds.core.Organization", "openminds.core.Person"], ...
            'device', "openminds.controlledterms.OperatingDevice", ...
            'digitalIdentifier', "openminds.core.DigitalIdentifier", ...
            'fullDocumentation', "openminds.core.DigitalIdentifier", ...
            'funding', "openminds.core.Funding", ...
            'hasAlternativeVersion', "openminds.core.SoftwareVersion", ...
            'hasFeature', "openminds.controlledterms.SoftwareFeature", ...
            'hasSupplementVersion', "openminds.core.SoftwareVersion", ...
            'inputFormat', "openminds.core.ContentType", ...
            'isNewVersionOf', "openminds.core.SoftwareVersion", ...
            'language', "openminds.controlledterms.Language", ...
            'license', "openminds.core.License", ...
            'operatingSystem', "openminds.controlledterms.OperatingSystem", ...
            'otherContribution', "openminds.core.Contribution", ...
            'outputFormat', "openminds.core.ContentType", ...
            'programmingLanguage', "openminds.controlledterms.ProgrammingLanguage", ...
            'relatedPublication', "openminds.core.DigitalIdentifier", ...
            'repository', "openminds.core.FileRepository" ...
        )
        EMBEDDED_PROPERTIES = struct(...
            'copyright', "openminds.core.Copyright" ...
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