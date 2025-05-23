classdef GRIDID < openminds.abstract.Schema
%GRIDID - A GRID (Global Research Identifier Database) identifier.
%
%   PROPERTIES:
%
%   identifier : (1,1) string
%                Enter the identifier for research organizations provided by the International Digital Object Identifier Foundation ('Global Research Identifier Database IDentifier'; GRIDID) as an internationalized resource identifier (IRI) following the defined pattern (i.e., 'https://grid.ac/institutes/' + GRIDID).

%   This class was auto-generated by the openMINDS pipeline

    properties
        % Enter the identifier for research organizations provided by the International Digital Object Identifier Foundation ('Global Research Identifier Database IDentifier'; GRIDID) as an internationalized resource identifier (IRI) following the defined pattern (i.e., 'https://grid.ac/institutes/' + GRIDID).
        identifier (1,1) string ...
            {mustMatchPattern(identifier, '^https://grid.ac/institutes/grid.[0-9]{1,}.([a-f0-9]{1,2})$')}
    end

    properties (Access = protected)
        Required = ["identifier"]
    end

    properties (Constant, Hidden)
        X_TYPE = "https://openminds.ebrains.eu/core/GRIDID"
    end

    properties (Constant, Hidden)
        LINKED_PROPERTIES = struct(...
        )
        EMBEDDED_PROPERTIES = struct(...
        )
    end

    methods
        function obj = GRIDID(varargin)
            obj@openminds.abstract.Schema(varargin{:})
        end
    end

    methods (Access = protected)
        function str = getDisplayLabel(obj)
            str = sprintf('%s', obj.identifier);
        end
    end
end
