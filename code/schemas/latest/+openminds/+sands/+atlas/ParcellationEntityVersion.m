classdef ParcellationEntityVersion < openminds.abstract.Schema
%ParcellationEntityVersion - No description available.
%
%   PROPERTIES:
%
%   abbreviation       : (1,1) string
%                        Enter the official abbreviation of this parcellation entity version.
%
%   additionalRemarks  : (1,1) string
%                        Enter any additional remarks concerning this parcellation entity version.
%
%   alternateName      : (1,:) string
%                        Enter any alternate names, including any alternative abbreviations, for this parcellation entity version.
%
%   correctedName      : (1,1) string
%                        Enter the refined or corrected name of this parcellation entity version.
%
%   hasAnnotation      : (1,:) <a href="matlab:help openminds.sands.atlas.AtlasAnnotation" style="font-weight:bold">AtlasAnnotation</a>
%                        Add all atlas annotations which define this parcellation entity version.
%
%   hasParent          : (1,:) <a href="matlab:help openminds.sands.atlas.ParcellationEntity" style="font-weight:bold">ParcellationEntity</a>, <a href="matlab:help openminds.sands.atlas.ParcellationEntityVersion" style="font-weight:bold">ParcellationEntityVersion</a>
%                        Add all anatomical parent structures (or version of the structures) for this parcellation entity as defined within corresponding brain atlas version.
%
%   lookupLabel        : (1,1) string
%                        Enter a lookup label for this parcellation entity version that may help you to find this instance more easily.
%
%   name               : (1,1) string
%                        Enter the name of this parcellation entity version.
%
%   ontologyIdentifier : (1,:) string
%                        Enter the internationalized resource identifiers (IRIs) to the related ontological terms matching this parcellation entity version.
%
%   relationAssessment : (1,:) <a href="matlab:help openminds.sands.miscellaneous.QualitativeRelationAssessment" style="font-weight:bold">QualitativeRelationAssessment</a>, <a href="matlab:help openminds.sands.miscellaneous.QuantitativeRelationAssessment" style="font-weight:bold">QuantitativeRelationAssessment</a>
%                        Add all relations (qualitative or quantitative) of this parcellation entity version to other anatomical entities.
%
%   versionIdentifier  : (1,1) string
%                        Enter the version identifier of this parcellation entity version.
%
%   versionInnovation  : (1,1) string
%                        Enter a short description (or summary) of the novelties/peculiarities of this parcellation entity version in comparison to its preceding versions. If this parcellation entity version is the first version, leave blank.

%   This class was auto-generated by the openMINDS pipeline

    properties
        % Enter the official abbreviation of this parcellation entity version.
        abbreviation (1,1) string

        % Enter any additional remarks concerning this parcellation entity version.
        additionalRemarks (1,1) string

        % Enter any alternate names, including any alternative abbreviations, for this parcellation entity version.
        alternateName (1,:) string ...
            {mustBeListOfUniqueItems(alternateName)}

        % Enter the refined or corrected name of this parcellation entity version.
        correctedName (1,1) string

        % Add all atlas annotations which define this parcellation entity version.
        hasAnnotation (1,:) openminds.sands.atlas.AtlasAnnotation ...
            {mustBeListOfUniqueItems(hasAnnotation)}

        % Add all anatomical parent structures (or version of the structures) for this parcellation entity as defined within corresponding brain atlas version.
        hasParent (1,:) openminds.internal.mixedtype.parcellationentityversion.HasParent ...
            {mustBeListOfUniqueItems(hasParent)}

        % Enter a lookup label for this parcellation entity version that may help you to find this instance more easily.
        lookupLabel (1,1) string

        % Enter the name of this parcellation entity version.
        name (1,1) string

        % Enter the internationalized resource identifiers (IRIs) to the related ontological terms matching this parcellation entity version.
        ontologyIdentifier (1,:) string ...
            {mustBeListOfUniqueItems(ontologyIdentifier)}

        % Add all relations (qualitative or quantitative) of this parcellation entity version to other anatomical entities.
        relationAssessment (1,:) openminds.internal.mixedtype.parcellationentityversion.RelationAssessment ...
            {mustBeListOfUniqueItems(relationAssessment)}

        % Enter the version identifier of this parcellation entity version.
        versionIdentifier (1,1) string

        % Enter a short description (or summary) of the novelties/peculiarities of this parcellation entity version in comparison to its preceding versions. If this parcellation entity version is the first version, leave blank.
        versionInnovation (1,1) string
    end

    properties (Access = protected)
        Required = ["name", "versionIdentifier"]
    end

    properties (Constant, Hidden)
        X_TYPE = "https://openminds.om-i.org/types/ParcellationEntityVersion"
    end

    properties (Constant, Hidden)
        LINKED_PROPERTIES = struct(...
            'hasParent', ["openminds.sands.atlas.ParcellationEntity", "openminds.sands.atlas.ParcellationEntityVersion"] ...
        )
        EMBEDDED_PROPERTIES = struct(...
            'hasAnnotation', "openminds.sands.atlas.AtlasAnnotation", ...
            'relationAssessment', ["openminds.sands.miscellaneous.QualitativeRelationAssessment", "openminds.sands.miscellaneous.QuantitativeRelationAssessment"] ...
        )
    end

    methods
        function obj = ParcellationEntityVersion(varargin)
            obj@openminds.abstract.Schema(varargin{:})
        end
    end

    methods (Access = protected)
        function str = getDisplayLabel(obj)
            str = obj.lookupLabel;
        end
    end
end
