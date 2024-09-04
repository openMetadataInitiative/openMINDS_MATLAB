classdef TissueSampleSlicing < openminds.abstract.Schema
%TissueSampleSlicing - No description available.
%
%   PROPERTIES:
%
%   device             : (1,1) <a href="matlab:help openminds.specimenprep.SlicingDeviceUsage" style="font-weight:bold">SlicingDeviceUsage</a>
%                        Add the device used to slice the tissue sample.
%
%   input              : (1,1) <a href="matlab:help openminds.core.SubjectState" style="font-weight:bold">SubjectState</a>, <a href="matlab:help openminds.core.TissueSampleCollectionState" style="font-weight:bold">TissueSampleCollectionState</a>, <a href="matlab:help openminds.core.TissueSampleState" style="font-weight:bold">TissueSampleState</a>
%                        Add the state of the specimen that was sliced during this activity.
%
%   output             : (1,:) <a href="matlab:help openminds.core.TissueSampleCollectionState" style="font-weight:bold">TissueSampleCollectionState</a>, <a href="matlab:help openminds.core.TissueSampleState" style="font-weight:bold">TissueSampleState</a>
%                        Add the state of the tissue sample slice or collection of slices that resulted from this activity.
%
%   temperature        : (1,1) <a href="matlab:help openminds.core.QuantitativeValue" style="font-weight:bold">QuantitativeValue</a>, <a href="matlab:help openminds.core.QuantitativeValueRange" style="font-weight:bold">QuantitativeValueRange</a>
%                        Enter the temperature at which the tissue sample was sliced during the activity.
%
%   tissueBathSolution : (1,1) <a href="matlab:help openminds.chemicals.ChemicalMixture" style="font-weight:bold">ChemicalMixture</a>
%                        Add the chemical mixture used as bath solution during this activity.

%   This class was auto-generated by the openMINDS pipeline

    properties
        % Add the device used to slice the tissue sample.
        device (1,:) openminds.specimenprep.SlicingDeviceUsage ...
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
            'device', "openminds.specimenprep.SlicingDeviceUsage", ...
            'input', ["openminds.core.SubjectState", "openminds.core.TissueSampleCollectionState", "openminds.core.TissueSampleState"], ...
            'output', ["openminds.core.TissueSampleCollectionState", "openminds.core.TissueSampleState"], ...
            'tissueBathSolution', "openminds.chemicals.ChemicalMixture" ...
        )
        EMBEDDED_PROPERTIES = struct(...
            'temperature', ["openminds.core.QuantitativeValue", "openminds.core.QuantitativeValueRange"] ...
        )
    end

    methods
        function obj = TissueSampleSlicing(varargin)
            obj@openminds.abstract.Schema(varargin{:})
        end
    end

    methods (Access = protected)
        function str = getDisplayLabel(obj)
            str = '<missing name>';
        end
    end

end