classdef BehavioralProtocol < openminds.abstract.Schema
%BehavioralProtocol - Structured information about a protocol used in an experiment studying human or animal behavior.
%
%   PROPERTIES:
%
%   describedIn        : (1,:) <a href="matlab:help openminds.core.data.File" style="font-weight:bold">File</a>, <a href="matlab:help openminds.core.digitalidentifier.DOI" style="font-weight:bold">DOI</a>, <a href="matlab:help openminds.core.miscellaneous.WebResource" style="font-weight:bold">WebResource</a>
%                        Add all sources in which this behavioral protocol is described in detail.
%
%   description        : (1,1) string
%                        Enter a description of this behavioral protocol.
%
%   internalIdentifier : (1,1) string
%                        Enter the identifier (or label) of this behavioral protocol that is used within the corresponding data files to identify this behavioral protocol.
%
%   name               : (1,1) string
%                        Enter a descriptive name for this behavioral protocol.
%
%   stimulation        : (1,:) <a href="matlab:help openminds.controlledterms.StimulationApproach" style="font-weight:bold">StimulationApproach</a>, <a href="matlab:help openminds.controlledterms.StimulationTechnique" style="font-weight:bold">StimulationTechnique</a>
%                        Add all stimulation approaches and/or techniques used within this behavioral protocol.
%
%   stimulusType       : (1,:) <a href="matlab:help openminds.controlledterms.AuditoryStimulusType" style="font-weight:bold">AuditoryStimulusType</a>, <a href="matlab:help openminds.controlledterms.ElectricalStimulusType" style="font-weight:bold">ElectricalStimulusType</a>, <a href="matlab:help openminds.controlledterms.GustatoryStimulusType" style="font-weight:bold">GustatoryStimulusType</a>, <a href="matlab:help openminds.controlledterms.OlfactoryStimulusType" style="font-weight:bold">OlfactoryStimulusType</a>, <a href="matlab:help openminds.controlledterms.OpticalStimulusType" style="font-weight:bold">OpticalStimulusType</a>, <a href="matlab:help openminds.controlledterms.TactileStimulusType" style="font-weight:bold">TactileStimulusType</a>, <a href="matlab:help openminds.controlledterms.VisualStimulusType" style="font-weight:bold">VisualStimulusType</a>
%                        Add all stimulus types used within this behavioral protocol.

%   This class was auto-generated by the openMINDS pipeline

    properties
        % Add all sources in which this behavioral protocol is described in detail.
        describedIn (1,:) openminds.internal.mixedtype.behavioralprotocol.DescribedIn ...
            {mustBeListOfUniqueItems(describedIn)}

        % Enter a description of this behavioral protocol.
        description (1,1) string

        % Enter the identifier (or label) of this behavioral protocol that is used within the corresponding data files to identify this behavioral protocol.
        internalIdentifier (1,1) string

        % Enter a descriptive name for this behavioral protocol.
        name (1,1) string

        % Add all stimulation approaches and/or techniques used within this behavioral protocol.
        stimulation (1,:) openminds.internal.mixedtype.behavioralprotocol.Stimulation ...
            {mustBeListOfUniqueItems(stimulation)}

        % Add all stimulus types used within this behavioral protocol.
        stimulusType (1,:) openminds.internal.mixedtype.behavioralprotocol.StimulusType ...
            {mustBeListOfUniqueItems(stimulusType)}
    end

    properties (Access = protected)
        Required = ["description", "name"]
    end

    properties (Constant, Hidden)
        X_TYPE = "https://openminds.ebrains.eu/core/BehavioralProtocol"
    end

    properties (Constant, Hidden)
        LINKED_PROPERTIES = struct(...
            'describedIn', ["openminds.core.data.File", "openminds.core.digitalidentifier.DOI", "openminds.core.miscellaneous.WebResource"], ...
            'stimulation', ["openminds.controlledterms.StimulationApproach", "openminds.controlledterms.StimulationTechnique"], ...
            'stimulusType', ["openminds.controlledterms.AuditoryStimulusType", "openminds.controlledterms.ElectricalStimulusType", "openminds.controlledterms.GustatoryStimulusType", "openminds.controlledterms.OlfactoryStimulusType", "openminds.controlledterms.OpticalStimulusType", "openminds.controlledterms.TactileStimulusType", "openminds.controlledterms.VisualStimulusType"] ...
        )
        EMBEDDED_PROPERTIES = struct(...
        )
    end

    methods
        function obj = BehavioralProtocol(varargin)
            obj@openminds.abstract.Schema(varargin{:})
        end
    end

    methods (Access = protected)
        function str = getDisplayLabel(obj)
            str = sprintf('%s', obj.name);
        end
    end
end