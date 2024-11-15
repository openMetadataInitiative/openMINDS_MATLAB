classdef License < openminds.abstract.Schema
%License - Structured information on a used license.
%
%   PROPERTIES:
%
%   fullName  : (1,1) string
%               Enter the full name of this license.
%
%   legalCode : (1,1) string
%               Enter the internationalized resource identifier (IRI) to the legal code of this license.
%
%   shortName : (1,1) string
%               Enter a short name (or alias) for this license that could be used as a shortened display title (e.g., for web services with too little space to display the full name).
%
%   webpage   : (1,:) string
%               Enter the internationalized resource identifiers (IRIs) to webpages related to this license (e.g., a homepage).

%   This class was auto-generated by the openMINDS pipeline

    properties
        % Enter the full name of this license.
        fullName (1,1) string

        % Enter the internationalized resource identifier (IRI) to the legal code of this license.
        legalCode (1,1) string

        % Enter a short name (or alias) for this license that could be used as a shortened display title (e.g., for web services with too little space to display the full name).
        shortName (1,1) string

        % Enter the internationalized resource identifiers (IRIs) to webpages related to this license (e.g., a homepage).
        webpage (1,:) string ...
            {mustBeListOfUniqueItems(webpage)}
    end

    properties (Access = protected)
        Required = ["fullName", "legalCode", "shortName"]
    end

    properties (Constant, Hidden)
        X_TYPE = "https://openminds.om-i.org/types/License"
    end

    properties (Constant, Hidden)
        LINKED_PROPERTIES = struct(...
        )
        EMBEDDED_PROPERTIES = struct(...
        )
    end

    methods
        function obj = License(varargin)
            obj@openminds.abstract.Schema(varargin{:})
        end
    end

    methods (Access = protected)
        function str = getDisplayLabel(obj)
            str = sprintf('%s', obj.fullName);
        end
    end
end
