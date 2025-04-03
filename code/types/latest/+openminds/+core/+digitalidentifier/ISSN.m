classdef ISSN < openminds.abstract.Schema
%ISSN - An International Standard Serial Number of the ISSN International Centre.
%
%   PROPERTIES:
%
%   identifier : (1,1) string
%                Enter the serial number for serial publications 'International Standard Serial Number' (ISSN) following the defined pattern (e.g., 1234-5678 or 1234-567X).

%   This class was auto-generated by the openMINDS pipeline

    properties
        % Enter the serial number for serial publications 'International Standard Serial Number' (ISSN) following the defined pattern (e.g., 1234-5678 or 1234-567X).
        identifier (1,1) string ...
            {mustMatchPattern(identifier, '^[0-9]{4}-[0-9]{3}[0-9X]$')}
    end

    properties (Access = protected)
        Required = ["identifier"]
    end

    properties (Constant, Hidden)
        X_TYPE = "https://openminds.om-i.org/types/ISSN"
    end

    properties (Constant, Hidden)
        LINKED_PROPERTIES = struct(...
        )
        EMBEDDED_PROPERTIES = struct(...
        )
    end

    methods
        function obj = ISSN(varargin)
            obj@openminds.abstract.Schema(varargin{:})
        end
    end

    methods (Access = protected)
        function str = getDisplayLabel(obj)
            str = sprintf('%s', obj.identifier);
        end
    end
end
