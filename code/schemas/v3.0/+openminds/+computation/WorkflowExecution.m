classdef WorkflowExecution < openminds.abstract.Schema
%WorkflowExecution - Structured information about an execution of a computational workflow.
%
%   PROPERTIES:
%
%   configuration : (1,1) <a href="matlab:help openminds.core.data.File" style="font-weight:bold">File</a>, <a href="matlab:help openminds.core.research.Configuration" style="font-weight:bold">Configuration</a>
%                   Add the configuration information for this workflow execution.
%
%   recipe        : (1,1) <a href="matlab:help openminds.computation.WorkflowRecipeVersion" style="font-weight:bold">WorkflowRecipeVersion</a>
%                   Add the workflow recipe version used for this workflow execution.
%
%   stage         : (1,:) <a href="matlab:help openminds.computation.DataAnalysis" style="font-weight:bold">DataAnalysis</a>, <a href="matlab:help openminds.computation.DataCopy" style="font-weight:bold">DataCopy</a>, <a href="matlab:help openminds.computation.GenericComputation" style="font-weight:bold">GenericComputation</a>, <a href="matlab:help openminds.computation.ModelValidation" style="font-weight:bold">ModelValidation</a>, <a href="matlab:help openminds.computation.Optimization" style="font-weight:bold">Optimization</a>, <a href="matlab:help openminds.computation.Simulation" style="font-weight:bold">Simulation</a>, <a href="matlab:help openminds.computation.Visualization" style="font-weight:bold">Visualization</a>
%                   Add all stages that were performed in this workflow execution.
%
%   startedBy     : (1,1) <a href="matlab:help openminds.computation.SoftwareAgent" style="font-weight:bold">SoftwareAgent</a>, <a href="matlab:help openminds.core.actors.Person" style="font-weight:bold">Person</a>
%                   Add the agent that started this workflow execution.

%   This class was auto-generated by the openMINDS pipeline

    properties
        % Add the configuration information for this workflow execution.
        configuration (1,:) openminds.internal.mixedtype.workflowexecution.Configuration ...
            {mustBeSpecifiedLength(configuration, 0, 1)}

        % Add the workflow recipe version used for this workflow execution.
        recipe (1,:) openminds.computation.WorkflowRecipeVersion ...
            {mustBeSpecifiedLength(recipe, 0, 1)}

        % Add all stages that were performed in this workflow execution.
        stage (1,:) openminds.internal.mixedtype.workflowexecution.Stage ...
            {mustBeListOfUniqueItems(stage)}

        % Add the agent that started this workflow execution.
        startedBy (1,:) openminds.internal.mixedtype.workflowexecution.StartedBy ...
            {mustBeSpecifiedLength(startedBy, 0, 1)}
    end

    properties (Access = protected)
        Required = []
    end

    properties (Constant, Hidden)
        X_TYPE = "https://openminds.ebrains.eu/computation/WorkflowExecution"
    end

    properties (Constant, Hidden)
        LINKED_PROPERTIES = struct(...
            'configuration', ["openminds.core.data.File", "openminds.core.research.Configuration"], ...
            'recipe', "openminds.computation.WorkflowRecipeVersion", ...
            'stage', ["openminds.computation.DataAnalysis", "openminds.computation.DataCopy", "openminds.computation.GenericComputation", "openminds.computation.ModelValidation", "openminds.computation.Optimization", "openminds.computation.Simulation", "openminds.computation.Visualization"], ...
            'startedBy', ["openminds.computation.SoftwareAgent", "openminds.core.actors.Person"] ...
        )
        EMBEDDED_PROPERTIES = struct(...
        )
    end

    methods
        function obj = WorkflowExecution(varargin)
            obj@openminds.abstract.Schema(varargin{:})
        end
    end

    methods (Access = protected)
        function str = getDisplayLabel(obj)
            str = obj.createLabelForMissingLabelDefinition();
        end
    end
end