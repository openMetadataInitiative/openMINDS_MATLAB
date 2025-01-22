classdef ParcellationEntity < openminds.abstract.Schema
%ParcellationEntity - No description available.
%
%   PROPERTIES:
%
%   abbreviation       : (1,1) string
%                        Enter the official abbreviation of this parcellation entity.
%
%   alternateName      : (1,:) string
%                        Enter any alternate names, including any alternative abbreviations, for this parcellation entity.
%
%   definition         : (1,1) string
%                        Enter the definition for this parcellation entity.
%
%   hasParent          : (1,:) <a href="matlab:help openminds.sands.atlas.ParcellationEntity" style="font-weight:bold">ParcellationEntity</a>
%                        Add all anatomical parent structures for this parcellation entity as defined within the corresponding brain atlas.
%
%   hasVersion         : (1,:) <a href="matlab:help openminds.sands.atlas.ParcellationEntityVersion" style="font-weight:bold">ParcellationEntityVersion</a>
%                        Add all versions of this parcellation entity.
%
%   lookupLabel        : (1,1) string
%                        Enter a lookup label for this parcellation entity that may help you to find this instance more easily.
%
%   name               : (1,1) string
%                        Enter the name of this parcellation entity.
%
%   ontologyIdentifier : (1,:) string
%                        Enter the internationalized resource identifiers (IRIs) to the related ontological terms matching this parcellation entity.
%
%   relatedUBERONTerm  : (1,1) <a href="matlab:help openminds.controlledterms.Organ" style="font-weight:bold">Organ</a>, <a href="matlab:help openminds.controlledterms.UBERONParcellation" style="font-weight:bold">UBERONParcellation</a>
%                        Add the related anatomical entity as defined by the UBERON ontology.

%   This class was auto-generated by the openMINDS pipeline

    properties
        % Enter the official abbreviation of this parcellation entity.
        abbreviation (1,1) string

        % Enter any alternate names, including any alternative abbreviations, for this parcellation entity.
        alternateName (1,:) string ...
            {mustBeListOfUniqueItems(alternateName)}

        % Enter the definition for this parcellation entity.
        definition (1,1) string

        % Add all anatomical parent structures for this parcellation entity as defined within the corresponding brain atlas.
        hasParent (1,:) openminds.sands.atlas.ParcellationEntity ...
            {mustBeListOfUniqueItems(hasParent)}

        % Add all versions of this parcellation entity.
        hasVersion (1,:) openminds.sands.atlas.ParcellationEntityVersion ...
            {mustBeListOfUniqueItems(hasVersion)}

        % Enter a lookup label for this parcellation entity that may help you to find this instance more easily.
        lookupLabel (1,1) string

        % Enter the name of this parcellation entity.
        name (1,1) string

        % Enter the internationalized resource identifiers (IRIs) to the related ontological terms matching this parcellation entity.
        ontologyIdentifier (1,:) string ...
            {mustBeListOfUniqueItems(ontologyIdentifier)}

        % Add the related anatomical entity as defined by the UBERON ontology.
        relatedUBERONTerm (1,:) openminds.internal.mixedtype.parcellationentity.RelatedUBERONTerm ...
            {mustBeSpecifiedLength(relatedUBERONTerm, 0, 1)}
    end

    properties (Access = protected)
        Required = ["name"]
    end

    properties (Constant, Hidden)
        X_TYPE = "https://openminds.ebrains.eu/sands/ParcellationEntity"
    end

    properties (Constant, Hidden)
        LINKED_PROPERTIES = struct(...
            'hasParent', "openminds.sands.atlas.ParcellationEntity", ...
            'hasVersion', "openminds.sands.atlas.ParcellationEntityVersion", ...
            'relatedUBERONTerm', ["openminds.controlledterms.Organ", "openminds.controlledterms.UBERONParcellation"] ...
        )
        EMBEDDED_PROPERTIES = struct(...
        )
    end

    methods
        function obj = ParcellationEntity(varargin)
            obj@openminds.abstract.Schema(varargin{:})
        end
    end

    methods (Access = protected)
        function str = getDisplayLabel(obj)
            str = obj.lookupLabel;
        end
    end
end
