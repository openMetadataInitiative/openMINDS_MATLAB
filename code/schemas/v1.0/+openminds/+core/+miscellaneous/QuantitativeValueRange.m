classdef QuantitativeValueRange < openminds.abstract.Schema
%QuantitativeValueRange - A representation of a range of quantitative values.
%
%   PROPERTIES:
%
%   maxValue : (1,1) <a href="matlab:help openminds.core.miscellaneous.QuantitativeValue" style="font-weight:bold">QuantitativeValue</a>
%              Add the maximum quantitative value of this range.
%
%   minValue : (1,1) <a href="matlab:help openminds.core.miscellaneous.QuantitativeValue" style="font-weight:bold">QuantitativeValue</a>
%              Add the minimum quantitative value of this range.

%   This class was auto-generated by the openMINDS pipeline

    properties
        % Add the maximum quantitative value of this range.
        maxValue (1,:) openminds.core.miscellaneous.QuantitativeValue ...
            {mustBeSpecifiedLength(maxValue, 0, 1)}

        % Add the minimum quantitative value of this range.
        minValue (1,:) openminds.core.miscellaneous.QuantitativeValue ...
            {mustBeSpecifiedLength(minValue, 0, 1)}
    end

    properties (Access = protected)
        Required = ["maxValue", "minValue"]
    end

    properties (Constant, Hidden)
        X_TYPE = "https://openminds.ebrains.eu/core/QuantitativeValueRange"
    end

    properties (Constant, Hidden)
        LINKED_PROPERTIES = struct(...
        )
        EMBEDDED_PROPERTIES = struct(...
            'maxValue', "openminds.core.miscellaneous.QuantitativeValue", ...
            'minValue', "openminds.core.miscellaneous.QuantitativeValue" ...
        )
    end

    methods
        function obj = QuantitativeValueRange(varargin)
            obj@openminds.abstract.Schema(varargin{:})
        end
    end

    methods (Access = protected)
        function str = getDisplayLabel(obj)
            str = obj.createLabelForMissingLabelDefinition();
        end
    end
end
