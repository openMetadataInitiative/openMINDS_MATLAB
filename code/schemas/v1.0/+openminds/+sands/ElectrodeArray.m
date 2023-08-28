classdef ElectrodeArray < openminds.abstract.Schema
%ElectrodeArray - Structured information on an electrode array.
%
%   PROPERTIES:
%
%   electrodes         : (1,:) <a href="matlab:help openminds.sands.Electrode" style="font-weight:bold">Electrode</a>
%                        Add two or more electrodes which build this array.
%
%   internalIdentifier : (1,1) string
%                        Enter the identifier used for this electrode array within the file it is stored in.

%   This class was auto-generated by the openMINDS pipeline

    properties
        % Add two or more electrodes which build this array.
        electrodes (1,:) openminds.sands.Electrode ...
            {mustBeListOfUniqueItems(electrodes)}

        % Enter the identifier used for this electrode array within the file it is stored in.
        internalIdentifier (1,1) string
    end

    properties (Access = protected)
        Required = ["electrodes", "internalIdentifier"]
    end

    properties (Constant, Hidden)
        X_TYPE = "https://openminds.ebrains.eu/sands/ElectrodeArray"
    end

    properties (Constant, Hidden)
        LINKED_PROPERTIES = struct(...
            'electrodes', "openminds.sands.Electrode" ...
        )
        EMBEDDED_PROPERTIES = struct(...
        )
    end

    methods
        function obj = ElectrodeArray(varargin)
            obj@openminds.abstract.Schema(varargin{:})
        end
    end

    methods (Access = protected)
        function str = getDisplayLabel(obj)

        end
    end

end