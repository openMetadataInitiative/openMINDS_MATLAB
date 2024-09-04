classdef Electrode < openminds.abstract.Schema
%Electrode - Structured information on an electrode.
%
%   PROPERTIES:
%
%   electrodeContact   : (1,:) <a href="matlab:help openminds.sands.ElectrodeContact" style="font-weight:bold">ElectrodeContact</a>
%                        Add one or several electrical contacts of this electrode.
%
%   internalIdentifier : (1,1) string
%                        Enter the identifier used for this electrode within the file it is stored in.
%
%   lookupLabel        : (1,1) string
%                        Enter a lookup label for this electrode that may help you to more easily find it again.

%   This class was auto-generated by the openMINDS pipeline

    properties
        % Add one or several electrical contacts of this electrode.
        electrodeContact (1,:) openminds.sands.ElectrodeContact ...
            {mustBeListOfUniqueItems(electrodeContact)}

        % Enter the identifier used for this electrode within the file it is stored in.
        internalIdentifier (1,1) string

        % Enter a lookup label for this electrode that may help you to more easily find it again.
        lookupLabel (1,1) string
    end

    properties (Access = protected)
        Required = ["electrodeContact", "internalIdentifier"]
    end

    properties (Constant, Hidden)
        X_TYPE = "https://openminds.ebrains.eu/sands/Electrode"
    end

    properties (Constant, Hidden)
        LINKED_PROPERTIES = struct(...
            'electrodeContact', "openminds.sands.ElectrodeContact" ...
        )
        EMBEDDED_PROPERTIES = struct(...
        )
    end

    methods
        function obj = Electrode(varargin)
            obj@openminds.abstract.Schema(varargin{:})
        end
    end

    methods (Access = protected)
        function str = getDisplayLabel(obj)
            str = obj.lookupLabel;
        end
    end

end