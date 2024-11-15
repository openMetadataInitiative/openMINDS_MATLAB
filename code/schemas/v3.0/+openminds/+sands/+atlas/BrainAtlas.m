classdef BrainAtlas < openminds.abstract.Schema
%BrainAtlas - No description available.
%
%   PROPERTIES:
%
%   abbreviation       : (1,1) string
%                        Enter the official abbreviation of this brain atlas.
%
%   author             : (1,:) <a href="matlab:help openminds.core.actors.Consortium" style="font-weight:bold">Consortium</a>, <a href="matlab:help openminds.core.actors.Organization" style="font-weight:bold">Organization</a>, <a href="matlab:help openminds.core.actors.Person" style="font-weight:bold">Person</a>
%                        Add all parties that contributed to this brain atlas as authors.
%
%   custodian          : (1,:) <a href="matlab:help openminds.core.actors.Consortium" style="font-weight:bold">Consortium</a>, <a href="matlab:help openminds.core.actors.Organization" style="font-weight:bold">Organization</a>, <a href="matlab:help openminds.core.actors.Person" style="font-weight:bold">Person</a>
%                        Add all parties that fulfill the role of a custodian for this research product (e.g., a research group leader or principle investigator). Custodians are typically the main contact in case of misconduct, obtain permission from the contributors to publish personal information, and maintain the content and quality of the data, metadata, and/or code of the research product. Unless specified differently, this custodian will be responsible for all attached research product versions.
%
%   description        : (1,1) string
%                        Enter a description (or abstract) of this research product. Note that this should be a suitable description for all attached research product versions.
%
%   digitalIdentifier  : (1,1) <a href="matlab:help openminds.core.digitalidentifier.DOI" style="font-weight:bold">DOI</a>, <a href="matlab:help openminds.core.digitalidentifier.ISBN" style="font-weight:bold">ISBN</a>, <a href="matlab:help openminds.core.digitalidentifier.RRID" style="font-weight:bold">RRID</a>
%                        Add the globally unique and persistent digital identifier of this research product. Note that this digital identifier will be used to reference all attached research product versions.
%
%   fullName           : (1,1) string
%                        Enter a descriptive full name (or title) for this research product. Note that this should be a suitable full name for all attached research product versions.
%
%   hasTerminology     : (1,1) <a href="matlab:help openminds.sands.atlas.ParcellationTerminology" style="font-weight:bold">ParcellationTerminology</a>
%                        Enter the parcellation terminology of this brain atlas.
%
%   hasVersion         : (1,:) <a href="matlab:help openminds.sands.atlas.BrainAtlasVersion" style="font-weight:bold">BrainAtlasVersion</a>
%                        Add versions of this brain atlas.
%
%   homepage           : (1,1) string
%                        Enter the internationalized resource identifier (IRI) to the homepage of this research product.
%
%   howToCite          : (1,1) string
%                        Enter the preferred citation text for this research product. Leave blank if citation text can be extracted from the assigned digital identifier.
%
%   ontologyIdentifier : (1,1) string
%                        Enter the internationalized resource identifier (IRI) to the related ontological term matching this brain atlas.
%
%   shortName          : (1,1) string
%                        Enter a short name (or alias) for this research product that could be used as a shortened display title (e.g., for web services with too little space to display the full name).
%
%   usedSpecies        : (1,1) <a href="matlab:help openminds.controlledterms.Species" style="font-weight:bold">Species</a>
%                        Add the species that was used for the creation of this brain atlas.

%   This class was auto-generated by the openMINDS pipeline

    properties
        % Enter the official abbreviation of this brain atlas.
        abbreviation (1,1) string

        % Add all parties that contributed to this brain atlas as authors.
        author (1,:) openminds.internal.mixedtype.brainatlas.Author ...
            {mustBeListOfUniqueItems(author)}

        % Add all parties that fulfill the role of a custodian for this research product (e.g., a research group leader or principle investigator). Custodians are typically the main contact in case of misconduct, obtain permission from the contributors to publish personal information, and maintain the content and quality of the data, metadata, and/or code of the research product. Unless specified differently, this custodian will be responsible for all attached research product versions.
        custodian (1,:) openminds.internal.mixedtype.brainatlas.Custodian ...
            {mustBeListOfUniqueItems(custodian)}

        % Enter a description (or abstract) of this research product. Note that this should be a suitable description for all attached research product versions.
        description (1,1) string

        % Add the globally unique and persistent digital identifier of this research product. Note that this digital identifier will be used to reference all attached research product versions.
        digitalIdentifier (1,:) openminds.internal.mixedtype.brainatlas.DigitalIdentifier ...
            {mustBeSpecifiedLength(digitalIdentifier, 0, 1)}

        % Enter a descriptive full name (or title) for this research product. Note that this should be a suitable full name for all attached research product versions.
        fullName (1,1) string

        % Enter the parcellation terminology of this brain atlas.
        hasTerminology (1,:) openminds.sands.atlas.ParcellationTerminology ...
            {mustBeSpecifiedLength(hasTerminology, 0, 1)}

        % Add versions of this brain atlas.
        hasVersion (1,:) openminds.sands.atlas.BrainAtlasVersion ...
            {mustBeListOfUniqueItems(hasVersion)}

        % Enter the internationalized resource identifier (IRI) to the homepage of this research product.
        homepage (1,1) string

        % Enter the preferred citation text for this research product. Leave blank if citation text can be extracted from the assigned digital identifier.
        howToCite (1,1) string

        % Enter the internationalized resource identifier (IRI) to the related ontological term matching this brain atlas.
        ontologyIdentifier (1,1) string

        % Enter a short name (or alias) for this research product that could be used as a shortened display title (e.g., for web services with too little space to display the full name).
        shortName (1,1) string

        % Add the species that was used for the creation of this brain atlas.
        usedSpecies (1,:) openminds.controlledterms.Species ...
            {mustBeSpecifiedLength(usedSpecies, 0, 1)}
    end

    properties (Access = protected)
        Required = ["author", "description", "fullName", "hasTerminology", "hasVersion", "shortName"]
    end

    properties (Constant, Hidden)
        X_TYPE = "https://openminds.ebrains.eu/sands/BrainAtlas"
    end

    properties (Constant, Hidden)
        LINKED_PROPERTIES = struct(...
            'author', ["openminds.core.actors.Consortium", "openminds.core.actors.Organization", "openminds.core.actors.Person"], ...
            'custodian', ["openminds.core.actors.Consortium", "openminds.core.actors.Organization", "openminds.core.actors.Person"], ...
            'digitalIdentifier', ["openminds.core.digitalidentifier.DOI", "openminds.core.digitalidentifier.ISBN", "openminds.core.digitalidentifier.RRID"], ...
            'hasVersion', "openminds.sands.atlas.BrainAtlasVersion", ...
            'usedSpecies', "openminds.controlledterms.Species" ...
        )
        EMBEDDED_PROPERTIES = struct(...
            'hasTerminology', "openminds.sands.atlas.ParcellationTerminology" ...
        )
    end

    methods
        function obj = BrainAtlas(varargin)
            obj@openminds.abstract.Schema(varargin{:})
        end
    end

    methods (Access = protected)
        function str = getDisplayLabel(obj)
            str = obj.fullName;
        end
    end
end
