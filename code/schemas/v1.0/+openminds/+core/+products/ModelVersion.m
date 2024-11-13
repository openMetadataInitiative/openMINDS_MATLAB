classdef ModelVersion < openminds.abstract.Schema
%ModelVersion - Structured information on a computational model (version level).
%
%   PROPERTIES:
%
%   abstractionLevel      : (1,1) <a href="matlab:help openminds.controlledterms.ModelAbstractionLevel" style="font-weight:bold">ModelAbstractionLevel</a>
%                           Add the abstraction level of this model version.
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
%   format                : (1,1) <a href="matlab:help openminds.core.data.ContentType" style="font-weight:bold">ContentType</a>
%                           Add the used content type of this model version.
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
%   hasAlternativeVersion : (1,:) <a href="matlab:help openminds.core.products.ModelVersion" style="font-weight:bold">ModelVersion</a>
%                           Add all model versions that can be used alternatively to this model version.
%
%   hasSupplementVersion  : (1,:) <a href="matlab:help openminds.core.products.ModelVersion" style="font-weight:bold">ModelVersion</a>
%                           Add all model versions that supplement this model version.
%
%   homepage              : (1,1) string
%                           Enter the internationalized resource identifier (IRI) to the homepage of this research product version.
%
%   inputData             : (1,1) <a href="matlab:help openminds.core.miscellaneous.DigitalIdentifier" style="font-weight:bold">DigitalIdentifier</a>
%                           Add the data that was used as input for this model version.
%
%   isNewVersionOf        : (1,1) <a href="matlab:help openminds.core.products.ModelVersion" style="font-weight:bold">ModelVersion</a>
%                           Add the model version preceding this model version.
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
%   outputData            : (1,1) <a href="matlab:help openminds.core.miscellaneous.DigitalIdentifier" style="font-weight:bold">DigitalIdentifier</a>
%                           Add the data that was generated as output of this model version.
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
%   scope                 : (1,1) <a href="matlab:help openminds.controlledterms.ModelScope" style="font-weight:bold">ModelScope</a>
%                           Add the scope of this model version.
%
%   shortName             : (1,1) string
%                           Enter a short name (alias) for this research product version (max. 30 characters, no space).
%
%   studyTarget           : (1,:) <a href="matlab:help openminds.controlledterms.BiologicalSex" style="font-weight:bold">BiologicalSex</a>, <a href="matlab:help openminds.controlledterms.Disease" style="font-weight:bold">Disease</a>, <a href="matlab:help openminds.controlledterms.Genotype" style="font-weight:bold">Genotype</a>, <a href="matlab:help openminds.controlledterms.Phenotype" style="font-weight:bold">Phenotype</a>, <a href="matlab:help openminds.controlledterms.Species" style="font-weight:bold">Species</a>, <a href="matlab:help openminds.controlledterms.TermSuggestion" style="font-weight:bold">TermSuggestion</a>, <a href="matlab:help openminds.sands.AnatomicalEntity" style="font-weight:bold">AnatomicalEntity</a>
%                           Add all study targets of this model version.
%
%   versionIdentifier     : (1,1) string
%                           Enter the version identifier of this research product version.
%
%   versionInnovation     : (1,1) string
%                           Enter a short summary of the novelties/peculiarities of this research product version.

%   This class was auto-generated by the openMINDS pipeline

    properties
        % Add the abstraction level of this model version.
        abstractionLevel (1,:) openminds.controlledterms.ModelAbstractionLevel ...
            {mustBeSpecifiedLength(abstractionLevel, 0, 1)}

        % Add the accessibility of the data for this research product version.
        accessibility (1,:) openminds.controlledterms.ProductAccessibility ...
            {mustBeSpecifiedLength(accessibility, 0, 1)}

        % Add one or several authors (person or organization) that contributed to the production and publication of this research product version.
        author (1,:) openminds.internal.mixedtype.modelversion.Author ...
            {mustBeListOfUniqueItems(author)}

        % Add the copyright information of this research product version.
        copyright (1,:) openminds.core.data.Copyright ...
            {mustBeSpecifiedLength(copyright, 0, 1)}

        % Add one or several custodians (person or organization) that are responsible for this research product version.
        custodian (1,:) openminds.internal.mixedtype.modelversion.Custodian ...
            {mustBeListOfUniqueItems(custodian)}

        % Enter a description (abstract) for this research product (max. 2000 characters, incl. spaces; no references).
        description (1,1) string ...
            {mustBeValidStringLength(description, 0, 2000)}

        % Add one or several developers (person or organization) that contributed to the code implementation of this research product version.
        developer (1,:) openminds.internal.mixedtype.modelversion.Developer ...
            {mustBeListOfUniqueItems(developer)}

        % Add the globally unique and persistent digital identifier of this research product version.
        digitalIdentifier (1,:) openminds.core.miscellaneous.DigitalIdentifier ...
            {mustBeSpecifiedLength(digitalIdentifier, 0, 1)}

        % Add the used content type of this model version.
        format (1,:) openminds.core.data.ContentType ...
            {mustBeSpecifiedLength(format, 0, 1)}

        % Add the globally unique and persistent digital identifier of a full documentation of this research product version.
        fullDocumentation (1,:) openminds.core.miscellaneous.DigitalIdentifier ...
            {mustBeSpecifiedLength(fullDocumentation, 0, 1)}

        % Enter a descriptive full name (title) for this research product version.
        fullName (1,1) string

        % Add all funding information of this research product version.
        funding (1,:) openminds.core.miscellaneous.Funding ...
            {mustBeListOfUniqueItems(funding)}

        % Add all model versions that can be used alternatively to this model version.
        hasAlternativeVersion (1,:) openminds.core.products.ModelVersion ...
            {mustBeListOfUniqueItems(hasAlternativeVersion)}

        % Add all model versions that supplement this model version.
        hasSupplementVersion (1,:) openminds.core.products.ModelVersion ...
            {mustBeListOfUniqueItems(hasSupplementVersion)}

        % Enter the internationalized resource identifier (IRI) to the homepage of this research product version.
        homepage (1,1) string

        % Add the data that was used as input for this model version.
        inputData (1,:) openminds.core.miscellaneous.DigitalIdentifier ...
            {mustBeSpecifiedLength(inputData, 0, 1)}

        % Add the model version preceding this model version.
        isNewVersionOf (1,:) openminds.core.products.ModelVersion ...
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

        % Add the data that was generated as output of this model version.
        outputData (1,:) openminds.core.miscellaneous.DigitalIdentifier ...
            {mustBeSpecifiedLength(outputData, 0, 1)}

        % Add further publications besides the documentation (e.g. an original research article) providing the original context for the production of this research product version.
        relatedPublication (1,:) openminds.core.miscellaneous.DigitalIdentifier ...
            {mustBeListOfUniqueItems(relatedPublication)}

        % Enter the date (actual or intended) of the first broadcast/publication of this research product version.
        releaseDate (1,1) string

        % Add the file repository of this research product version.
        repository (1,:) openminds.core.data.FileRepository ...
            {mustBeSpecifiedLength(repository, 0, 1)}

        % Add the scope of this model version.
        scope (1,:) openminds.controlledterms.ModelScope ...
            {mustBeSpecifiedLength(scope, 0, 1)}

        % Enter a short name (alias) for this research product version (max. 30 characters, no space).
        shortName (1,1) string ...
            {mustBeValidStringLength(shortName, 0, 30)}

        % Add all study targets of this model version.
        studyTarget (1,:) openminds.internal.mixedtype.modelversion.StudyTarget ...
            {mustBeListOfUniqueItems(studyTarget)}

        % Enter the version identifier of this research product version.
        versionIdentifier (1,1) string

        % Enter a short summary of the novelties/peculiarities of this research product version.
        versionInnovation (1,1) string
    end

    properties (Access = protected)
        Required = ["abstractionLevel", "accessibility", "description", "developer", "digitalIdentifier", "format", "fullDocumentation", "fullName", "funding", "license", "releaseDate", "repository", "scope", "shortName", "studyTarget", "versionIdentifier"]
    end

    properties (Constant, Hidden)
        X_TYPE = "https://openminds.ebrains.eu/core/ModelVersion"
    end

    properties (Constant, Hidden)
        LINKED_PROPERTIES = struct(...
            'abstractionLevel', "openminds.controlledterms.ModelAbstractionLevel", ...
            'accessibility', "openminds.controlledterms.ProductAccessibility", ...
            'author', ["openminds.core.actors.Organization", "openminds.core.actors.Person"], ...
            'custodian', ["openminds.core.actors.Organization", "openminds.core.actors.Person"], ...
            'developer', ["openminds.core.actors.Organization", "openminds.core.actors.Person"], ...
            'digitalIdentifier', "openminds.core.miscellaneous.DigitalIdentifier", ...
            'format', "openminds.core.data.ContentType", ...
            'fullDocumentation', "openminds.core.miscellaneous.DigitalIdentifier", ...
            'funding', "openminds.core.miscellaneous.Funding", ...
            'hasAlternativeVersion', "openminds.core.products.ModelVersion", ...
            'hasSupplementVersion', "openminds.core.products.ModelVersion", ...
            'inputData', "openminds.core.miscellaneous.DigitalIdentifier", ...
            'isNewVersionOf', "openminds.core.products.ModelVersion", ...
            'license', "openminds.core.data.License", ...
            'otherContribution', "openminds.core.actors.Contribution", ...
            'outputData', "openminds.core.miscellaneous.DigitalIdentifier", ...
            'relatedPublication', "openminds.core.miscellaneous.DigitalIdentifier", ...
            'repository', "openminds.core.data.FileRepository", ...
            'scope', "openminds.controlledterms.ModelScope", ...
            'studyTarget', ["openminds.controlledterms.BiologicalSex", "openminds.controlledterms.Disease", "openminds.controlledterms.Genotype", "openminds.controlledterms.Phenotype", "openminds.controlledterms.Species", "openminds.controlledterms.TermSuggestion", "openminds.sands.AnatomicalEntity"] ...
        )
        EMBEDDED_PROPERTIES = struct(...
            'copyright', "openminds.core.data.Copyright" ...
        )
    end

    methods
        function obj = ModelVersion(varargin)
            obj@openminds.abstract.Schema(varargin{:})
        end
    end

    methods (Access = protected)
        function str = getDisplayLabel(obj)
            str = sprintf('%s', obj.fullName);
        end
    end
end