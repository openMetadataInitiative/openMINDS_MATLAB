classdef Dataset < openminds.abstract.Schema
%Dataset - Structured information on data originating from human/animal studies or simulations (concept level).
%
%   PROPERTIES:
%
%   author            : (1,:) <a href="matlab:help openminds.core.actors.Consortium" style="font-weight:bold">Consortium</a>, <a href="matlab:help openminds.core.actors.Organization" style="font-weight:bold">Organization</a>, <a href="matlab:help openminds.core.actors.Person" style="font-weight:bold">Person</a>
%                       Add all parties that contributed to this dataset as authors.
%
%   custodian         : (1,:) <a href="matlab:help openminds.core.actors.Consortium" style="font-weight:bold">Consortium</a>, <a href="matlab:help openminds.core.actors.Organization" style="font-weight:bold">Organization</a>, <a href="matlab:help openminds.core.actors.Person" style="font-weight:bold">Person</a>
%                       Add all parties that fulfill the role of a custodian for this research product (e.g., a research group leader or principle investigator). Custodians are typically the main contact in case of misconduct, obtain permission from the contributors to publish personal information, and maintain the content and quality of the data, metadata, and/or code of the research product. Unless specified differently, this custodian will be responsible for all attached research product versions.
%
%   description       : (1,1) string
%                       Enter a description (or abstract) of this research product. Note that this should be a suitable description for all attached research product versions.
%
%   digitalIdentifier : (1,1) <a href="matlab:help openminds.core.digitalidentifier.DOI" style="font-weight:bold">DOI</a>, <a href="matlab:help openminds.core.digitalidentifier.IdentifiersDotOrgID" style="font-weight:bold">IdentifiersDotOrgID</a>
%                       Add the globally unique and persistent digital identifier of this research product. Note that this digital identifier will be used to reference all attached research product versions.
%
%   fullName          : (1,1) string
%                       Enter a descriptive full name (or title) for this research product. Note that this should be a suitable full name for all attached research product versions.
%
%   hasVersion        : (1,:) <a href="matlab:help openminds.core.products.DatasetVersion" style="font-weight:bold">DatasetVersion</a>
%                       Add all versions of this dataset.
%
%   homepage          : (1,1) string
%                       Enter the internationalized resource identifier (IRI) to the homepage of this research product.
%
%   howToCite         : (1,1) string
%                       Enter the preferred citation text for this research product. Leave blank if citation text can be extracted from the assigned digital identifier.
%
%   shortName         : (1,1) string
%                       Enter a short name (or alias) for this research product that could be used as a shortened display title (e.g., for web services with too little space to display the full name).

%   This class was auto-generated by the openMINDS pipeline

    properties
        % Add all parties that contributed to this dataset as authors.
        author (1,:) openminds.internal.mixedtype.dataset.Author ...
            {mustBeListOfUniqueItems(author)}

        % Add all parties that fulfill the role of a custodian for this research product (e.g., a research group leader or principle investigator). Custodians are typically the main contact in case of misconduct, obtain permission from the contributors to publish personal information, and maintain the content and quality of the data, metadata, and/or code of the research product. Unless specified differently, this custodian will be responsible for all attached research product versions.
        custodian (1,:) openminds.internal.mixedtype.dataset.Custodian ...
            {mustBeListOfUniqueItems(custodian)}

        % Enter a description (or abstract) of this research product. Note that this should be a suitable description for all attached research product versions.
        description (1,1) string

        % Add the globally unique and persistent digital identifier of this research product. Note that this digital identifier will be used to reference all attached research product versions.
        digitalIdentifier (1,:) openminds.internal.mixedtype.dataset.DigitalIdentifier ...
            {mustBeSpecifiedLength(digitalIdentifier, 0, 1)}

        % Enter a descriptive full name (or title) for this research product. Note that this should be a suitable full name for all attached research product versions.
        fullName (1,1) string

        % Add all versions of this dataset.
        hasVersion (1,:) openminds.core.products.DatasetVersion ...
            {mustBeListOfUniqueItems(hasVersion)}

        % Enter the internationalized resource identifier (IRI) to the homepage of this research product.
        homepage (1,1) string

        % Enter the preferred citation text for this research product. Leave blank if citation text can be extracted from the assigned digital identifier.
        howToCite (1,1) string

        % Enter a short name (or alias) for this research product that could be used as a shortened display title (e.g., for web services with too little space to display the full name).
        shortName (1,1) string
    end

    properties (Access = protected)
        Required = ["author", "description", "fullName", "hasVersion", "shortName"]
    end

    properties (Constant, Hidden)
        X_TYPE = "https://openminds.ebrains.eu/core/Dataset"
    end

    properties (Constant, Hidden)
        LINKED_PROPERTIES = struct(...
            'author', ["openminds.core.actors.Consortium", "openminds.core.actors.Organization", "openminds.core.actors.Person"], ...
            'custodian', ["openminds.core.actors.Consortium", "openminds.core.actors.Organization", "openminds.core.actors.Person"], ...
            'digitalIdentifier', ["openminds.core.digitalidentifier.DOI", "openminds.core.digitalidentifier.IdentifiersDotOrgID"], ...
            'hasVersion', "openminds.core.products.DatasetVersion" ...
        )
        EMBEDDED_PROPERTIES = struct(...
        )
    end

    methods
        function obj = Dataset(varargin)
            obj@openminds.abstract.Schema(varargin{:})
        end
    end

    methods (Access = protected)
        function str = getDisplayLabel(obj)
            str = sprintf('%s', obj.fullName);
        end
    end
end
