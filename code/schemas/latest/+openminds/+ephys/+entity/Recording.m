classdef Recording < openminds.abstract.Schema
%Recording - No description available.
%
%   PROPERTIES:
%
%   additionalRemarks  : (1,1) string
%                        Enter any additional remarks concerning this recording.
%
%   channel            : (1,:) <a href="matlab:help openminds.ephys.entity.Channel" style="font-weight:bold">Channel</a>
%                        Enter all channels used for this recording.
%
%   dataLocation       : (1,1) <a href="matlab:help openminds.core.data.File" style="font-weight:bold">File</a>, <a href="matlab:help openminds.core.data.FileBundle" style="font-weight:bold">FileBundle</a>
%                        Add the location of the file or file bundle in which the recorded data is stored.
%
%   internalIdentifier : (1,1) string
%                        Enter the identifier (or label) of this recording that is used within the corresponding data files to identify this recording.
%
%   name               : (1,1) string
%                        Enter a descriptive name for this recording.
%
%   previousRecording  : (1,1) <a href="matlab:help openminds.ephys.entity.Recording" style="font-weight:bold">Recording</a>
%                        If this recording is part of a sequence of recordings (e.g., multiple repetitions or sweeps), add the recording preceding this recording.
%
%   recordedWith       : (1,1) <a href="matlab:help openminds.ephys.device.ElectrodeArrayUsage" style="font-weight:bold">ElectrodeArrayUsage</a>, <a href="matlab:help openminds.ephys.device.ElectrodeUsage" style="font-weight:bold">ElectrodeUsage</a>, <a href="matlab:help openminds.ephys.device.PipetteUsage" style="font-weight:bold">PipetteUsage</a>, <a href="matlab:help openminds.specimenprep.device.SlicingDeviceUsage" style="font-weight:bold">SlicingDeviceUsage</a>
%                        Add the device used to generate this recording.
%
%   samplingFrequency  : (1,1) <a href="matlab:help openminds.core.miscellaneous.QuantitativeValue" style="font-weight:bold">QuantitativeValue</a>
%                        Enter the sampling frequency of this recording.

%   This class was auto-generated by the openMINDS pipeline

    properties
        % Enter any additional remarks concerning this recording.
        additionalRemarks (1,1) string

        % Enter all channels used for this recording.
        channel (1,:) openminds.ephys.entity.Channel ...
            {mustBeListOfUniqueItems(channel)}

        % Add the location of the file or file bundle in which the recorded data is stored.
        dataLocation (1,:) openminds.internal.mixedtype.recording.DataLocation ...
            {mustBeSpecifiedLength(dataLocation, 0, 1)}

        % Enter the identifier (or label) of this recording that is used within the corresponding data files to identify this recording.
        internalIdentifier (1,1) string

        % Enter a descriptive name for this recording.
        name (1,1) string

        % If this recording is part of a sequence of recordings (e.g., multiple repetitions or sweeps), add the recording preceding this recording.
        previousRecording (1,:) openminds.ephys.entity.Recording ...
            {mustBeSpecifiedLength(previousRecording, 0, 1)}

        % Add the device used to generate this recording.
        recordedWith (1,:) openminds.internal.mixedtype.recording.RecordedWith ...
            {mustBeSpecifiedLength(recordedWith, 0, 1)}

        % Enter the sampling frequency of this recording.
        samplingFrequency (1,:) openminds.core.miscellaneous.QuantitativeValue ...
            {mustBeSpecifiedLength(samplingFrequency, 0, 1)}
    end

    properties (Access = protected)
        Required = ["channel", "dataLocation", "recordedWith", "samplingFrequency"]
    end

    properties (Constant, Hidden)
        X_TYPE = "https://openminds.om-i.org/types/Recording"
    end

    properties (Constant, Hidden)
        LINKED_PROPERTIES = struct(...
            'dataLocation', ["openminds.core.data.File", "openminds.core.data.FileBundle"], ...
            'previousRecording', "openminds.ephys.entity.Recording", ...
            'recordedWith', ["openminds.ephys.device.ElectrodeArrayUsage", "openminds.ephys.device.ElectrodeUsage", "openminds.ephys.device.PipetteUsage", "openminds.specimenprep.device.SlicingDeviceUsage"] ...
        )
        EMBEDDED_PROPERTIES = struct(...
            'channel', "openminds.ephys.entity.Channel", ...
            'samplingFrequency', "openminds.core.miscellaneous.QuantitativeValue" ...
        )
    end

    methods
        function obj = Recording(varargin)
            obj@openminds.abstract.Schema(varargin{:})
        end
    end

    methods (Access = protected)
        function str = getDisplayLabel(obj)
            str = obj.name;
        end
    end
end