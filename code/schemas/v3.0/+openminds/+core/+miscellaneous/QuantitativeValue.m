classdef QuantitativeValue < openminds.abstract.Schema
%QuantitativeValue - Structured information on a quantitative value.
%
%   PROPERTIES:
%
%   typeOfUncertainty : (1,1) <a href="matlab:help openminds.controlledterms.TypeOfUncertainty" style="font-weight:bold">TypeOfUncertainty</a>
%                       Add the type of uncertainty used to determine the uncertainty for this quantitative value.
%
%   uncertainty       : (1,:) double
%                       Enter the uncertainty of this quantitative value.
%
%   unit              : (1,1) <a href="matlab:help openminds.controlledterms.UnitOfMeasurement" style="font-weight:bold">UnitOfMeasurement</a>
%                       Add the unit of measurement of this quantitative value and its uncertainty.
%
%   value             : (1,1) double
%                       Enter the value of this quantitative value.

%   This class was auto-generated by the openMINDS pipeline

    properties
        % Add the type of uncertainty used to determine the uncertainty for this quantitative value.
        typeOfUncertainty (1,:) openminds.controlledterms.TypeOfUncertainty ...
            {mustBeSpecifiedLength(typeOfUncertainty, 0, 1)}

        % Enter the uncertainty of this quantitative value.
        uncertainty (1,:) double ...
            {mustBeSpecifiedLength(uncertainty, 2, 2)}

        % Add the unit of measurement of this quantitative value and its uncertainty.
        unit (1,:) openminds.controlledterms.UnitOfMeasurement ...
            {mustBeSpecifiedLength(unit, 0, 1)}

        % Enter the value of this quantitative value.
        value (1,1) double
    end

    properties (Access = protected)
        Required = ["value"]
    end

    properties (Constant, Hidden)
        X_TYPE = "https://openminds.ebrains.eu/core/QuantitativeValue"
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
        function obj = QuantitativeValue(varargin)
            obj@openminds.abstract.Schema(varargin{:})
        end
    end

    methods (Access = protected)
        function str = getDisplayLabel(obj)
            if obj.value ~= 1
                str = sprintf('%d %ss', obj.value, obj.unit);
            else
                str = sprintf('%d %s', obj.value, obj.unit);
            end
        end
    end

end