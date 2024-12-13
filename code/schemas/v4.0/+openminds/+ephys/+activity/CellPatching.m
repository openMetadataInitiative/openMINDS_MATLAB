classdef CellPatching < openminds.abstract.Schema
%CellPatching - No description available.
%
%   PROPERTIES:
%
%   bathTemperature    : (1,1) <a href="matlab:help openminds.core.miscellaneous.QuantitativeValue" style="font-weight:bold">QuantitativeValue</a>, <a href="matlab:help openminds.core.miscellaneous.QuantitativeValueRange" style="font-weight:bold">QuantitativeValueRange</a>
%                        Enter the temperature of the bath solution.
%
%   customPropertySet  : (1,:) <a href="matlab:help openminds.core.research.CustomPropertySet" style="font-weight:bold">CustomPropertySet</a>
%                        Add any user-defined parameters grouped in context-specific sets that are not covered in the standardized properties of this activity.
%
%   description        : (1,1) string
%                        Enter a description of this activity.
%
%   device             : (1,:) <a href="matlab:help openminds.ephys.device.ElectrodeArrayUsage" style="font-weight:bold">ElectrodeArrayUsage</a>, <a href="matlab:help openminds.ephys.device.ElectrodeUsage" style="font-weight:bold">ElectrodeUsage</a>, <a href="matlab:help openminds.ephys.device.PipetteUsage" style="font-weight:bold">PipetteUsage</a>, <a href="matlab:help openminds.specimenprep.device.SlicingDeviceUsage" style="font-weight:bold">SlicingDeviceUsage</a>
%                        Add all patch pipettes placed during this activity.
%
%   endTime            : (1,1) datetime
%                        Enter the date and/or time on when this activity ended, formatted as either '2023-02-07T16:00:00+00:00' (date-time) or '16:00:00+00:00' (time).
%
%   input              : (1,:) <a href="matlab:help openminds.core.research.SubjectState" style="font-weight:bold">SubjectState</a>, <a href="matlab:help openminds.core.research.TissueSampleState" style="font-weight:bold">TissueSampleState</a>
%                        Add the state of the specimen that the device is being placed in or on during this activity.
%
%   isPartOf           : (1,1) <a href="matlab:help openminds.core.products.DatasetVersion" style="font-weight:bold">DatasetVersion</a>
%                        Add the dataset version in which this activity was conducted.
%
%   lookupLabel        : (1,1) string
%                        Enter a lookup label for this activity that may help you to find this instance more easily.
%
%   output             : (1,:) <a href="matlab:help openminds.core.research.SubjectState" style="font-weight:bold">SubjectState</a>, <a href="matlab:help openminds.core.research.TissueSampleState" style="font-weight:bold">TissueSampleState</a>
%                        Add all states of the specimen(s) that the device was placed in or on as a result of this activity.
%
%   performedBy        : (1,:) <a href="matlab:help openminds.computation.SoftwareAgent" style="font-weight:bold">SoftwareAgent</a>, <a href="matlab:help openminds.core.actors.Person" style="font-weight:bold">Person</a>
%                        Add all agents that performed this activity.
%
%   preparationDesign  : (1,1) <a href="matlab:help openminds.controlledterms.PreparationType" style="font-weight:bold">PreparationType</a>
%                        Add the initial preparation type for this activity.
%
%   protocol           : (1,:) <a href="matlab:help openminds.core.research.Protocol" style="font-weight:bold">Protocol</a>
%                        Add all protocols used during this activity.
%
%   startTime          : (1,1) datetime
%                        Enter the date and/or time on when this activity started, formatted as either '2023-02-07T16:00:00+00:00' (date-time) or '16:00:00+00:00' (time).
%
%   studyTarget        : (1,:) <a href="matlab:help openminds.controlledterms.AuditoryStimulusType" style="font-weight:bold">AuditoryStimulusType</a>, <a href="matlab:help openminds.controlledterms.BiologicalOrder" style="font-weight:bold">BiologicalOrder</a>, <a href="matlab:help openminds.controlledterms.BiologicalSex" style="font-weight:bold">BiologicalSex</a>, <a href="matlab:help openminds.controlledterms.BreedingType" style="font-weight:bold">BreedingType</a>, <a href="matlab:help openminds.controlledterms.CellCultureType" style="font-weight:bold">CellCultureType</a>, <a href="matlab:help openminds.controlledterms.CellType" style="font-weight:bold">CellType</a>, <a href="matlab:help openminds.controlledterms.Disease" style="font-weight:bold">Disease</a>, <a href="matlab:help openminds.controlledterms.DiseaseModel" style="font-weight:bold">DiseaseModel</a>, <a href="matlab:help openminds.controlledterms.ElectricalStimulusType" style="font-weight:bold">ElectricalStimulusType</a>, <a href="matlab:help openminds.controlledterms.GeneticStrainType" style="font-weight:bold">GeneticStrainType</a>, <a href="matlab:help openminds.controlledterms.GustatoryStimulusType" style="font-weight:bold">GustatoryStimulusType</a>, <a href="matlab:help openminds.controlledterms.Handedness" style="font-weight:bold">Handedness</a>, <a href="matlab:help openminds.controlledterms.MolecularEntity" style="font-weight:bold">MolecularEntity</a>, <a href="matlab:help openminds.controlledterms.OlfactoryStimulusType" style="font-weight:bold">OlfactoryStimulusType</a>, <a href="matlab:help openminds.controlledterms.OpticalStimulusType" style="font-weight:bold">OpticalStimulusType</a>, <a href="matlab:help openminds.controlledterms.Organ" style="font-weight:bold">Organ</a>, <a href="matlab:help openminds.controlledterms.OrganismSubstance" style="font-weight:bold">OrganismSubstance</a>, <a href="matlab:help openminds.controlledterms.OrganismSystem" style="font-weight:bold">OrganismSystem</a>, <a href="matlab:help openminds.controlledterms.Species" style="font-weight:bold">Species</a>, <a href="matlab:help openminds.controlledterms.SubcellularEntity" style="font-weight:bold">SubcellularEntity</a>, <a href="matlab:help openminds.controlledterms.TactileStimulusType" style="font-weight:bold">TactileStimulusType</a>, <a href="matlab:help openminds.controlledterms.TermSuggestion" style="font-weight:bold">TermSuggestion</a>, <a href="matlab:help openminds.controlledterms.TissueSampleType" style="font-weight:bold">TissueSampleType</a>, <a href="matlab:help openminds.controlledterms.UBERONParcellation" style="font-weight:bold">UBERONParcellation</a>, <a href="matlab:help openminds.controlledterms.VisualStimulusType" style="font-weight:bold">VisualStimulusType</a>, <a href="matlab:help openminds.sands.atlas.ParcellationEntity" style="font-weight:bold">ParcellationEntity</a>, <a href="matlab:help openminds.sands.atlas.ParcellationEntityVersion" style="font-weight:bold">ParcellationEntityVersion</a>, <a href="matlab:help openminds.sands.nonatlas.CustomAnatomicalEntity" style="font-weight:bold">CustomAnatomicalEntity</a>
%                        Add all study targets of this activity.
%
%   targetPosition     : (1,1) <a href="matlab:help openminds.sands.miscellaneous.AnatomicalTargetPosition" style="font-weight:bold">AnatomicalTargetPosition</a>
%                        Enter the anatomical target position for the placement of the device.
%
%   tissueBathSolution : (1,1) <a href="matlab:help openminds.chemicals.ChemicalMixture" style="font-weight:bold">ChemicalMixture</a>
%                        Add the chemical mixture used as bath solution during this activity.
%
%   variation          : (1,1) <a href="matlab:help openminds.controlledterms.PatchClampVariation" style="font-weight:bold">PatchClampVariation</a>
%                        Add the patch-clamp variation used during this activity.

%   This class was auto-generated by the openMINDS pipeline

    properties
        % Enter the temperature of the bath solution.
        bathTemperature (1,:) openminds.internal.mixedtype.cellpatching.BathTemperature ...
            {mustBeSpecifiedLength(bathTemperature, 0, 1)}

        % Add any user-defined parameters grouped in context-specific sets that are not covered in the standardized properties of this activity.
        customPropertySet (1,:) openminds.core.research.CustomPropertySet ...
            {mustBeListOfUniqueItems(customPropertySet)}

        % Enter a description of this activity.
        description (1,1) string

        % Add all patch pipettes placed during this activity.
        device (1,:) openminds.internal.mixedtype.cellpatching.Device ...
            {mustBeListOfUniqueItems(device)}

        % Enter the date and/or time on when this activity ended, formatted as either '2023-02-07T16:00:00+00:00' (date-time) or '16:00:00+00:00' (time).
        endTime (1,:) datetime ...
            {mustBeSpecifiedLength(endTime, 0, 1)}

        % Add the state of the specimen that the device is being placed in or on during this activity.
        input (1,:) openminds.internal.mixedtype.cellpatching.Input ...
            {mustBeListOfUniqueItems(input)}

        % Add the dataset version in which this activity was conducted.
        isPartOf (1,:) openminds.core.products.DatasetVersion ...
            {mustBeSpecifiedLength(isPartOf, 0, 1)}

        % Enter a lookup label for this activity that may help you to find this instance more easily.
        lookupLabel (1,1) string

        % Add all states of the specimen(s) that the device was placed in or on as a result of this activity.
        output (1,:) openminds.internal.mixedtype.cellpatching.Output ...
            {mustBeListOfUniqueItems(output)}

        % Add all agents that performed this activity.
        performedBy (1,:) openminds.internal.mixedtype.cellpatching.PerformedBy ...
            {mustBeListOfUniqueItems(performedBy)}

        % Add the initial preparation type for this activity.
        preparationDesign (1,:) openminds.controlledterms.PreparationType ...
            {mustBeSpecifiedLength(preparationDesign, 0, 1)}

        % Add all protocols used during this activity.
        protocol (1,:) openminds.core.research.Protocol ...
            {mustBeListOfUniqueItems(protocol)}

        % Enter the date and/or time on when this activity started, formatted as either '2023-02-07T16:00:00+00:00' (date-time) or '16:00:00+00:00' (time).
        startTime (1,:) datetime ...
            {mustBeSpecifiedLength(startTime, 0, 1)}

        % Add all study targets of this activity.
        studyTarget (1,:) openminds.internal.mixedtype.cellpatching.StudyTarget ...
            {mustBeListOfUniqueItems(studyTarget)}

        % Enter the anatomical target position for the placement of the device.
        targetPosition (1,:) openminds.sands.miscellaneous.AnatomicalTargetPosition ...
            {mustBeSpecifiedLength(targetPosition, 0, 1)}

        % Add the chemical mixture used as bath solution during this activity.
        tissueBathSolution (1,:) openminds.chemicals.ChemicalMixture ...
            {mustBeSpecifiedLength(tissueBathSolution, 0, 1)}

        % Add the patch-clamp variation used during this activity.
        variation (1,:) openminds.controlledterms.PatchClampVariation ...
            {mustBeSpecifiedLength(variation, 0, 1)}
    end

    properties (Access = protected)
        Required = ["device", "input", "isPartOf", "output", "protocol"]
    end

    properties (Constant, Hidden)
        X_TYPE = "https://openminds.om-i.org/types/CellPatching"
    end

    properties (Constant, Hidden)
        LINKED_PROPERTIES = struct(...
            'device', ["openminds.ephys.device.ElectrodeArrayUsage", "openminds.ephys.device.ElectrodeUsage", "openminds.ephys.device.PipetteUsage", "openminds.specimenprep.device.SlicingDeviceUsage"], ...
            'input', ["openminds.core.research.SubjectState", "openminds.core.research.TissueSampleState"], ...
            'isPartOf', "openminds.core.products.DatasetVersion", ...
            'output', ["openminds.core.research.SubjectState", "openminds.core.research.TissueSampleState"], ...
            'performedBy', ["openminds.computation.SoftwareAgent", "openminds.core.actors.Person"], ...
            'preparationDesign', "openminds.controlledterms.PreparationType", ...
            'protocol', "openminds.core.research.Protocol", ...
            'studyTarget', ["openminds.controlledterms.AuditoryStimulusType", "openminds.controlledterms.BiologicalOrder", "openminds.controlledterms.BiologicalSex", "openminds.controlledterms.BreedingType", "openminds.controlledterms.CellCultureType", "openminds.controlledterms.CellType", "openminds.controlledterms.Disease", "openminds.controlledterms.DiseaseModel", "openminds.controlledterms.ElectricalStimulusType", "openminds.controlledterms.GeneticStrainType", "openminds.controlledterms.GustatoryStimulusType", "openminds.controlledterms.Handedness", "openminds.controlledterms.MolecularEntity", "openminds.controlledterms.OlfactoryStimulusType", "openminds.controlledterms.OpticalStimulusType", "openminds.controlledterms.Organ", "openminds.controlledterms.OrganismSubstance", "openminds.controlledterms.OrganismSystem", "openminds.controlledterms.Species", "openminds.controlledterms.SubcellularEntity", "openminds.controlledterms.TactileStimulusType", "openminds.controlledterms.TermSuggestion", "openminds.controlledterms.TissueSampleType", "openminds.controlledterms.UBERONParcellation", "openminds.controlledterms.VisualStimulusType", "openminds.sands.atlas.ParcellationEntity", "openminds.sands.atlas.ParcellationEntityVersion", "openminds.sands.nonatlas.CustomAnatomicalEntity"], ...
            'tissueBathSolution', "openminds.chemicals.ChemicalMixture", ...
            'variation', "openminds.controlledterms.PatchClampVariation" ...
        )
        EMBEDDED_PROPERTIES = struct(...
            'bathTemperature', ["openminds.core.miscellaneous.QuantitativeValue", "openminds.core.miscellaneous.QuantitativeValueRange"], ...
            'customPropertySet', "openminds.core.research.CustomPropertySet", ...
            'targetPosition', "openminds.sands.miscellaneous.AnatomicalTargetPosition" ...
        )
    end

    methods
        function obj = CellPatching(varargin)
            obj@openminds.abstract.Schema(varargin{:})
        end
    end

    methods (Access = protected)
        function str = getDisplayLabel(obj)
            str = obj.lookupLabel;
        end
    end
end
