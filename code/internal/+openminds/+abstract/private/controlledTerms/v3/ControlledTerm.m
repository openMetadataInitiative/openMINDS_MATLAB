classdef (Abstract) ControlledTerm < openminds.abstract.ControlledTermBase
%ControlledTerm Abstract base class for metadata types of the controlled terms module

    properties
        % Enter one sentence for defining this term.
        definition (1,1) string

        % Enter a short text describing this term.
        description (1,1) string

        % Controlled term originating from a defined terminology.
        name (1,1) string

        % Enter all IRIs pointing to cross-references to external databases or registries that are equivalent to this term.
        otherCrossReference (1,:) string {mustBeListOfUniqueItems(otherCrossReference)}

        % Enter all IRIs pointing to ontology entries that are equivalent to this term.
        otherOntologyIdentifier (1,:) string {mustBeListOfUniqueItems(otherOntologyIdentifier)}

        % Enter the IRI pointing to the preferred cross-reference to an external database or registry.
        preferredCrossReference (1,1) string

        % Enter the internationalized resource identifier (IRI) pointing to the preferred ontological term.
        preferredOntologyIdentifier (1,1) string

        % Enter one or several synonyms (including abbreviations) for this controlled term.
        synonym (1,:) string {mustBeListOfUniqueItems(synonym)}
    end

    methods
        function obj = ControlledTerm(instanceSpec, propValues)
            arguments
                instanceSpec = []
                propValues.?openminds.abstract.ControlledTerm
                propValues.id (1,1) string
            end

            obj.initializeControlledTerm(instanceSpec, propValues)
        end
    end
end
