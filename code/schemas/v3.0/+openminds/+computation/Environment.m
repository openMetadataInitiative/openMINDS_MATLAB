classdef Environment < openminds.abstract.Schema
%Environment - Structured information on the computer system or set of systems in which a computation is deployed and executed.
%
%   PROPERTIES:
%
%   configuration : (1,1) <a href="matlab:help openminds.core.research.Configuration" style="font-weight:bold">Configuration</a>
%                   Add the configuration of this computational environment.
%
%   description   : (1,1) string
%                   Enter a short text describing this computational environment.
%
%   hardware      : (1,1) <a href="matlab:help openminds.computation.HardwareSystem" style="font-weight:bold">HardwareSystem</a>
%                   Add the hardware system on which this computational environment runs.
%
%   name          : (1,1) string
%                   Enter a descriptive name for this computational environment.
%
%   software      : (1,:) <a href="matlab:help openminds.core.products.SoftwareVersion" style="font-weight:bold">SoftwareVersion</a>
%                   Add all software versions available in this computational environment.

%   This class was auto-generated by the openMINDS pipeline

    properties
        % Add the configuration of this computational environment.
        configuration (1,:) openminds.core.research.Configuration ...
            {mustBeSpecifiedLength(configuration, 0, 1)}

        % Enter a short text describing this computational environment.
        description (1,1) string

        % Add the hardware system on which this computational environment runs.
        hardware (1,:) openminds.computation.HardwareSystem ...
            {mustBeSpecifiedLength(hardware, 0, 1)}

        % Enter a descriptive name for this computational environment.
        name (1,1) string

        % Add all software versions available in this computational environment.
        software (1,:) openminds.core.products.SoftwareVersion ...
            {mustBeListOfUniqueItems(software)}
    end

    properties (Access = protected)
        Required = ["hardware", "name"]
    end

    properties (Constant, Hidden)
        X_TYPE = "https://openminds.ebrains.eu/computation/Environment"
    end

    properties (Constant, Hidden)
        LINKED_PROPERTIES = struct(...
            'configuration', "openminds.core.research.Configuration", ...
            'hardware', "openminds.computation.HardwareSystem", ...
            'software', "openminds.core.products.SoftwareVersion" ...
        )
        EMBEDDED_PROPERTIES = struct(...
        )
    end

    methods
        function obj = Environment(varargin)
            obj@openminds.abstract.Schema(varargin{:})
        end
    end

    methods (Access = protected)
        function str = getDisplayLabel(obj)
            str = obj.name;
        end
    end
end
