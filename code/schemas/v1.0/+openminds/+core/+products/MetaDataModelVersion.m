classdef MetaDataModelVersion < openminds.abstract.Schema
%MetaDataModelVersion - No description available.
%
%   PROPERTIES:
%
%   accessibility         : (1,1) <a href="matlab:help openminds.controlledterms.ProductAccessibility" style="font-weight:bold">ProductAccessibility</a>
%                           Add the accessibility of the data for this research product version.
%
%   author                : (1,:) <a href="matlab:help openminds.core.actors.Organization" style="font-weight:bold">Organization</a>, <a href="matlab:help openminds.core.actors.Person" style="font-weight:bold">Person</a>
%                           Add one or several authors (person or organization) that contributed to the production and publication of this research product version.
%
%   copyright             : (1,1) <a href="matlab:help openminds.core.data.Copyright" style="font-weight:bold">Copyright</a>
%                           Add the copyright information of this research product version.
%
%   custodian             : (1,:) <a href="matlab:help openminds.core.actors.Organization" style="font-weight:bold">Organization</a>, <a href="matlab:help openminds.core.actors.Person" style="font-weight:bold">Person</a>
%                           Add one or several custodians (person or organization) that are responsible for this research product version.
%
%   description           : (1,1) string
%                           Enter a description (abstract) for this research product (max. 2000 characters, incl. spaces; no references).
%
%   developer             : (1,:) <a href="matlab:help openminds.core.actors.Organization" style="font-weight:bold">Organization</a>, <a href="matlab:help openminds.core.actors.Person" style="font-weight:bold">Person</a>
%                           Add one or several developers (person or organization) that contributed to the code implementation of this research product version.
%
%   digitalIdentifier     : (1,1) <a href="matlab:help openminds.core.miscellaneous.DigitalIdentifier" style="font-weight:bold">DigitalIdentifier</a>
%                           Add the globally unique and persistent digital identifier of this research product version.
%
%   fullDocumentation     : (1,1) <a href="matlab:help openminds.core.miscellaneous.DigitalIdentifier" style="font-weight:bold">DigitalIdentifier</a>
%                           Add the globally unique and persistent digital identifier of a full documentation of this research product version.
%
%   fullName              : (1,1) string
%                           Enter a descriptive full name (title) for this research product version.
%
%   funding               : (1,:) <a href="matlab:help openminds.core.miscellaneous.Funding" style="font-weight:bold">Funding</a>
%                           Add all funding information of this research product version.
%
%   hasAlternativeVersion : (1,:) <a href="matlab:help openminds.core.products.DatasetVersion" style="font-weight:bold">DatasetVersion</a>
%                           Add all (meta)data model versions that can be used alternatively to this (meta)data model version.
%
%   hasSupplementVersion  : (1,:) <a href="matlab:help openminds.core.products.DatasetVersion" style="font-weight:bold">DatasetVersion</a>
%                           Add all (meta)data model versions that supplement this (meta)data model version.
%
%   homepage              : (1,1) string
%                           Enter the internationalized resource identifier (IRI) to the homepage of this research product version.
%
%   isNewVersionOf        : (1,1) <a href="matlab:help openminds.core.products.MetaDataModelVersion" style="font-weight:bold">MetaDataModelVersion</a>
%                           Add the dataset version preceding this (meta)data model version.
%
%   keyword               : (1,:) string
%                           Enter custom keywords to this research product version.
%
%   license               : (1,1) <a href="matlab:help openminds.core.data.License" style="font-weight:bold">License</a>
%                           Add the license of this research product version.
%
%   otherContribution     : (1,:) <a href="matlab:help openminds.core.actors.Contribution" style="font-weight:bold">Contribution</a>
%                           Add the contributions for each involved person or organization going beyond being an author, custodian or developer of this research product version.
%
%   relatedPublication    : (1,:) <a href="matlab:help openminds.core.miscellaneous.DigitalIdentifier" style="font-weight:bold">DigitalIdentifier</a>
%                           Add further publications besides the documentation (e.g. an original research article) providing the original context for the production of this research product version.
%
%   releaseDate           : (1,1) string
%                           Enter the date (actual or intended) of the first broadcast/publication of this research product version.
%
%   repository            : (1,1) <a href="matlab:help openminds.core.data.FileRepository" style="font-weight:bold">FileRepository</a>
%                           Add the file repository of this research product version.
%
%   serializationFormat   : (1,:) <a href="matlab:help openminds.core.data.ContentType" style="font-weight:bold">ContentType</a>
%                           Add all content types in which (meta)data compliant with this (meta)data model version can be stored in.
%
%   shortName             : (1,1) string
%                           Enter a short name (alias) for this research product version (max. 30 characters, no space).
%
%   specificationFormat   : (1,:) <a href="matlab:help openminds.core.data.ContentType" style="font-weight:bold">ContentType</a>
%                           Add all content types in which the schemas of this (meta)data model version are stored in.
%
%   type                  : (1,1) <a href="matlab:help openminds.controlledterms.MetaDataModelType" style="font-weight:bold">MetaDataModelType</a>
%                           Add the type of this (meta)data model version.
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

        % Add one or several authors (person or organization) that contributed to the production and publication of this research product version.
        author (1,:) openminds.internal.mixedtype.metadatamodelversion.Author ...
            {mustBeListOfUniqueItems(author)}

        % Add the copyright information of this research product version.
        copyright (1,:) openminds.core.data.Copyright ...
            {mustBeSpecifiedLength(copyright, 0, 1)}

        % Add one or several custodians (person or organization) that are responsible for this research product version.
        custodian (1,:) openminds.internal.mixedtype.metadatamodelversion.Custodian ...
            {mustBeListOfUniqueItems(custodian)}

        % Enter a description (abstract) for this research product (max. 2000 characters, incl. spaces; no references).
        description (1,1) string ...
            {mustBeValidStringLength(description, 0, 2000)}

        % Add one or several developers (person or organization) that contributed to the code implementation of this research product version.
        developer (1,:) openminds.internal.mixedtype.metadatamodelversion.Developer ...
            {mustBeListOfUniqueItems(developer)}

        % Add the globally unique and persistent digital identifier of this research product version.
        digitalIdentifier (1,:) openminds.core.miscellaneous.DigitalIdentifier ...
            {mustBeSpecifiedLength(digitalIdentifier, 0, 1)}

        % Add the globally unique and persistent digital identifier of a full documentation of this research product version.
        fullDocumentation (1,:) openminds.core.miscellaneous.DigitalIdentifier ...
            {mustBeSpecifiedLength(fullDocumentation, 0, 1)}

        % Enter a descriptive full name (title) for this research product version.
        fullName (1,1) string

        % Add all funding information of this research product version.
        funding (1,:) openminds.core.miscellaneous.Funding ...
            {mustBeListOfUniqueItems(funding)}

        % Add all (meta)data model versions that can be used alternatively to this (meta)data model version.
        hasAlternativeVersion (1,:) openminds.core.products.DatasetVersion ...
            {mustBeListOfUniqueItems(hasAlternativeVersion)}

        % Add all (meta)data model versions that supplement this (meta)data model version.
        hasSupplementVersion (1,:) openminds.core.products.DatasetVersion ...
            {mustBeListOfUniqueItems(hasSupplementVersion)}

        % Enter the internationalized resource identifier (IRI) to the homepage of this research product version.
        homepage (1,1) string

        % Add the dataset version preceding this (meta)data model version.
        isNewVersionOf (1,:) openminds.core.products.MetaDataModelVersion ...
            {mustBeSpecifiedLength(isNewVersionOf, 0, 1)}

        % Enter custom keywords to this research product version.
        keyword (1,:) string ...
            {mustBeSpecifiedLength(keyword, 1, 5)}

        % Add the license of this research product version.
        license (1,:) openminds.core.data.License ...
            {mustBeSpecifiedLength(license, 0, 1)}

        % Add the contributions for each involved person or organization going beyond being an author, custodian or developer of this research product version.
        otherContribution (1,:) openminds.core.actors.Contribution ...
            {mustBeListOfUniqueItems(otherContribution)}

        % Add further publications besides the documentation (e.g. an original research article) providing the original context for the production of this research product version.
        relatedPublication (1,:) openminds.core.miscellaneous.DigitalIdentifier ...
            {mustBeListOfUniqueItems(relatedPublication)}

        % Enter the date (actual or intended) of the first broadcast/publication of this research product version.
        releaseDate (1,1) string

        % Add the file repository of this research product version.
        repository (1,:) openminds.core.data.FileRepository ...
            {mustBeSpecifiedLength(repository, 0, 1)}

        % Add all content types in which (meta)data compliant with this (meta)data model version can be stored in.
        serializationFormat (1,:) openminds.core.data.ContentType ...
            {mustBeListOfUniqueItems(serializationFormat)}

        % Enter a short name (alias) for this research product version (max. 30 characters, no space).
        shortName (1,1) string ...
            {mustBeValidStringLength(shortName, 0, 30)}

        % Add all content types in which the schemas of this (meta)data model version are stored in.
        specificationFormat (1,:) openminds.core.data.ContentType ...
            {mustBeListOfUniqueItems(specificationFormat)}

        % Add the type of this (meta)data model version.
        type (1,:) openminds.controlledterms.MetaDataModelType ...
            {mustBeSpecifiedLength(type, 0, 1)}

        % Enter the version identifier of this research product version.
        versionIdentifier (1,1) string

        % Enter a short summary of the novelties/peculiarities of this research product version.
        versionInnovation (1,1) string
    end

    properties (Access = protected)
        Required = ["accessibility", "description", "digitalIdentifier", "fullDocumentation", "fullName", "funding", "license", "releaseDate", "repository", "shortName", "type", "versionIdentifier"]
    end

    properties (Constant, Hidden)
        X_TYPE = "https://openminds.ebrains.eu/core/MetaDataModelVersion"
    end

    properties (Constant, Hidden)
        LINKED_PROPERTIES = struct(...
            'accessibility', "openminds.controlledterms.ProductAccessibility", ...
            'author', ["openminds.core.actors.Organization", "openminds.core.actors.Person"], ...
            'custodian', ["openminds.core.actors.Organization", "openminds.core.actors.Person"], ...
            'developer', ["openminds.core.actors.Organization", "openminds.core.actors.Person"], ...
            'digitalIdentifier', "openminds.core.miscellaneous.DigitalIdentifier", ...
            'fullDocumentation', "openminds.core.miscellaneous.DigitalIdentifier", ...
            'funding', "openminds.core.miscellaneous.Funding", ...
            'hasAlternativeVersion', "openminds.core.products.DatasetVersion", ...
            'hasSupplementVersion', "openminds.core.products.DatasetVersion", ...
            'isNewVersionOf', "openminds.core.products.MetaDataModelVersion", ...
            'license', "openminds.core.data.License", ...
            'otherContribution', "openminds.core.actors.Contribution", ...
            'relatedPublication', "openminds.core.miscellaneous.DigitalIdentifier", ...
            'repository', "openminds.core.data.FileRepository", ...
            'serializationFormat', "openminds.core.data.ContentType", ...
            'specificationFormat', "openminds.core.data.ContentType", ...
            'type', "openminds.controlledterms.MetaDataModelType" ...
        )
        EMBEDDED_PROPERTIES = struct(...
            'copyright', "openminds.core.data.Copyright" ...
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
