classdef OperatingSystem < openminds.abstract.ControlledTerm
%OperatingSystem - Structured information on the operating system.
%
%   PROPERTIES:
%
%   definition         : (1,1) string
%                        Enter one sentence for defining this term.
%
%   description        : (1,1) string
%                        Enter a short text describing this term.
%
%   name               : (1,1) string
%                        Controlled term originating from a defined terminology.
%
%   ontologyIdentifier : (1,1) string
%                        Enter the internationalized resource identifier (IRI) pointing to the related ontological term.

%   This class was auto-generated by the openMINDS pipeline

    properties (Constant, Hidden)
        X_TYPE = "https://openminds.ebrains.eu/controlledTerms/OperatingSystem"
    end

    properties (Constant, Hidden)
        CONTROLLED_INSTANCES = [ ...
        ]
    end

    methods
        function obj = OperatingSystem(varargin)
            obj@openminds.abstract.ControlledTerm(varargin{:})
        end
    end

    methods (Static)
        function instances = listInstances()
            instances = openminds.controlledterms.OperatingSystem.CONTROLLED_INSTANCES';
        end
    end
end
