classdef ParameterSet < openminds.abstract.Schema
%ParameterSet - Structured information on a used parameter set.
%
%   PROPERTIES:
%
%   context     : (1,1) string
%                 Enter the common context for the parameters grouped in this set.
%
%   parameter   : (1,:) <a href="matlab:help openminds.core.NumericalParameter" style="font-weight:bold">NumericalParameter</a>, <a href="matlab:help openminds.core.StringParameter" style="font-weight:bold">StringParameter</a>
%                 Add all numerical and string parameters that belong to this parameter set.
%
%   relevantFor : (1,1) <a href="matlab:help openminds.controlledterms.BehavioralTask" style="font-weight:bold">BehavioralTask</a>, <a href="matlab:help openminds.controlledterms.Technique" style="font-weight:bold">Technique</a>
%                 Add the technique or behavioral task where this set of parameters is used in.

%   This class was auto-generated by the openMINDS pipeline

    properties
        % Enter the common context for the parameters grouped in this set.
        context (1,1) string

        % Add all numerical and string parameters that belong to this parameter set.
        parameter (1,:) openminds.internal.mixedtype.parameterset.Parameter ...
            {mustBeListOfUniqueItems(parameter)}

        % Add the technique or behavioral task where this set of parameters is used in.
        relevantFor (1,:) openminds.internal.mixedtype.parameterset.RelevantFor ...
            {mustBeSpecifiedLength(relevantFor, 0, 1)}
    end

    properties (Access = protected)
        Required = ["context", "parameter", "relevantFor"]
    end

    properties (Constant, Hidden)
        X_TYPE = "https://openminds.ebrains.eu/core/ParameterSet"
    end

    properties (Constant, Hidden)
        LINKED_PROPERTIES = struct(...
            'relevantFor', ["openminds.controlledterms.BehavioralTask", "openminds.controlledterms.Technique"] ...
        )
        EMBEDDED_PROPERTIES = struct(...
            'parameter', ["openminds.core.NumericalParameter", "openminds.core.StringParameter"] ...
        )
    end

    methods
        function obj = ParameterSet(varargin)
            obj@openminds.abstract.Schema(varargin{:})
        end
    end

    methods (Access = protected)
        function str = getDisplayLabel(obj)

        end
    end

end