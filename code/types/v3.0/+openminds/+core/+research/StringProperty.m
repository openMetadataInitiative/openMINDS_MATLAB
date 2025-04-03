classdef StringProperty < openminds.abstract.Schema
%StringProperty - No description available.
%
%   PROPERTIES:
%
%   name  : (1,1) string
%           Enter a descriptive name for this property.
%
%   value : (1,1) string
%           Enter the text value that is described by this string property.

%   This class was auto-generated by the openMINDS pipeline

    properties
        % Enter a descriptive name for this property.
        name (1,1) string

        % Enter the text value that is described by this string property.
        value (1,1) string
    end

    properties (Access = protected)
        Required = ["name", "value"]
    end

    properties (Constant, Hidden)
        X_TYPE = "https://openminds.ebrains.eu/core/StringProperty"
    end

    properties (Constant, Hidden)
        LINKED_PROPERTIES = struct(...
        )
        EMBEDDED_PROPERTIES = struct(...
        )
    end

    methods
        function obj = StringProperty(varargin)
            obj@openminds.abstract.Schema(varargin{:})
        end
    end

    methods (Access = protected)
        function str = getDisplayLabel(obj)
            str = sprintf('%s', obj.name);
        end
    end
end
