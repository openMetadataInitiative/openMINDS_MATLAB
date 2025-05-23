classdef ChemicalMixture < openminds.abstract.Schema
%ChemicalMixture - Structured information about a mixture of chemical substances.
%
%   PROPERTIES:
%
%   additionalRemarks : (1,1) string
%                       Enter any additional remarks concerning this chemical mixture.
%
%   hasPart           : (1,:) <a href="matlab:help openminds.chemicals.AmountOfChemical" style="font-weight:bold">AmountOfChemical</a>
%                       Enter all components, including other mixtures, that are part of this chemical mixture.
%
%   name              : (1,1) string
%                       Enter the name of this chemical mixture.
%
%   productSource     : (1,1) <a href="matlab:help openminds.chemicals.ProductSource" style="font-weight:bold">ProductSource</a>
%                       Add the source of this chemical mixture.
%
%   type              : (1,1) <a href="matlab:help openminds.controlledterms.ChemicalMixtureType" style="font-weight:bold">ChemicalMixtureType</a>
%                       Add the type of this mixture.

%   This class was auto-generated by the openMINDS pipeline

    properties
        % Enter any additional remarks concerning this chemical mixture.
        additionalRemarks (1,1) string

        % Enter all components, including other mixtures, that are part of this chemical mixture.
        hasPart (1,:) openminds.chemicals.AmountOfChemical ...
            {mustBeListOfUniqueItems(hasPart)}

        % Enter the name of this chemical mixture.
        name (1,1) string

        % Add the source of this chemical mixture.
        productSource (1,:) openminds.chemicals.ProductSource ...
            {mustBeSpecifiedLength(productSource, 0, 1)}

        % Add the type of this mixture.
        type (1,:) openminds.controlledterms.ChemicalMixtureType ...
            {mustBeSpecifiedLength(type, 0, 1)}
    end

    properties (Access = protected)
        Required = ["hasPart", "type"]
    end

    properties (Constant, Hidden)
        X_TYPE = "https://openminds.om-i.org/types/ChemicalMixture"
    end

    properties (Constant, Hidden)
        LINKED_PROPERTIES = struct(...
            'productSource', "openminds.chemicals.ProductSource", ...
            'type', "openminds.controlledterms.ChemicalMixtureType" ...
        )
        EMBEDDED_PROPERTIES = struct(...
            'hasPart', "openminds.chemicals.AmountOfChemical" ...
        )
    end

    methods
        function obj = ChemicalMixture(varargin)
            obj@openminds.abstract.Schema(varargin{:})
        end
    end

    methods (Access = protected)
        function str = getDisplayLabel(obj)
            str = obj.name;
        end
    end
end
