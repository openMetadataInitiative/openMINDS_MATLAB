classdef AnatomicalEntity < openminds.abstract.Schema
%AnatomicalEntity - Structured information on an anatomical entity.
%
%   PROPERTIES:
%
%   hasParent               : (1,1) <a href="matlab:help openminds.sands.AnatomicalEntity" style="font-weight:bold">AnatomicalEntity</a>
%                             Add another anatomical entity representing the anatomical parent structure of this anatomical entity.
%
%   name                    : (1,1) string
%                             Enter a descriptive name for this anatomical entity based on anatomical location or characteristics.
%
%   ontologyIdentifier      : (1,1) string
%                             Enter the internationalized resource identifier (IRI) pointing to the ontological term matching this anatomical entity.
%
%   otherAnatomicalRelation : (1,:) <a href="matlab:help openminds.sands.AnatomicalEntityRelation" style="font-weight:bold">AnatomicalEntityRelation</a>
%                             Add one or several relations of this anatomical entity to other anatomical entities that are used elsewhere to describe (roughly) the same anatomical location.

%   This class was auto-generated by the openMINDS pipeline

    properties
        % Add another anatomical entity representing the anatomical parent structure of this anatomical entity.
        hasParent (1,:) openminds.sands.AnatomicalEntity ...
            {mustBeSpecifiedLength(hasParent, 0, 1)}

        % Enter a descriptive name for this anatomical entity based on anatomical location or characteristics.
        name (1,1) string

        % Enter the internationalized resource identifier (IRI) pointing to the ontological term matching this anatomical entity.
        ontologyIdentifier (1,1) string

        % Add one or several relations of this anatomical entity to other anatomical entities that are used elsewhere to describe (roughly) the same anatomical location.
        otherAnatomicalRelation (1,:) openminds.sands.AnatomicalEntityRelation ...
            {mustBeListOfUniqueItems(otherAnatomicalRelation)}
    end

    properties (Access = protected)
        Required = ["name"]
    end

    properties (Constant, Hidden)
        X_TYPE = "https://openminds.ebrains.eu/sands/AnatomicalEntity"
    end

    properties (Constant, Hidden)
        LINKED_PROPERTIES = struct(...
            'hasParent', "openminds.sands.AnatomicalEntity", ...
            'otherAnatomicalRelation', "openminds.sands.AnatomicalEntityRelation" ...
        )
        EMBEDDED_PROPERTIES = struct(...
        )
    end

    methods
        function obj = AnatomicalEntity(varargin)
            obj@openminds.abstract.Schema(varargin{:})
        end
    end

    methods (Access = protected)
        function str = getDisplayLabel(obj)
            str = obj.name;
        end
    end
end
