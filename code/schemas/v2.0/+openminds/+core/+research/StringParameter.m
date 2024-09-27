classdef StringParameter < openminds.abstract.Schema
%StringParameter - No description available.
%
%   PROPERTIES:
%
%   name  : (1,1) string
%           Enter a descriptive name for this parameter.
%
%   value : (1,1) string
%           Enter a text value for this parameter.

%   This class was auto-generated by the openMINDS pipeline

    properties
        % Enter a descriptive name for this parameter.
        name (1,1) string

        % Enter a text value for this parameter.
        value (1,1) string
    end

    properties (Access = protected)
        Required = ["name", "value"]
    end

    properties (Constant, Hidden)
        X_TYPE = "https://openminds.ebrains.eu/core/StringParameter"
    end

    properties (Constant, Hidden)
        LINKED_PROPERTIES = struct(...
        )
        EMBEDDED_PROPERTIES = struct(...
        )
    end

    methods
        function obj = StringParameter(varargin)
            obj@openminds.abstract.Schema(varargin{:})
        end
    end

    methods (Access = protected)
        function str = getDisplayLabel(obj)

        end
    end

end