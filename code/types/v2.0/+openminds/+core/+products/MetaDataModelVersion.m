classdef MetaDataModelVersion < openminds.abstract.Schema
%MetaDataModelVersion - No description available.
%
%   PROPERTIES:
%
%   accessibility          : (1,1) <a href="matlab:help openminds.controlledterms.ProductAccessibility" style="font-weight:bold">ProductAccessibility</a>
%                            Add the accessibility of the data for this research product version.
%
%   copyright              : (1,1) <a href="matlab:help openminds.core.data.Copyright" style="font-weight:bold">Copyright</a>
%                            Add the copyright information of this research product version.
%
%   custodian              : (1,:) <a href="matlab:help openminds.core.actors.Organization" style="font-weight:bold">Organization</a>, <a href="matlab:help openminds.core.actors.Person" style="font-weight:bold">Person</a>
%                            Add one or several custodians (person or organization) that are responsible for this research product version.
%
%   description            : (1,1) string
%                            If necessary, enter a version specific description (abstract) for this research product version (max. 2000 characters, incl. spaces; no references). If left blank, the research product version will inherit the 'description' of it's corresponding research product.
%
%   developer              : (1,:) <a href="matlab:help openminds.core.actors.Organization" style="font-weight:bold">Organization</a>, <a href="matlab:help openminds.core.actors.Person" style="font-weight:bold">Person</a>
%                            If necessary, add one or several developers (person or organization) that contributed to the code implementation of this (meta)data model version. Note that these developers will overwrite the once provided in the (meta)data model product this version belongs to.
%
%   digitalIdentifier      : (1,1) <a href="matlab:help openminds.core.miscellaneous.DOI" style="font-weight:bold">DOI</a>, <a href="matlab:help openminds.core.miscellaneous.SWHID" style="font-weight:bold">SWHID</a>
%                            Add the globally unique and persistent digital identifier of this research product version.
%
%   fullDocumentation      : (1,1) <a href="matlab:help openminds.core.data.File" style="font-weight:bold">File</a>, <a href="matlab:help openminds.core.miscellaneous.DOI" style="font-weight:bold">DOI</a>, <a href="matlab:help openminds.core.miscellaneous.URL" style="font-weight:bold">URL</a>
%                            Add the DOI, file or URL that points to a full documentation of this research product version.
%
%   fullName               : (1,1) string
%                            If necessary, enter a version specific descriptive full name (title) for this research product version. If left blank, the research product version will inherit the 'fullName' of it's corresponding research product.
%
%   funding                : (1,:) <a href="matlab:help openminds.core.miscellaneous.Funding" style="font-weight:bold">Funding</a>
%                            Add all funding information of this research product version.
%
%   homepage               : (1,1) <a href="matlab:help openminds.core.miscellaneous.URL" style="font-weight:bold">URL</a>
%                            Add the uniform resource locator (URL) to the homepage of this research product version.
%
%   howToCite              : (1,1) string
%                            Enter the preferred citation text for this research product version. Leave blank if citation text can be extracted from the assigned digital identifier.
%
%   isAlternativeVersionOf : (1,:) <a href="matlab:help openminds.core.products.MetaDataModelVersion" style="font-weight:bold">MetaDataModelVersion</a>
%                            Add all (meta)data model versions that can be used alternatively to this (meta)data model version.
%
%   isNewVersionOf         : (1,1) <a href="matlab:help openminds.core.products.MetaDataModelVersion" style="font-weight:bold">MetaDataModelVersion</a>
%                            Add the dataset version preceding this (meta)data model version.
%
%   keyword                : (1,:) string
%                            Enter custom keywords to this research product version.
%
%   license                : (1,1) <a href="matlab:help openminds.core.data.License" style="font-weight:bold">License</a>
%                            Add the license for this (meta)data model version.
%
%   otherContribution      : (1,:) <a href="matlab:help openminds.core.actors.Contribution" style="font-weight:bold">Contribution</a>
%                            Add the contributions for each involved person or organization going beyond being an author, custodian or developer of this research product version.
%
%   relatedPublication     : (1,:) <a href="matlab:help openminds.core.miscellaneous.DOI" style="font-weight:bold">DOI</a>, <a href="matlab:help openminds.core.miscellaneous.ISBN" style="font-weight:bold">ISBN</a>
%                            Add further publications besides the documentation (e.g. an original research article) providing the original context for the production of this research product version.
%
%   releaseDate            : (1,1) datetime
%                            Enter the date (actual or intended) of the first broadcast/publication of this research product version.
%
%   repository             : (1,1) <a href="matlab:help openminds.core.data.FileRepository" style="font-weight:bold">FileRepository</a>
%                            Add the file repository of this research product version.
%
%   serializationFormat    : (1,:) <a href="matlab:help openminds.core.data.ContentType" style="font-weight:bold">ContentType</a>
%                            Add all content types in which (meta)data compliant with this (meta)data model version can be stored in.
%
%   shortName              : (1,1) string
%                            Enter a short name (alias) for this research product version (max. 30 characters, no space).
%
%   specificationFormat    : (1,:) <a href="matlab:help openminds.core.data.ContentType" style="font-weight:bold">ContentType</a>
%                            Add all content types in which the schemas of this (meta)data model version are stored in.
%
%   supportChannel         : (1,:) string
%                            Enter all channels through which a user can receive support for handling this research product.
%
%   type                   : (1,1) <a href="matlab:help openminds.controlledterms.MetaDataModelType" style="font-weight:bold">MetaDataModelType</a>
%                            Add the type of this (meta)data model version.
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

        % Add the copyright information of this research product version.
        copyright (1,:) openminds.core.data.Copyright ...
            {mustBeSpecifiedLength(copyright, 0, 1)}

        % Add one or several custodians (person or organization) that are responsible for this research product version.
        custodian (1,:) openminds.internal.mixedtype.metadatamodelversion.Custodian ...
            {mustBeListOfUniqueItems(custodian)}

        % If necessary, enter a version specific description (abstract) for this research product version (max. 2000 characters, incl. spaces; no references). If left blank, the research product version will inherit the 'description' of it's corresponding research product.
        description (1,1) string ...
            {mustBeValidStringLength(description, 0, 2000)}

        % If necessary, add one or several developers (person or organization) that contributed to the code implementation of this (meta)data model version. Note that these developers will overwrite the once provided in the (meta)data model product this version belongs to.
        developer (1,:) openminds.internal.mixedtype.metadatamodelversion.Developer ...
            {mustBeListOfUniqueItems(developer)}

        % Add the globally unique and persistent digital identifier of this research product version.
        digitalIdentifier (1,:) openminds.internal.mixedtype.metadatamodelversion.DigitalIdentifier ...
            {mustBeSpecifiedLength(digitalIdentifier, 0, 1)}

        % Add the DOI, file or URL that points to a full documentation of this research product version.
        fullDocumentation (1,:) openminds.internal.mixedtype.metadatamodelversion.FullDocumentation ...
            {mustBeSpecifiedLength(fullDocumentation, 0, 1)}

        % If necessary, enter a version specific descriptive full name (title) for this research product version. If left blank, the research product version will inherit the 'fullName' of it's corresponding research product.
        fullName (1,1) string

        % Add all funding information of this research product version.
        funding (1,:) openminds.core.miscellaneous.Funding ...
            {mustBeListOfUniqueItems(funding)}

        % Add the uniform resource locator (URL) to the homepage of this research product version.
        homepage (1,:) openminds.core.miscellaneous.URL ...
            {mustBeSpecifiedLength(homepage, 0, 1)}

        % Enter the preferred citation text for this research product version. Leave blank if citation text can be extracted from the assigned digital identifier.
        howToCite (1,1) string

        % Add all (meta)data model versions that can be used alternatively to this (meta)data model version.
        isAlternativeVersionOf (1,:) openminds.core.products.MetaDataModelVersion ...
            {mustBeListOfUniqueItems(isAlternativeVersionOf)}

        % Add the dataset version preceding this (meta)data model version.
        isNewVersionOf (1,:) openminds.core.products.MetaDataModelVersion ...
            {mustBeSpecifiedLength(isNewVersionOf, 0, 1)}

        % Enter custom keywords to this research product version.
        keyword (1,:) string ...
            {mustBeSpecifiedLength(keyword, 1, 5)}

        % Add the license for this (meta)data model version.
        license (1,:) openminds.core.data.License ...
            {mustBeSpecifiedLength(license, 0, 1)}

        % Add the contributions for each involved person or organization going beyond being an author, custodian or developer of this research product version.
        otherContribution (1,:) openminds.core.actors.Contribution ...
            {mustBeListOfUniqueItems(otherContribution)}

        % Add further publications besides the documentation (e.g. an original research article) providing the original context for the production of this research product version.
        relatedPublication (1,:) openminds.internal.mixedtype.metadatamodelversion.RelatedPublication ...
            {mustBeListOfUniqueItems(relatedPublication)}

        % Enter the date (actual or intended) of the first broadcast/publication of this research product version.
        releaseDate (1,:) datetime ...
            {mustBeSpecifiedLength(releaseDate, 0, 1), mustBeValidDate(releaseDate)}

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

        % Enter all channels through which a user can receive support for handling this research product.
        supportChannel (1,:) string ...
            {mustBeListOfUniqueItems(supportChannel)}

        % Add the type of this (meta)data model version.
        type (1,:) openminds.controlledterms.MetaDataModelType ...
            {mustBeSpecifiedLength(type, 0, 1)}

        % Enter the version identifier of this research product version.
        versionIdentifier (1,1) string

        % Enter a summary/description of the novelties/peculiarities of this research product version in comparison to other versions of it's research product. If this research product version is the first released version, you can enter the following disclaimer 'This is the first version of this research product.'
        versionInnovation (1,1) string
    end

    properties (Access = protected)
        Required = ["accessibility", "fullDocumentation", "funding", "license", "releaseDate", "shortName", "type", "versionIdentifier", "versionInnovation"]
    end

    properties (Constant, Hidden)
        X_TYPE = "https://openminds.ebrains.eu/core/MetaDataModelVersion"
    end

    properties (Constant, Hidden)
        LINKED_PROPERTIES = struct(...
            'accessibility', "openminds.controlledterms.ProductAccessibility", ...
            'custodian', ["openminds.core.actors.Organization", "openminds.core.actors.Person"], ...
            'developer', ["openminds.core.actors.Organization", "openminds.core.actors.Person"], ...
            'digitalIdentifier', ["openminds.core.miscellaneous.DOI", "openminds.core.miscellaneous.SWHID"], ...
            'fullDocumentation', ["openminds.core.data.File", "openminds.core.miscellaneous.DOI", "openminds.core.miscellaneous.URL"], ...
            'funding', "openminds.core.miscellaneous.Funding", ...
            'homepage', "openminds.core.miscellaneous.URL", ...
            'isAlternativeVersionOf', "openminds.core.products.MetaDataModelVersion", ...
            'isNewVersionOf', "openminds.core.products.MetaDataModelVersion", ...
            'license', "openminds.core.data.License", ...
            'relatedPublication', ["openminds.core.miscellaneous.DOI", "openminds.core.miscellaneous.ISBN"], ...
            'repository', "openminds.core.data.FileRepository", ...
            'serializationFormat', "openminds.core.data.ContentType", ...
            'specificationFormat', "openminds.core.data.ContentType", ...
            'type', "openminds.controlledterms.MetaDataModelType" ...
        )
        EMBEDDED_PROPERTIES = struct(...
            'copyright', "openminds.core.data.Copyright", ...
            'otherContribution', "openminds.core.actors.Contribution" ...
        )
    end

    methods
        function obj = MetaDataModelVersion(structInstance, propValues)
            arguments
                structInstance (1,:) {mustBeA(structInstance, 'struct')} = struct.empty
                propValues.?openminds.core.products.MetaDataModelVersion
                propValues.id (1,1) string
            end
            propValues = namedargs2cell(propValues);
            obj@openminds.abstract.Schema(structInstance, propValues{:})
        end
    end

    methods (Access = protected)
        function str = getDisplayLabel(obj)
            str = sprintf('%s', obj.fullName);
        end
    end
end
