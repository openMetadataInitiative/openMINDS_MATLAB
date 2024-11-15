classdef Protocol < openminds.abstract.Schema
%Protocol - Structured information on a research project.
%
%   PROPERTIES:
%
%   behavioralTask : (1,:) <a href="matlab:help openminds.controlledterms.BehavioralTask" style="font-weight:bold">BehavioralTask</a>
%                    Add all behavioral tasks that were executed as part of this protocol.
%
%   description    : (1,1) string
%                    Enter a description of this protocol.
%
%   name           : (1,1) string
%                    Enter a descriptive name for this protocol.
%
%   studyOption    : (1,:) <a href="matlab:help openminds.controlledterms.BiologicalSex" style="font-weight:bold">BiologicalSex</a>, <a href="matlab:help openminds.controlledterms.CellType" style="font-weight:bold">CellType</a>, <a href="matlab:help openminds.controlledterms.Disease" style="font-weight:bold">Disease</a>, <a href="matlab:help openminds.controlledterms.DiseaseModel" style="font-weight:bold">DiseaseModel</a>, <a href="matlab:help openminds.controlledterms.Handedness" style="font-weight:bold">Handedness</a>, <a href="matlab:help openminds.controlledterms.Organ" style="font-weight:bold">Organ</a>, <a href="matlab:help openminds.controlledterms.Phenotype" style="font-weight:bold">Phenotype</a>, <a href="matlab:help openminds.controlledterms.Species" style="font-weight:bold">Species</a>, <a href="matlab:help openminds.controlledterms.Strain" style="font-weight:bold">Strain</a>, <a href="matlab:help openminds.controlledterms.TermSuggestion" style="font-weight:bold">TermSuggestion</a>, <a href="matlab:help openminds.sands.atlas.ParcellationEntity" style="font-weight:bold">ParcellationEntity</a>, <a href="matlab:help openminds.sands.nonatlas.CustomAnatomicalEntity" style="font-weight:bold">CustomAnatomicalEntity</a>
%                    Add all study options this protocol offers.
%
%   technique      : (1,:) <a href="matlab:help openminds.controlledterms.Technique" style="font-weight:bold">Technique</a>
%                    Add all techniques that were used in this protocol.

%   This class was auto-generated by the openMINDS pipeline

    properties
        % Add all behavioral tasks that were executed as part of this protocol.
        behavioralTask (1,:) openminds.controlledterms.BehavioralTask ...
            {mustBeListOfUniqueItems(behavioralTask)}

        % Enter a description of this protocol.
        description (1,1) string

        % Enter a descriptive name for this protocol.
        name (1,1) string

        % Add all study options this protocol offers.
        studyOption (1,:) openminds.internal.mixedtype.protocol.StudyOption ...
            {mustBeListOfUniqueItems(studyOption)}

        % Add all techniques that were used in this protocol.
        technique (1,:) openminds.controlledterms.Technique ...
            {mustBeListOfUniqueItems(technique)}
    end

    properties (Access = protected)
        Required = ["description", "name", "technique"]
    end

    properties (Constant, Hidden)
        X_TYPE = "https://openminds.ebrains.eu/core/Protocol"
    end

    properties (Constant, Hidden)
        LINKED_PROPERTIES = struct(...
            'behavioralTask', "openminds.controlledterms.BehavioralTask", ...
            'studyOption', ["openminds.controlledterms.BiologicalSex", "openminds.controlledterms.CellType", "openminds.controlledterms.Disease", "openminds.controlledterms.DiseaseModel", "openminds.controlledterms.Handedness", "openminds.controlledterms.Organ", "openminds.controlledterms.Phenotype", "openminds.controlledterms.Species", "openminds.controlledterms.Strain", "openminds.controlledterms.TermSuggestion", "openminds.sands.atlas.ParcellationEntity", "openminds.sands.nonatlas.CustomAnatomicalEntity"], ...
            'technique', "openminds.controlledterms.Technique" ...
        )
        EMBEDDED_PROPERTIES = struct(...
        )
    end

    methods
        function obj = Protocol(varargin)
            obj@openminds.abstract.Schema(varargin{:})
        end
    end

    methods (Access = protected)
        function str = getDisplayLabel(obj)
            str = sprintf('%s', obj.name);
        end
    end
end
