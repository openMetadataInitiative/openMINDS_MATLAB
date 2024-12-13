classdef ChemicalSubstance < openminds.abstract.Schema
%ChemicalSubstance - Structured information about a chemical substance.
%
%   PROPERTIES:
%
%   additionalRemarks : (1,1) string
%                       Enter any additional remarks concering this chemical substance.
%
%   lookupLabel       : (1,1) string
%                       Enter a lookup label for this chemical substance that may help you to find this instance more easily.
%
%   molecularEntity   : (1,1) <a href="matlab:help openminds.controlledterms.MolecularEntity" style="font-weight:bold">MolecularEntity</a>
%                       Add the molecular entity that makes up this chemical substance.
%
%   productSource     : (1,1) <a href="matlab:help openminds.chemicals.ProductSource" style="font-weight:bold">ProductSource</a>
%                       Add the source of this chemical substance.
%
%   purity            : (1,1) <a href="matlab:help openminds.core.miscellaneous.QuantitativeValue" style="font-weight:bold">QuantitativeValue</a>, <a href="matlab:help openminds.core.miscellaneous.QuantitativeValueRange" style="font-weight:bold">QuantitativeValueRange</a>
%                       Enter the purity of this chemical substance.

%   This class was auto-generated by the openMINDS pipeline

    properties
        % Enter any additional remarks concering this chemical substance.
        additionalRemarks (1,1) string

        % Enter a lookup label for this chemical substance that may help you to find this instance more easily.
        lookupLabel (1,1) string

        % Add the molecular entity that makes up this chemical substance.
        molecularEntity (1,:) openminds.controlledterms.MolecularEntity ...
            {mustBeSpecifiedLength(molecularEntity, 0, 1)}

        % Add the source of this chemical substance.
        productSource (1,:) openminds.chemicals.ProductSource ...
            {mustBeSpecifiedLength(productSource, 0, 1)}

        % Enter the purity of this chemical substance.
        purity (1,:) openminds.internal.mixedtype.chemicalsubstance.Purity ...
            {mustBeSpecifiedLength(purity, 0, 1)}
    end

    properties (Access = protected)
        Required = ["molecularEntity"]
    end

    properties (Constant, Hidden)
        X_TYPE = "https://openminds.ebrains.eu/chemicals/ChemicalSubstance"
    end

    properties (Constant, Hidden)
        LINKED_PROPERTIES = struct(...
            'molecularEntity', "openminds.controlledterms.MolecularEntity", ...
            'productSource', "openminds.chemicals.ProductSource" ...
        )
        EMBEDDED_PROPERTIES = struct(...
            'purity', ["openminds.core.miscellaneous.QuantitativeValue", "openminds.core.miscellaneous.QuantitativeValueRange"] ...
        )
    end

    methods
        function obj = ChemicalSubstance(varargin)
            obj@openminds.abstract.Schema(varargin{:})
        end
    end

    methods (Access = protected)
        function str = getDisplayLabel(obj)
            str = obj.lookupLabel;
        end
    end
end
