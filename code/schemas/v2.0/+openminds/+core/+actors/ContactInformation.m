classdef ContactInformation < openminds.abstract.Schema
%ContactInformation - Structured information about how to contact a given person or consortium.
%
%   PROPERTIES:
%
%   email : (1,1) string
%           Enter the email address of this person.

%   This class was auto-generated by the openMINDS pipeline

    properties
        % Enter the email address of this person.
        email (1,1) string
    end

    properties (Access = protected)
        Required = ["email"]
    end

    properties (Constant, Hidden)
        X_TYPE = "https://openminds.ebrains.eu/core/ContactInformation"
    end

    properties (Constant, Hidden)
        LINKED_PROPERTIES = struct(...
        )
        EMBEDDED_PROPERTIES = struct(...
        )
    end

    methods
        function obj = ContactInformation(varargin)
            obj@openminds.abstract.Schema(varargin{:})
        end
    end

    methods (Access = protected)
        function str = getDisplayLabel(obj)
            str = sprintf('%s', obj.email);
        end
    end
end