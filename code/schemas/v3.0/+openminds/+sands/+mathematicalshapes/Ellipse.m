classdef Ellipse < openminds.abstract.Schema
%Ellipse - No description available.
%
%   PROPERTIES:
%
%   semiMajorAxis : (1,1) <a href="matlab:help openminds.core.QuantitativeValue" style="font-weight:bold">QuantitativeValue</a>
%                   Enter the length of the semi-minor axis of this ellipse.
%
%   semiMinorAxis : (1,1) <a href="matlab:help openminds.core.QuantitativeValue" style="font-weight:bold">QuantitativeValue</a>
%                   Enter the length of the semi-major axis of this ellipse.

%   This class was auto-generated by the openMINDS pipeline

    properties
        % Enter the length of the semi-minor axis of this ellipse.
        semiMajorAxis (1,:) openminds.core.QuantitativeValue ...
            {mustBeSpecifiedLength(semiMajorAxis, 0, 1)}

        % Enter the length of the semi-major axis of this ellipse.
        semiMinorAxis (1,:) openminds.core.QuantitativeValue ...
            {mustBeSpecifiedLength(semiMinorAxis, 0, 1)}
    end

    properties (Access = protected)
        Required = ["semiMajorAxis", "semiMinorAxis"]
    end

    properties (Constant, Hidden)
        X_TYPE = "https://openminds.ebrains.eu/sands/Ellipse"
    end

    properties (Constant, Hidden)
        LINKED_PROPERTIES = struct(...
        )
        EMBEDDED_PROPERTIES = struct(...
            'semiMajorAxis', "openminds.core.QuantitativeValue", ...
            'semiMinorAxis', "openminds.core.QuantitativeValue" ...
        )
    end

    methods
        function obj = Ellipse(varargin)
            obj@openminds.abstract.Schema(varargin{:})
        end
    end

    methods (Access = protected)
        function str = getDisplayLabel(obj)
            str = '<missing name>';
        end
    end

end