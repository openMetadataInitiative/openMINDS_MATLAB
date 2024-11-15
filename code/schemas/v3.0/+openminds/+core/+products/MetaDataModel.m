classdef MetaDataModel < openminds.abstract.Schema
%MetaDataModel - No description available.
%
%   PROPERTIES:
%
%   custodian         : (1,:) <a href="matlab:help openminds.core.actors.Consortium" style="font-weight:bold">Consortium</a>, <a href="matlab:help openminds.core.actors.Organization" style="font-weight:bold">Organization</a>, <a href="matlab:help openminds.core.actors.Person" style="font-weight:bold">Person</a>
%                       Add all parties that fulfill the role of a custodian for this research product (e.g., a research group leader or principle investigator). Custodians are typically the main contact in case of misconduct, obtain permission from the contributors to publish personal information, and maintain the content and quality of the data, metadata, and/or code of the research product. Unless specified differently, this custodian will be responsible for all attached research product versions.
%
%   description       : (1,1) string
%                       Enter a description (or abstract) of this research product. Note that this should be a suitable description for all attached research product versions.
%
%   developer         : (1,:) <a href="matlab:help openminds.core.actors.Consortium" style="font-weight:bold">Consortium</a>, <a href="matlab:help openminds.core.actors.Organization" style="font-weight:bold">Organization</a>, <a href="matlab:help openminds.core.actors.Person" style="font-weight:bold">Person</a>
%                       Add all parties that developed this (meta)data model.
%
%   digitalIdentifier : (1,1) <a href="matlab:help openminds.core.digitalidentifier.DOI" style="font-weight:bold">DOI</a>, <a href="matlab:help openminds.core.digitalidentifier.SWHID" style="font-weight:bold">SWHID</a>
%                       Add the globally unique and persistent digital identifier of this research product. Note that this digital identifier will be used to reference all attached research product versions.
%
%   fullName          : (1,1) string
%                       Enter a descriptive full name (or title) for this research product. Note that this should be a suitable full name for all attached research product versions.
%
%   hasVersion        : (1,:) <a href="matlab:help openminds.core.products.MetaDataModelVersion" style="font-weight:bold">MetaDataModelVersion</a>
%                       Add all versions of this (meta)data model.
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
        % Add all parties that fulfill the role of a custodian for this research product (e.g., a research group leader or principle investigator). Custodians are typically the main contact in case of misconduct, obtain permission from the contributors to publish personal information, and maintain the content and quality of the data, metadata, and/or code of the research product. Unless specified differently, this custodian will be responsible for all attached research product versions.
        custodian (1,:) openminds.internal.mixedtype.metadatamodel.Custodian ...
            {mustBeListOfUniqueItems(custodian)}

        % Enter a description (or abstract) of this research product. Note that this should be a suitable description for all attached research product versions.
        description (1,1) string

        % Add all parties that developed this (meta)data model.
        developer (1,:) openminds.internal.mixedtype.metadatamodel.Developer ...
            {mustBeListOfUniqueItems(developer)}

        % Add the globally unique and persistent digital identifier of this research product. Note that this digital identifier will be used to reference all attached research product versions.
        digitalIdentifier (1,:) openminds.internal.mixedtype.metadatamodel.DigitalIdentifier ...
            {mustBeSpecifiedLength(digitalIdentifier, 0, 1)}

        % Enter a descriptive full name (or title) for this research product. Note that this should be a suitable full name for all attached research product versions.
        fullName (1,1) string

        % Add all versions of this (meta)data model.
        hasVersion (1,:) openminds.core.products.MetaDataModelVersion ...
            {mustBeListOfUniqueItems(hasVersion)}

        % Enter the internationalized resource identifier (IRI) to the homepage of this research product.
        homepage (1,1) string

        % Enter the preferred citation text for this research product. Leave blank if citation text can be extracted from the assigned digital identifier.
        howToCite (1,1) string

        % Enter a short name (or alias) for this research product that could be used as a shortened display title (e.g., for web services with too little space to display the full name).
        shortName (1,1) string
    end

    properties (Access = protected)
        Required = ["description", "developer", "fullName", "hasVersion", "shortName"]
    end

    properties (Constant, Hidden)
        X_TYPE = "https://openminds.ebrains.eu/core/MetaDataModel"
    end

    properties (Constant, Hidden)
        LINKED_PROPERTIES = struct(...
            'custodian', ["openminds.core.actors.Consortium", "openminds.core.actors.Organization", "openminds.core.actors.Person"], ...
            'developer', ["openminds.core.actors.Consortium", "openminds.core.actors.Organization", "openminds.core.actors.Person"], ...
            'digitalIdentifier', ["openminds.core.digitalidentifier.DOI", "openminds.core.digitalidentifier.SWHID"], ...
            'hasVersion', "openminds.core.products.MetaDataModelVersion" ...
        )
        EMBEDDED_PROPERTIES = struct(...
        )
    end

    methods
        function obj = MetaDataModel(varargin)
            obj@openminds.abstract.Schema(varargin{:})
        end
    end

    methods (Access = protected)
        function str = getDisplayLabel(obj)
            str = sprintf('%s', obj.fullName);
        end
    end
end
