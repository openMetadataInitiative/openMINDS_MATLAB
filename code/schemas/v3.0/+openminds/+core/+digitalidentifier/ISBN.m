classdef ISBN < openminds.abstract.Schema
%ISBN - An International Standard Book Number of the International ISBN Agency.
%
%   PROPERTIES:
%
%   identifier : (1,1) string
%                Enter the numeric commercial book identifier 'International Standard Book Number' (ISBN) following the defined pattern (e.g., 123-4-567-89012-3 (13-digit ISBN) or 4-567-89012-3 (10-digit ISBN)).

%   This class was auto-generated by the openMINDS pipeline

    properties
        % Enter the numeric commercial book identifier 'International Standard Book Number' (ISBN) following the defined pattern (e.g., 123-4-567-89012-3 (13-digit ISBN) or 4-567-89012-3 (10-digit ISBN)).
        identifier (1,1) string ...
            {mustMatchPattern(identifier, '^([0-9]{3}-|)[0-9]{1}-[0-9]{3}-[0-9]{5}-[0-9]{1}$')}
    end

    properties (Access = protected)
        Required = ["identifier"]
    end

    properties (Constant, Hidden)
        X_TYPE = "https://openminds.ebrains.eu/core/ISBN"
    end

    properties (Constant, Hidden)
        LINKED_PROPERTIES = struct(...
        )
        EMBEDDED_PROPERTIES = struct(...
        )
    end

    methods
        function obj = ISBN(varargin)
            obj@openminds.abstract.Schema(varargin{:})
        end
    end

    methods (Access = protected)
        function str = getDisplayLabel(obj)
            str = sprintf('%s', obj.identifier);
        end
    end
end