classdef Strain < openminds.abstract.ControlledTerm
%Strain - No description available.
%
%   PROPERTIES:
%
%   definition         : (1,1) string
%                        Enter one sentence for defining this term.
%
%   description        : (1,1) string
%                        Enter a short text describing this term.
%
%   identifier         : (1,:) string
%                        Enter other database identifiers for the given strain that are supported by the members of the Alliance of Genome Resources (https://www.alliancegenome.org/).
%
%   name               : (1,1) string
%                        Controlled term originating from a defined terminology.
%
%   ontologyIdentifier : (1,1) string
%                        Enter the internationalized resource identifier (IRI) pointing to the related ontological term.

%   This class was auto-generated by the openMINDS pipeline

    properties (Constant, Hidden)
        X_TYPE = "https://openminds.ebrains.eu/controlledTerms/Strain"
    end

    properties (Constant, Hidden)
        CONTROLLED_INSTANCES = [ ...
        ]
    end

    methods
        function obj = Strain(varargin)
            obj@openminds.abstract.ControlledTerm(varargin{:})
        end
    end

    methods (Static)
        function instances = listInstances()
            instances = openminds.controlledterms.Strain.CONTROLLED_INSTANCES';
        end
    end
end
