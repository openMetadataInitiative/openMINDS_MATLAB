classdef ParameterSetting < openminds.abstract.Schema
%ParameterSetting - Structured information on a used parameter setting.
%
%   PROPERTIES:
%
%   description : (1,1) string
%                 Enter a description of this parameter setting.
%
%   name        : (1,1) string
%                 Enter the name of this parameter setting.
%
%   relevantFor : (1,1) <a href="matlab:help openminds.controlledterms.BehavioralTask" style="font-weight:bold">BehavioralTask</a>, <a href="matlab:help openminds.controlledterms.Technique" style="font-weight:bold">Technique</a>
%                 Add the technique or behavioral task where this parameter setting is used in.
%
%   unit        : (1,1) <a href="matlab:help openminds.controlledterms.UnitOfMeasurement" style="font-weight:bold">UnitOfMeasurement</a>
%                 Add the unit of measurement used for the value of this parameter setting.
%
%   value       : (1,1) number, string
%                 Enter the value of this parameter setting.

%   This class was auto-generated by the openMINDS pipeline

    properties
        % Enter a description of this parameter setting.
        description (1,1) string

        % Enter the name of this parameter setting.
        name (1,1) string

        % Add the technique or behavioral task where this parameter setting is used in.
        relevantFor (1,:) openminds.internal.mixedtype.parametersetting.RelevantFor ...
            {mustBeSpecifiedLength(relevantFor, 0, 1)}

        % Add the unit of measurement used for the value of this parameter setting.
        unit (1,:) openminds.controlledterms.UnitOfMeasurement ...
            {mustBeSpecifiedLength(unit, 0, 1)}

        % Enter the value of this parameter setting.
        value (1,1)  ...
            {mustBeA(value, ["numeric", "string"])}
    end

    properties (Access = protected)
        Required = ["description", "name", "relevantFor", "value"]
    end

    properties (Constant, Hidden)
        X_TYPE = "https://openminds.ebrains.eu/core/ParameterSetting"
    end

    properties (Constant, Hidden)
        LINKED_PROPERTIES = struct(...
            'relevantFor', ["openminds.controlledterms.BehavioralTask", "openminds.controlledterms.Technique"], ...
            'unit', "openminds.controlledterms.UnitOfMeasurement" ...
        )
        EMBEDDED_PROPERTIES = struct(...
        )
    end

    methods
        function obj = ParameterSetting(varargin)
            obj@openminds.abstract.Schema(varargin{:})
        end
    end

    methods (Access = protected)
        function str = getDisplayLabel(obj)
            str = obj.name;
        end
    end
end