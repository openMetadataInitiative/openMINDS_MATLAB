classdef SingleColor < openminds.abstract.Schema
%SingleColor - No description available.
%
%   PROPERTIES:
%
%   value : (1,1) string
%           Enter the Hex color code following the define pattern (e.g., #000000 or #C0C0C0).

%   This class was auto-generated by the openMINDS pipeline

    properties
        % Enter the Hex color code following the define pattern (e.g., #000000 or #C0C0C0).
        value (1,1) string ...
            {mustMatchPattern(value, '^#[0-9A-Fa-f]{6}$')}
    end

    properties (Access = protected)
        Required = ["value"]
    end

    properties (Constant, Hidden)
        X_TYPE = "https://openminds.om-i.org/types/SingleColor"
    end

    properties (Constant, Hidden)
        LINKED_PROPERTIES = struct(...
        )
        EMBEDDED_PROPERTIES = struct(...
        )
    end

    methods
        function obj = SingleColor(varargin)
            obj@openminds.abstract.Schema(varargin{:})
        end
    end

    methods (Access = protected)
        function str = getDisplayLabel(obj)
            str = sprintf('%s', obj.value);
        end
    end
end