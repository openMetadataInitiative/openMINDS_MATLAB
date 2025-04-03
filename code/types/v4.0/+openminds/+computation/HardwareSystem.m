classdef HardwareSystem < openminds.abstract.Schema
%HardwareSystem - Structured information about computing hardware.
%
%   PROPERTIES:
%
%   description       : (1,1) string
%                       Enter a short text describing this hardware system.
%
%   name              : (1,1) string
%                       Enter a descriptive name for this hardware system.
%
%   versionIdentifier : (1,1) string
%                       Enter the version identifier of this hardware system.

%   This class was auto-generated by the openMINDS pipeline

    properties
        % Enter a short text describing this hardware system.
        description (1,1) string

        % Enter a descriptive name for this hardware system.
        name (1,1) string

        % Enter the version identifier of this hardware system.
        versionIdentifier (1,1) string
    end

    properties (Access = protected)
        Required = ["name"]
    end

    properties (Constant, Hidden)
        X_TYPE = "https://openminds.om-i.org/types/HardwareSystem"
    end

    properties (Constant, Hidden)
        LINKED_PROPERTIES = struct(...
        )
        EMBEDDED_PROPERTIES = struct(...
        )
    end

    methods
        function obj = HardwareSystem(varargin)
            obj@openminds.abstract.Schema(varargin{:})
        end
    end

    methods (Access = protected)
        function str = getDisplayLabel(obj)
            str = obj.name;
        end
    end
end
