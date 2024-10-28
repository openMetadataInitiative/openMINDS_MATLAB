classdef ElectrodeContact < openminds.abstract.Schema
%ElectrodeContact - Structured information on an electrode contact.
%
%   PROPERTIES:
%
%   coordinatePoint    : (1,1) <a href="matlab:help openminds.sands.CoordinatePoint" style="font-weight:bold">CoordinatePoint</a>
%                        Add the central coordinate of this electrode contact.
%
%   definedIn          : (1,:) <a href="matlab:help openminds.core.File" style="font-weight:bold">File</a>
%                        Add one or several files in which the coordinate point and internal identifier of this electrode contact is defined in.
%
%   internalIdentifier : (1,1) string
%                        Enter the identifier used for this electrode contact within the file it is stored in.
%
%   lookupLabel        : (1,1) string
%                        Enter a lookup label for this electrode contact that may help you to more easily find it again.
%
%   relatedRecording   : (1,:) <a href="matlab:help openminds.core.File" style="font-weight:bold">File</a>, <a href="matlab:help openminds.core.FileBundle" style="font-weight:bold">FileBundle</a>
%                        Add one or several files in which the recordings from this electrode contact were stored.
%
%   relatedStimulation : (1,:) <a href="matlab:help openminds.core.File" style="font-weight:bold">File</a>, <a href="matlab:help openminds.core.FileBundle" style="font-weight:bold">FileBundle</a>
%                        Add one or several files in which the stimulations applied via this electrode contact were stored.
%
%   visualizedIn       : (1,:) <a href="matlab:help openminds.core.File" style="font-weight:bold">File</a>
%                        Add one or several image files in which the electrode contact is visualized in.

%   This class was auto-generated by the openMINDS pipeline

    properties
        % Add the central coordinate of this electrode contact.
        coordinatePoint (1,:) openminds.sands.CoordinatePoint ...
            {mustBeSpecifiedLength(coordinatePoint, 0, 1)}

        % Add one or several files in which the coordinate point and internal identifier of this electrode contact is defined in.
        definedIn (1,:) openminds.core.File ...
            {mustBeListOfUniqueItems(definedIn)}

        % Enter the identifier used for this electrode contact within the file it is stored in.
        internalIdentifier (1,1) string

        % Enter a lookup label for this electrode contact that may help you to more easily find it again.
        lookupLabel (1,1) string

        % Add one or several files in which the recordings from this electrode contact were stored.
        relatedRecording (1,:) openminds.internal.mixedtype.electrodecontact.RelatedRecording ...
            {mustBeListOfUniqueItems(relatedRecording)}

        % Add one or several files in which the stimulations applied via this electrode contact were stored.
        relatedStimulation (1,:) openminds.internal.mixedtype.electrodecontact.RelatedStimulation ...
            {mustBeListOfUniqueItems(relatedStimulation)}

        % Add one or several image files in which the electrode contact is visualized in.
        visualizedIn (1,:) openminds.core.File ...
            {mustBeListOfUniqueItems(visualizedIn)}
    end

    properties (Access = protected)
        Required = ["coordinatePoint", "internalIdentifier"]
    end

    properties (Constant, Hidden)
        X_TYPE = "https://openminds.ebrains.eu/sands/ElectrodeContact"
    end

    properties (Constant, Hidden)
        LINKED_PROPERTIES = struct(...
            'definedIn', "openminds.core.File", ...
            'relatedRecording', ["openminds.core.File", "openminds.core.FileBundle"], ...
            'relatedStimulation', ["openminds.core.File", "openminds.core.FileBundle"], ...
            'visualizedIn', "openminds.core.File" ...
        )
        EMBEDDED_PROPERTIES = struct(...
            'coordinatePoint', "openminds.sands.CoordinatePoint" ...
        )
    end

    methods
        function obj = ElectrodeContact(varargin)
            obj@openminds.abstract.Schema(varargin{:})
        end
    end

    methods (Access = protected)
        function str = getDisplayLabel(obj)
            str = obj.lookupLabel;
        end
    end

end