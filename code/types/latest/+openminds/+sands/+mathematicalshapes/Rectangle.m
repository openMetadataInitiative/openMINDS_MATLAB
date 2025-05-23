classdef Rectangle < openminds.abstract.Schema
%Rectangle - No description available.
%
%   PROPERTIES:
%
%   length : (1,1) <a href="matlab:help openminds.core.miscellaneous.QuantitativeValue" style="font-weight:bold">QuantitativeValue</a>
%            Enter the length of this rectangle.
%
%   width  : (1,1) <a href="matlab:help openminds.core.miscellaneous.QuantitativeValue" style="font-weight:bold">QuantitativeValue</a>
%            Enter the width of this rectangle.

%   This class was auto-generated by the openMINDS pipeline

    properties
        % Enter the length of this rectangle.
        length (1,:) openminds.core.miscellaneous.QuantitativeValue ...
            {mustBeSpecifiedLength(length, 0, 1)}

        % Enter the width of this rectangle.
        width (1,:) openminds.core.miscellaneous.QuantitativeValue ...
            {mustBeSpecifiedLength(width, 0, 1)}
    end

    properties (Access = protected)
        Required = ["length", "width"]
    end

    properties (Constant, Hidden)
        X_TYPE = "https://openminds.om-i.org/types/Rectangle"
    end

    properties (Constant, Hidden)
        LINKED_PROPERTIES = struct(...
        )
        EMBEDDED_PROPERTIES = struct(...
            'length', "openminds.core.miscellaneous.QuantitativeValue", ...
            'width', "openminds.core.miscellaneous.QuantitativeValue" ...
        )
    end

    methods
        function obj = Rectangle(varargin)
            obj@openminds.abstract.Schema(varargin{:})
        end
    end

    methods (Access = protected)
        function str = getDisplayLabel(obj)
            str = sprintf('rectangle(L=%s, W=%s)', obj.length, obj.width);
        end
    end
end
