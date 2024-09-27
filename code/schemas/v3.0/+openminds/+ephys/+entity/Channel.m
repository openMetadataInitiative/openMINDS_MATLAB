classdef Channel < openminds.abstract.Schema
%Channel - No description available.
%
%   PROPERTIES:
%
%   internalIdentifier : (1,1) string
%                        Enter the identifier (or label) of this channel that is used within the corresponding data files to identify this channel.
%
%   unit               : (1,1) <a href="matlab:help openminds.controlledterms.UnitOfMeasurement" style="font-weight:bold">UnitOfMeasurement</a>
%                        Add the unit of measurement for this channel.

%   This class was auto-generated by the openMINDS pipeline

    properties
        % Enter the identifier (or label) of this channel that is used within the corresponding data files to identify this channel.
        internalIdentifier (1,1) string

        % Add the unit of measurement for this channel.
        unit (1,:) openminds.controlledterms.UnitOfMeasurement ...
            {mustBeSpecifiedLength(unit, 0, 1)}
    end

    properties (Access = protected)
        Required = ["internalIdentifier", "unit"]
    end

    properties (Constant, Hidden)
        X_TYPE = "https://openminds.ebrains.eu/ephys/Channel"
    end

    properties (Constant, Hidden)
        LINKED_PROPERTIES = struct(...
            'unit', "openminds.controlledterms.UnitOfMeasurement" ...
        )
        EMBEDDED_PROPERTIES = struct(...
        )
    end

    methods
        function obj = Channel(varargin)
            obj@openminds.abstract.Schema(varargin{:})
        end
    end

    methods (Access = protected)
        function str = getDisplayLabel(obj)
            str = '<missing name>';
        end
    end

end