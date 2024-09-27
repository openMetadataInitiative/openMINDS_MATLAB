classdef LaunchConfiguration < openminds.abstract.Schema
%LaunchConfiguration - Structured information about the launch of a computational process.
%
%   PROPERTIES:
%
%   argument            : (1,:) string
%                         Enter all command line arguments for this launch configuration.
%
%   description         : (1,1) string
%                         Enter a short text describing this launch configuration.
%
%   environmentVariable : (1,1) <a href="matlab:help openminds.core.PropertyValueList" style="font-weight:bold">PropertyValueList</a>
%                         Add any environment variables defined by this launch configuration.
%
%   executable          : (1,1) string
%                         Enter the path to the command-line executable.
%
%   name                : (1,1) string
%                         Enter a descriptive name for this launch configuration.

%   This class was auto-generated by the openMINDS pipeline

    properties
        % Enter all command line arguments for this launch configuration.
        argument (1,:) string

        % Enter a short text describing this launch configuration.
        description (1,1) string

        % Add any environment variables defined by this launch configuration.
        environmentVariable (1,:) openminds.core.PropertyValueList ...
            {mustBeSpecifiedLength(environmentVariable, 0, 1)}

        % Enter the path to the command-line executable.
        executable (1,1) string

        % Enter a descriptive name for this launch configuration.
        name (1,1) string
    end

    properties (Access = protected)
        Required = ["executable"]
    end

    properties (Constant, Hidden)
        X_TYPE = "https://openminds.ebrains.eu/computation/LaunchConfiguration"
    end

    properties (Constant, Hidden)
        LINKED_PROPERTIES = struct(...
            'environmentVariable', "openminds.core.PropertyValueList" ...
        )
        EMBEDDED_PROPERTIES = struct(...
        )
    end

    methods
        function obj = LaunchConfiguration(varargin)
            obj@openminds.abstract.Schema(varargin{:})
        end
    end

    methods (Access = protected)
        function str = getDisplayLabel(obj)

        end
    end

end