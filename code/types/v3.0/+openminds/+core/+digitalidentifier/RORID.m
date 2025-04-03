classdef RORID < openminds.abstract.Schema
%RORID - A persistent identifier for a research organization, provided by the Research Organization Registry.
%
%   PROPERTIES:
%
%   identifier : (1,1) string
%                Enter the identifier for research organizations provided by the Corporation for National Research Initiatives ('Research Organization Registry IDentifier'; RORID) as an internationalized resource identifier (IRI) following the defined pattern (i.e., 'https://ror.org/' + RORID).

%   This class was auto-generated by the openMINDS pipeline

    properties
        % Enter the identifier for research organizations provided by the Corporation for National Research Initiatives ('Research Organization Registry IDentifier'; RORID) as an internationalized resource identifier (IRI) following the defined pattern (i.e., 'https://ror.org/' + RORID).
        identifier (1,1) string ...
            {mustMatchPattern(identifier, '^https://ror.org/0([0-9]|[^ILO]|[a-z]){6}[0-9]{2}$')}
    end

    properties (Access = protected)
        Required = ["identifier"]
    end

    properties (Constant, Hidden)
        X_TYPE = "https://openminds.ebrains.eu/core/RORID"
    end

    properties (Constant, Hidden)
        LINKED_PROPERTIES = struct(...
        )
        EMBEDDED_PROPERTIES = struct(...
        )
    end

    methods
        function obj = RORID(varargin)
            obj@openminds.abstract.Schema(varargin{:})
        end
    end

    methods (Access = protected)
        function str = getDisplayLabel(obj)
            str = sprintf('%s', obj.identifier);
        end
    end
end
