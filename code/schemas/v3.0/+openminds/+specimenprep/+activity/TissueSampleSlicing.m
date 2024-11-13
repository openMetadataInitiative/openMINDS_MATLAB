classdef TissueSampleSlicing < openminds.abstract.Schema
%TissueSampleSlicing - No description available.
%
%   PROPERTIES:
%
%   device             : (1,1) <a href="matlab:help openminds.specimenprep.device.SlicingDeviceUsage" style="font-weight:bold">SlicingDeviceUsage</a>
%                        Add the device used to slice the tissue sample.
%
%   input              : (1,1) <a href="matlab:help openminds.core.research.SubjectState" style="font-weight:bold">SubjectState</a>, <a href="matlab:help openminds.core.research.TissueSampleCollectionState" style="font-weight:bold">TissueSampleCollectionState</a>, <a href="matlab:help openminds.core.research.TissueSampleState" style="font-weight:bold">TissueSampleState</a>
%                        Add the state of the specimen that was sliced during this activity.
%
%   output             : (1,:) <a href="matlab:help openminds.core.research.TissueSampleCollectionState" style="font-weight:bold">TissueSampleCollectionState</a>, <a href="matlab:help openminds.core.research.TissueSampleState" style="font-weight:bold">TissueSampleState</a>
%                        Add the state of the tissue sample slice or collection of slices that resulted from this activity.
%
%   temperature        : (1,1) <a href="matlab:help openminds.core.miscellaneous.QuantitativeValue" style="font-weight:bold">QuantitativeValue</a>, <a href="matlab:help openminds.core.miscellaneous.QuantitativeValueRange" style="font-weight:bold">QuantitativeValueRange</a>
%                        Enter the temperature at which the tissue sample was sliced during the activity.
%
%   tissueBathSolution : (1,1) <a href="matlab:help openminds.chemicals.ChemicalMixture" style="font-weight:bold">ChemicalMixture</a>
%                        Add the chemical mixture used as bath solution during this activity.

%   This class was auto-generated by the openMINDS pipeline

    properties
        % Add the device used to slice the tissue sample.
        device (1,:) openminds.specimenprep.device.SlicingDeviceUsage ...
            {mustBeSpecifiedLength(device, 0, 1)}

        % Add the state of the specimen that was sliced during this activity.
        input (1,:) openminds.internal.mixedtype.tissuesampleslicing.Input ...
            {mustBeSpecifiedLength(input, 0, 1)}

        % Add the state of the tissue sample slice or collection of slices that resulted from this activity.
        output (1,:) openminds.internal.mixedtype.tissuesampleslicing.Output ...
            {mustBeListOfUniqueItems(output)}

        % Enter the temperature at which the tissue sample was sliced during the activity.
        temperature (1,:) openminds.internal.mixedtype.tissuesampleslicing.Temperature ...
            {mustBeSpecifiedLength(temperature, 0, 1)}

        % Add the chemical mixture used as bath solution during this activity.
        tissueBathSolution (1,:) openminds.chemicals.ChemicalMixture ...
            {mustBeSpecifiedLength(tissueBathSolution, 0, 1)}
    end

    properties (Access = protected)
        Required = ["device"]
    end

    properties (Constant, Hidden)
        X_TYPE = "https://openminds.ebrains.eu/specimenPrep/TissueSampleSlicing"
    end

    properties (Constant, Hidden)
        LINKED_PROPERTIES = struct(...
            'device', "openminds.specimenprep.device.SlicingDeviceUsage", ...
            'input', ["openminds.core.research.SubjectState", "openminds.core.research.TissueSampleCollectionState", "openminds.core.research.TissueSampleState"], ...
            'output', ["openminds.core.research.TissueSampleCollectionState", "openminds.core.research.TissueSampleState"], ...
            'tissueBathSolution', "openminds.chemicals.ChemicalMixture" ...
        )
        EMBEDDED_PROPERTIES = struct(...
            'temperature', ["openminds.core.miscellaneous.QuantitativeValue", "openminds.core.miscellaneous.QuantitativeValueRange"] ...
        )
    end

    methods
        function obj = TissueSampleSlicing(varargin)
            obj@openminds.abstract.Schema(varargin{:})
        end
    end

    methods (Access = protected)
        function str = getDisplayLabel(obj)
            str = obj.createLabelForMissingLabelDefinition();
        end
    end
end