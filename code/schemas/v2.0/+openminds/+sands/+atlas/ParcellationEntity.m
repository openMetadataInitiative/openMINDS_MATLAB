classdef ParcellationEntity < openminds.abstract.Schema
%ParcellationEntity - No description available.
%
%   PROPERTIES:
%
%   hasAnnotation      : (1,1) <a href="matlab:help openminds.sands.atlas.AtlasAnnotation" style="font-weight:bold">AtlasAnnotation</a>
%                        Add the atlas annotation which this parcellation entity defines.
%
%   hasParent          : (1,1) <a href="matlab:help openminds.sands.atlas.ParcellationEntity" style="font-weight:bold">ParcellationEntity</a>
%                        Add for this parcellation entity the defined anatomical parent structure.
%
%   isPartOf           : (1,:) <a href="matlab:help openminds.sands.atlas.ParcellationTerminology" style="font-weight:bold">ParcellationTerminology</a>
%                        Add one or several parcellation terminologies to which this parcellation entity belongs.
%
%   name               : (1,1) string
%                        Enter the name for this parcellation entity.
%
%   ontologyIdentifier : (1,1) string
%                        Enter the internationalized resource identifier (IRI) pointing to the ontological term matching this parcellation entity.
%
%   relatedUBERONTerm  : (1,1) <a href="matlab:help openminds.controlledterms.UBERONParcellation" style="font-weight:bold">UBERONParcellation</a>
%                        Add the related UBERON parcellation term.
%
%   relationAssessment : (1,:) <a href="matlab:help openminds.sands.miscellaneous.QualitativeRelationAssessment" style="font-weight:bold">QualitativeRelationAssessment</a>, <a href="matlab:help openminds.sands.miscellaneous.QuantitativeRelationAssessment" style="font-weight:bold">QuantitativeRelationAssessment</a>
%                        Add one or several relations of this parcellation entity to parcellation entities of other parcellation terminologies.
%
%   versionIdentifier  : (1,1) string
%                        Enter the version identifier of this parcellation entity.
%
%   versionInnovation  : (1,1) string
%                        Enter a short description of the novelties/peculiarities of this parcellation entity.

%   This class was auto-generated by the openMINDS pipeline

    properties
        % Add the atlas annotation which this parcellation entity defines.
        hasAnnotation (1,:) openminds.sands.atlas.AtlasAnnotation ...
            {mustBeSpecifiedLength(hasAnnotation, 0, 1)}

        % Add for this parcellation entity the defined anatomical parent structure.
        hasParent (1,:) openminds.sands.atlas.ParcellationEntity ...
            {mustBeSpecifiedLength(hasParent, 0, 1)}

        % Add one or several parcellation terminologies to which this parcellation entity belongs.
        isPartOf (1,:) openminds.sands.atlas.ParcellationTerminology ...
            {mustBeListOfUniqueItems(isPartOf)}

        % Enter the name for this parcellation entity.
        name (1,1) string

        % Enter the internationalized resource identifier (IRI) pointing to the ontological term matching this parcellation entity.
        ontologyIdentifier (1,1) string

        % Add the related UBERON parcellation term.
        relatedUBERONTerm (1,:) openminds.controlledterms.UBERONParcellation ...
            {mustBeSpecifiedLength(relatedUBERONTerm, 0, 1)}

        % Add one or several relations of this parcellation entity to parcellation entities of other parcellation terminologies.
        relationAssessment (1,:) openminds.internal.mixedtype.parcellationentity.RelationAssessment ...
            {mustBeListOfUniqueItems(relationAssessment)}

        % Enter the version identifier of this parcellation entity.
        versionIdentifier (1,1) string

        % Enter a short description of the novelties/peculiarities of this parcellation entity.
        versionInnovation (1,1) string
    end

    properties (Access = protected)
        Required = ["isPartOf", "name", "relatedUBERONTerm", "versionIdentifier", "versionInnovation"]
    end

    properties (Constant, Hidden)
        X_TYPE = "https://openminds.ebrains.eu/sands/ParcellationEntity"
    end

    properties (Constant, Hidden)
        LINKED_PROPERTIES = struct(...
            'hasAnnotation', "openminds.sands.atlas.AtlasAnnotation", ...
            'hasParent', "openminds.sands.atlas.ParcellationEntity", ...
            'isPartOf', "openminds.sands.atlas.ParcellationTerminology", ...
            'relatedUBERONTerm', "openminds.controlledterms.UBERONParcellation" ...
        )
        EMBEDDED_PROPERTIES = struct(...
            'relationAssessment', ["openminds.sands.miscellaneous.QualitativeRelationAssessment", "openminds.sands.miscellaneous.QuantitativeRelationAssessment"] ...
        )
    end

    methods
        function obj = ParcellationEntity(varargin)
            obj@openminds.abstract.Schema(varargin{:})
        end
    end

    methods (Access = protected)
        function str = getDisplayLabel(obj)
            str = obj.name;
        end
    end
end