classdef SubjectAttribute < openminds.abstract.ControlledTerm
%SubjectAttribute - No description available.
%
%   PROPERTIES:
%
%   definition                  : (1,1) string
%                                 Enter one sentence for defining this term.
%
%   description                 : (1,1) string
%                                 Enter a short text describing this term.
%
%   interlexIdentifier          : (1,1) string
%                                 Enter the internationalized resource identifier (IRI) pointing to the integrated ontology entry in the InterLex project.
%
%   knowledgeSpaceLink          : (1,1) string
%                                 Enter the internationalized resource identifier (IRI) pointing to the wiki page of the corresponding term in the KnowledgeSpace.
%
%   name                        : (1,1) string
%                                 Controlled term originating from a defined terminology.
%
%   preferredOntologyIdentifier : (1,1) string
%                                 Enter the internationalized resource identifier (IRI) pointing to the preferred ontological term.
%
%   synonym                     : (1,:) string
%                                 Enter one or several synonyms (including abbreviations) for this controlled term.

%   This class was auto-generated by the openMINDS pipeline

    properties (Constant, Hidden)
        X_TYPE = "https://openminds.om-i.org/types/SubjectAttribute"
    end

    properties (Constant, Hidden)
        CONTROLLED_INSTANCES = [ ...
            "alert", ...
            "alive", ...
            "anaesthetized", ...
            "asleep", ...
            "awake", ...
            "comatose", ...
            "control", ...
            "deceased", ...
            "drugged", ...
            "freelyMoving", ...
            "hasImplantedDevice", ...
            "hasInsertedDevice", ...
            "headRestrained", ...
            "knockin", ...
            "knockout", ...
            "postoperative", ...
            "preoperative", ...
            "restrained", ...
            "treated", ...
            "untreated" ...
        ]
    end

    methods
        function obj = SubjectAttribute(varargin)
            obj@openminds.abstract.ControlledTerm(varargin{:})
        end
    end

    methods (Static)
        function instances = listInstances()
            instances = openminds.controlledterms.SubjectAttribute.CONTROLLED_INSTANCES';
        end
    end
end
