classdef ProtocolExecution < openminds.abstract.Schema
%ProtocolExecution - Structured information on a protocol execution.
%
%   PROPERTIES:
%
%   description            : (1,1) string
%                            Enter a description of this protocol execution.
%
%   input                  : (1,:) <a href="matlab:help openminds.core.data.File" style="font-weight:bold">File</a>, <a href="matlab:help openminds.core.data.FileBundle" style="font-weight:bold">FileBundle</a>, <a href="matlab:help openminds.core.research.SubjectGroupState" style="font-weight:bold">SubjectGroupState</a>, <a href="matlab:help openminds.core.research.SubjectState" style="font-weight:bold">SubjectState</a>, <a href="matlab:help openminds.core.research.TissueSampleCollectionState" style="font-weight:bold">TissueSampleCollectionState</a>, <a href="matlab:help openminds.core.research.TissueSampleState" style="font-weight:bold">TissueSampleState</a>
%                            Add all inputs (subject state, tissue sample state, file instance or file bundle) used by this protocol execution.
%
%   lookupLabel            : (1,1) string
%                            Enter a lookup label for this protocol execution that may help you to more easily find it again.
%
%   output                 : (1,:) <a href="matlab:help openminds.core.data.File" style="font-weight:bold">File</a>, <a href="matlab:help openminds.core.data.FileBundle" style="font-weight:bold">FileBundle</a>, <a href="matlab:help openminds.core.research.SubjectGroupState" style="font-weight:bold">SubjectGroupState</a>, <a href="matlab:help openminds.core.research.SubjectState" style="font-weight:bold">SubjectState</a>, <a href="matlab:help openminds.core.research.TissueSampleCollectionState" style="font-weight:bold">TissueSampleCollectionState</a>, <a href="matlab:help openminds.core.research.TissueSampleState" style="font-weight:bold">TissueSampleState</a>
%                            Add all outputs (subject state, tissue sample state, file instance or file bundle) generated by this protocol execution.
%
%   parameterSet           : (1,:) <a href="matlab:help openminds.core.research.ParameterSet" style="font-weight:bold">ParameterSet</a>
%                            Add all important parameters grouped in context-specific sets that were used in this protocol execution.
%
%   preparationType        : (1,1) <a href="matlab:help openminds.controlledterms.PreparationType" style="font-weight:bold">PreparationType</a>
%                            Add the initial preparation type for this protocol execution.
%
%   protocol               : (1,1) <a href="matlab:help openminds.core.research.Protocol" style="font-weight:bold">Protocol</a>
%                            Add the protocol of this protocol execution.
%
%   semanticallyAnchoredTo : (1,:) <a href="matlab:help openminds.sands.nonatlas.CustomAnatomicalEntity" style="font-weight:bold">CustomAnatomicalEntity</a>
%                            Add all anatomical entities to which the outputs of this protocol execution can be semantically anchored to.
%
%   studyTarget            : (1,:) <a href="matlab:help openminds.controlledterms.BiologicalSex" style="font-weight:bold">BiologicalSex</a>, <a href="matlab:help openminds.controlledterms.CellType" style="font-weight:bold">CellType</a>, <a href="matlab:help openminds.controlledterms.Disease" style="font-weight:bold">Disease</a>, <a href="matlab:help openminds.controlledterms.DiseaseModel" style="font-weight:bold">DiseaseModel</a>, <a href="matlab:help openminds.controlledterms.Handedness" style="font-weight:bold">Handedness</a>, <a href="matlab:help openminds.controlledterms.Organ" style="font-weight:bold">Organ</a>, <a href="matlab:help openminds.controlledterms.Phenotype" style="font-weight:bold">Phenotype</a>, <a href="matlab:help openminds.controlledterms.Species" style="font-weight:bold">Species</a>, <a href="matlab:help openminds.controlledterms.Strain" style="font-weight:bold">Strain</a>, <a href="matlab:help openminds.controlledterms.TermSuggestion" style="font-weight:bold">TermSuggestion</a>, <a href="matlab:help openminds.sands.atlas.ParcellationEntity" style="font-weight:bold">ParcellationEntity</a>, <a href="matlab:help openminds.sands.nonatlas.CustomAnatomicalEntity" style="font-weight:bold">CustomAnatomicalEntity</a>
%                            Add all study targets of this model version.

%   This class was auto-generated by the openMINDS pipeline

    properties
        % Enter a description of this protocol execution.
        description (1,1) string

        % Add all inputs (subject state, tissue sample state, file instance or file bundle) used by this protocol execution.
        input (1,:) openminds.internal.mixedtype.protocolexecution.Input ...
            {mustBeListOfUniqueItems(input)}

        % Enter a lookup label for this protocol execution that may help you to more easily find it again.
        lookupLabel (1,1) string

        % Add all outputs (subject state, tissue sample state, file instance or file bundle) generated by this protocol execution.
        output (1,:) openminds.internal.mixedtype.protocolexecution.Output ...
            {mustBeListOfUniqueItems(output)}

        % Add all important parameters grouped in context-specific sets that were used in this protocol execution.
        parameterSet (1,:) openminds.core.research.ParameterSet ...
            {mustBeListOfUniqueItems(parameterSet)}

        % Add the initial preparation type for this protocol execution.
        preparationType (1,:) openminds.controlledterms.PreparationType ...
            {mustBeSpecifiedLength(preparationType, 0, 1)}

        % Add the protocol of this protocol execution.
        protocol (1,:) openminds.core.research.Protocol ...
            {mustBeSpecifiedLength(protocol, 0, 1)}

        % Add all anatomical entities to which the outputs of this protocol execution can be semantically anchored to.
        semanticallyAnchoredTo (1,:) openminds.sands.nonatlas.CustomAnatomicalEntity ...
            {mustBeListOfUniqueItems(semanticallyAnchoredTo)}

        % Add all study targets of this model version.
        studyTarget (1,:) openminds.internal.mixedtype.protocolexecution.StudyTarget ...
            {mustBeListOfUniqueItems(studyTarget)}
    end

    properties (Access = protected)
        Required = ["input", "output", "protocol"]
    end

    properties (Constant, Hidden)
        X_TYPE = "https://openminds.ebrains.eu/core/ProtocolExecution"
    end

    properties (Constant, Hidden)
        LINKED_PROPERTIES = struct(...
            'input', ["openminds.core.data.File", "openminds.core.data.FileBundle", "openminds.core.research.SubjectGroupState", "openminds.core.research.SubjectState", "openminds.core.research.TissueSampleCollectionState", "openminds.core.research.TissueSampleState"], ...
            'output', ["openminds.core.data.File", "openminds.core.data.FileBundle", "openminds.core.research.SubjectGroupState", "openminds.core.research.SubjectState", "openminds.core.research.TissueSampleCollectionState", "openminds.core.research.TissueSampleState"], ...
            'preparationType', "openminds.controlledterms.PreparationType", ...
            'protocol', "openminds.core.research.Protocol", ...
            'semanticallyAnchoredTo', "openminds.sands.nonatlas.CustomAnatomicalEntity", ...
            'studyTarget', ["openminds.controlledterms.BiologicalSex", "openminds.controlledterms.CellType", "openminds.controlledterms.Disease", "openminds.controlledterms.DiseaseModel", "openminds.controlledterms.Handedness", "openminds.controlledterms.Organ", "openminds.controlledterms.Phenotype", "openminds.controlledterms.Species", "openminds.controlledterms.Strain", "openminds.controlledterms.TermSuggestion", "openminds.sands.atlas.ParcellationEntity", "openminds.sands.nonatlas.CustomAnatomicalEntity"] ...
        )
        EMBEDDED_PROPERTIES = struct(...
            'parameterSet', "openminds.core.research.ParameterSet" ...
        )
    end

    methods
        function obj = ProtocolExecution(varargin)
            obj@openminds.abstract.Schema(varargin{:})
        end
    end

    methods (Access = protected)
        function str = getDisplayLabel(obj)
            str = sprintf('%s', obj.lookupLabel);
        end
    end
end
