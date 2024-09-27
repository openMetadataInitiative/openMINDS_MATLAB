classdef QuantitativeValueRange < openminds.abstract.Schema
%QuantitativeValueRange - A representation of a range of quantitative values.
%
%   PROPERTIES:
%
%   maxValue     : (1,1) double
%                  Enter the maximum value.
%
%   maxValueUnit : (1,1) <a href="matlab:help openminds.controlledterms.UnitOfMeasurement" style="font-weight:bold">UnitOfMeasurement</a>
%                  Add the unit of measurement for the maximum value.
%
%   minValue     : (1,1) double
%                  Enter the minimum value.
%
%   minValueUnit : (1,1) <a href="matlab:help openminds.controlledterms.UnitOfMeasurement" style="font-weight:bold">UnitOfMeasurement</a>
%                  Add the unit of measurement for the minimum value.

%   This class was auto-generated by the openMINDS pipeline

    properties
        % Enter the maximum value.
        maxValue (1,1) double

        % Add the unit of measurement for the maximum value.
        maxValueUnit (1,:) openminds.controlledterms.UnitOfMeasurement ...
            {mustBeSpecifiedLength(maxValueUnit, 0, 1)}

        % Enter the minimum value.
        minValue (1,1) double

        % Add the unit of measurement for the minimum value.
        minValueUnit (1,:) openminds.controlledterms.UnitOfMeasurement ...
            {mustBeSpecifiedLength(minValueUnit, 0, 1)}
    end

    properties (Access = protected)
        Required = ["maxValue", "minValue"]
    end

    properties (Constant, Hidden)
        X_TYPE = "https://openminds.ebrains.eu/core/QuantitativeValueRange"
    end

    properties (Constant, Hidden)
        LINKED_PROPERTIES = struct(...
            'maxValueUnit', "openminds.controlledterms.UnitOfMeasurement", ...
            'minValueUnit', "openminds.controlledterms.UnitOfMeasurement" ...
        )
        EMBEDDED_PROPERTIES = struct(...
        )
    end

    methods
        function obj = QuantitativeValueRange(varargin)
            obj@openminds.abstract.Schema(varargin{:})
        end
    end

    methods (Access = protected)
        function str = getDisplayLabel(obj)
            str = '<missing name>';
        end
    end

end