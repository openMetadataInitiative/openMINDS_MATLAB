classdef DOI < openminds.abstract.Schema
%DOI - Structured information about a digital object identifier, as standardized by the International Organization for Standardization.
%
%   PROPERTIES:
%
%   identifier : (1,1) string
%                Enter the unique and persistent object identifier provided by the International Digital Object Identifier Foundation ('Digital Object Identifier'; DOI) as an internationalized resource identifier (IRI) following the defined pattern (i.e., 'https://doi.org/' + DOI).

%   This class was auto-generated by the openMINDS pipeline

    properties
        % Enter the unique and persistent object identifier provided by the International Digital Object Identifier Foundation ('Digital Object Identifier'; DOI) as an internationalized resource identifier (IRI) following the defined pattern (i.e., 'https://doi.org/' + DOI).
        identifier (1,1) string ...
            {mustMatchPattern(identifier, '^https://doi.org/10.[0-9]{4,9}/[-._;()/:A-Za-z0-9]+')}
    end

    properties (Access = protected)
        Required = ["identifier"]
    end

    properties (Constant, Hidden)
        X_TYPE = "https://openminds.om-i.org/types/DOI"
    end

    properties (Constant, Hidden)
        LINKED_PROPERTIES = struct(...
        )
        EMBEDDED_PROPERTIES = struct(...
        )
    end

    methods
        function obj = DOI(varargin)
            obj@openminds.abstract.Schema(varargin{:})
        end
    end

    methods (Access = protected)
        function str = getDisplayLabel(obj)
            str = sprintf('%s', obj.identifier);
        end
    end
end