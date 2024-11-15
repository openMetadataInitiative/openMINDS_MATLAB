classdef ProtocolExecution < openminds.abstract.Schema
%ProtocolExecution - Structured information on a protocol execution.
%
%   PROPERTIES:
%
%   description            : (1,1) string
%                            Enter a description of this protocol execution.
%
%   input                  : (1,:) <a href="matlab:help openminds.core.data.FileBundle" style="font-weight:bold">FileBundle</a>, <a href="matlab:help openminds.core.data.FileInstance" style="font-weight:bold">FileInstance</a>, <a href="matlab:help openminds.core.research.SubjectGroupState" style="font-weight:bold">SubjectGroupState</a>, <a href="matlab:help openminds.core.research.SubjectState" style="font-weight:bold">SubjectState</a>, <a href="matlab:help openminds.core.research.TissueSampleCollectionState" style="font-weight:bold">TissueSampleCollectionState</a>, <a href="matlab:help openminds.core.research.TissueSampleState" style="font-weight:bold">TissueSampleState</a>
%                            Add all inputs (subject state, tissue sample state, file instance or file bundle) used by this protocol execution.
%
%   output                 : (1,:) <a href="matlab:help openminds.core.data.FileBundle" style="font-weight:bold">FileBundle</a>, <a href="matlab:help openminds.core.data.FileInstance" style="font-weight:bold">FileInstance</a>, <a href="matlab:help openminds.core.research.SubjectGroupState" style="font-weight:bold">SubjectGroupState</a>, <a href="matlab:help openminds.core.research.SubjectState" style="font-weight:bold">SubjectState</a>, <a href="matlab:help openminds.core.research.TissueSampleCollectionState" style="font-weight:bold">TissueSampleCollectionState</a>, <a href="matlab:help openminds.core.research.TissueSampleState" style="font-weight:bold">TissueSampleState</a>
%                            Add all outputs (subject state, tissue sample state, file instance or file bundle) generated by this protocol execution.
%
%   parameterSetting       : (1,:) <a href="matlab:help openminds.core.research.ParameterSetting" style="font-weight:bold">ParameterSetting</a>
%                            Add all important parameter settings defining this protocol execution.
%
%   preparationType        : (1,1) <a href="matlab:help openminds.controlledterms.PreparationType" style="font-weight:bold">PreparationType</a>
%                            Add the initial preparation type for this protocol execution.
%
%   protocol               : (1,1) <a href="matlab:help openminds.core.research.Protocol" style="font-weight:bold">Protocol</a>
%                            Add the protocol of this protocol execution.
%
%   semanticallyAnchoredTo : (1,:) <a href="matlab:help openminds.sands.AnatomicalEntity" style="font-weight:bold">AnatomicalEntity</a>
%                            Add all anatomical entities to which the outputs of this protocol execution can be semantically anchored to.
%
%   studyTarget            : (1,:) <a href="matlab:help openminds.controlledterms.BiologicalSex" style="font-weight:bold">BiologicalSex</a>, <a href="matlab:help openminds.controlledterms.Disease" style="font-weight:bold">Disease</a>, <a href="matlab:help openminds.controlledterms.Genotype" style="font-weight:bold">Genotype</a>, <a href="matlab:help openminds.controlledterms.Phenotype" style="font-weight:bold">Phenotype</a>, <a href="matlab:help openminds.controlledterms.Species" style="font-weight:bold">Species</a>, <a href="matlab:help openminds.controlledterms.TermSuggestion" style="font-weight:bold">TermSuggestion</a>, <a href="matlab:help openminds.sands.AnatomicalEntity" style="font-weight:bold">AnatomicalEntity</a>
%                            Add all study targets of this model version.

%   This class was auto-generated by the openMINDS pipeline

    properties
        % Enter a description of this protocol execution.
        description (1,1) string

        % Add all inputs (subject state, tissue sample state, file instance or file bundle) used by this protocol execution.
        input (1,:) openminds.internal.mixedtype.protocolexecution.Input ...
            {mustBeListOfUniqueItems(input)}

        % Add all outputs (subject state, tissue sample state, file instance or file bundle) generated by this protocol execution.
        output (1,:) openminds.internal.mixedtype.protocolexecution.Output ...
            {mustBeListOfUniqueItems(output)}

        % Add all important parameter settings defining this protocol execution.
        parameterSetting (1,:) openminds.core.research.ParameterSetting ...
            {mustBeListOfUniqueItems(parameterSetting)}

        % Add the initial preparation type for this protocol execution.
        preparationType (1,:) openminds.controlledterms.PreparationType ...
            {mustBeSpecifiedLength(preparationType, 0, 1)}

        % Add the protocol of this protocol execution.
        protocol (1,:) openminds.core.research.Protocol ...
            {mustBeSpecifiedLength(protocol, 0, 1)}

        % Add all anatomical entities to which the outputs of this protocol execution can be semantically anchored to.
        semanticallyAnchoredTo (1,:) openminds.sands.AnatomicalEntity ...
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
            'input', ["openminds.core.data.FileBundle", "openminds.core.data.FileInstance", "openminds.core.research.SubjectGroupState", "openminds.core.research.SubjectState", "openminds.core.research.TissueSampleCollectionState", "openminds.core.research.TissueSampleState"], ...
            'output', ["openminds.core.data.FileBundle", "openminds.core.data.FileInstance", "openminds.core.research.SubjectGroupState", "openminds.core.research.SubjectState", "openminds.core.research.TissueSampleCollectionState", "openminds.core.research.TissueSampleState"], ...
            'parameterSetting', "openminds.core.research.ParameterSetting", ...
            'preparationType', "openminds.controlledterms.PreparationType", ...
            'protocol', "openminds.core.research.Protocol", ...
            'semanticallyAnchoredTo', "openminds.sands.AnatomicalEntity", ...
            'studyTarget', ["openminds.controlledterms.BiologicalSex", "openminds.controlledterms.Disease", "openminds.controlledterms.Genotype", "openminds.controlledterms.Phenotype", "openminds.controlledterms.Species", "openminds.controlledterms.TermSuggestion", "openminds.sands.AnatomicalEntity"] ...
        )
        EMBEDDED_PROPERTIES = struct(...
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