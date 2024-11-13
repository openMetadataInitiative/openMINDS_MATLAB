classdef EphysStimulus < openminds.abstract.Schema
%EphysStimulus - No description available.
%
%   PROPERTIES:
%
%   type : (1,1) <a href="matlab:help openminds.controlledterms.ElectricalStimulusType" style="font-weight:bold">ElectricalStimulusType</a>
%          Add the type that describe this electrical stimulus.

%   This class was auto-generated by the openMINDS pipeline

    properties
        % Add the type that describe this electrical stimulus.
        type (1,:) openminds.controlledterms.ElectricalStimulusType ...
            {mustBeSpecifiedLength(type, 0, 1)}
    end

    properties (Access = protected)
        Required = []
    end

    properties (Constant, Hidden)
        X_TYPE = "https://openminds.ebrains.eu/stimulation/EphysStimulus"
    end

    properties (Constant, Hidden)
        LINKED_PROPERTIES = struct(...
            'type', "openminds.controlledterms.ElectricalStimulusType" ...
        )
        EMBEDDED_PROPERTIES = struct(...
        )
    end

    methods
        function obj = EphysStimulus(varargin)
            obj@openminds.abstract.Schema(varargin{:})
        end
    end

    methods (Access = protected)
        function str = getDisplayLabel(obj)
            str = obj.createLabelForMissingLabelDefinition();
        end
    end
end