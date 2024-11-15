classdef HANDLE < openminds.abstract.Schema
%HANDLE - A persistent identifier for an information resource provided by the Handle System of the Corporation for National Research Initiatives.
%
%   PROPERTIES:
%
%   identifier : (1,1) string
%                Enter the identifier for a superset of DOIs provided by the Corporation for National Research Initiatives (HANDLE) as an internationalized resource identifier (IRI) following the defined pattern (i.e., 'http://hdl.handle.net/' + HANDLE).

%   This class was auto-generated by the openMINDS pipeline

    properties
        % Enter the identifier for a superset of DOIs provided by the Corporation for National Research Initiatives (HANDLE) as an internationalized resource identifier (IRI) following the defined pattern (i.e., 'http://hdl.handle.net/' + HANDLE).
        identifier (1,1) string ...
            {mustMatchPattern(identifier, '^http://hdl.handle.net/[.0-9A-Za-z]+/[.0-9A-Za-z]+')}
    end

    properties (Access = protected)
        Required = ["identifier"]
    end

    properties (Constant, Hidden)
        X_TYPE = "https://openminds.om-i.org/types/HANDLE"
    end

    properties (Constant, Hidden)
        LINKED_PROPERTIES = struct(...
        )
        EMBEDDED_PROPERTIES = struct(...
        )
    end

    methods
        function obj = HANDLE(varargin)
            obj@openminds.abstract.Schema(varargin{:})
        end
    end

    methods (Access = protected)
        function str = getDisplayLabel(obj)
            str = sprintf('%s', obj.identifier);
        end
    end
end
