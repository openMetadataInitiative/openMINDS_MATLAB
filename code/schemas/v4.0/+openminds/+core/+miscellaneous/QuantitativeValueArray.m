classdef QuantitativeValueArray < openminds.abstract.Schema
%QuantitativeValueArray - A representation of an array of quantitative values, optionally with uncertainties.
%
%   PROPERTIES:
%
%   negativeUncertainties : (1,:) double
%                           Enter the negative uncertainties for all values. Note that the length of the arrays have to match.
%
%   positiveUncertainties : (1,:) double
%                           Enter the positive uncertainties for all values. Note that the length of the arrays have to match.
%
%   typeOfUncertainty     : (1,1) <a href="matlab:help openminds.controlledterms.TypeOfUncertainty" style="font-weight:bold">TypeOfUncertainty</a>
%                           Add the type of estimation for the uncertainties.
%
%   unit                  : (1,1) <a href="matlab:help openminds.controlledterms.UnitOfMeasurement" style="font-weight:bold">UnitOfMeasurement</a>
%                           Add the unit of measurement of the values and their uncertainties.
%
%   values                : (1,:) double
%                           Enter all measured values.

%   This class was auto-generated by the openMINDS pipeline

    properties
        % Enter the negative uncertainties for all values. Note that the length of the arrays have to match.
        negativeUncertainties (1,:) double

        % Enter the positive uncertainties for all values. Note that the length of the arrays have to match.
        positiveUncertainties (1,:) double

        % Add the type of estimation for the uncertainties.
        typeOfUncertainty (1,:) openminds.controlledterms.TypeOfUncertainty ...
            {mustBeSpecifiedLength(typeOfUncertainty, 0, 1)}

        % Add the unit of measurement of the values and their uncertainties.
        unit (1,:) openminds.controlledterms.UnitOfMeasurement ...
            {mustBeSpecifiedLength(unit, 0, 1)}

        % Enter all measured values.
        values (1,:) double
    end

    properties (Access = protected)
        Required = ["values"]
    end

    properties (Constant, Hidden)
        X_TYPE = "https://openminds.om-i.org/types/QuantitativeValueArray"
    end

    properties (Constant, Hidden)
        LINKED_PROPERTIES = struct(...
            'typeOfUncertainty', "openminds.controlledterms.TypeOfUncertainty", ...
            'unit', "openminds.controlledterms.UnitOfMeasurement" ...
        )
        EMBEDDED_PROPERTIES = struct(...
        )
    end

    methods
        function obj = QuantitativeValueArray(varargin)
            obj@openminds.abstract.Schema(varargin{:})
        end
    end

    methods (Access = protected)
        function str = getDisplayLabel(obj)
            str = obj.createLabelForMissingLabelDefinition();
        end
    end
end
