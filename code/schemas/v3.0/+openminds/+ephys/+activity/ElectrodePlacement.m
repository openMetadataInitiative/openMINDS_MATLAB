classdef ElectrodePlacement < openminds.abstract.Schema
%ElectrodePlacement - No description available.
%
%   PROPERTIES:
%
%   customPropertySet : (1,:) <a href="matlab:help openminds.core.CustomPropertySet" style="font-weight:bold">CustomPropertySet</a>
%                       Add any user-defined parameters grouped in context-specific sets that are not covered in the standardized properties of this activity.
%
%   description       : (1,1) string
%                       Enter a description of this activity.
%
%   device            : (1,:) <a href="matlab:help openminds.ephys.ElectrodeArrayUsage" style="font-weight:bold">ElectrodeArrayUsage</a>, <a href="matlab:help openminds.ephys.ElectrodeUsage" style="font-weight:bold">ElectrodeUsage</a>, <a href="matlab:help openminds.ephys.PipetteUsage" style="font-weight:bold">PipetteUsage</a>, <a href="matlab:help openminds.specimenprep.SlicingDeviceUsage" style="font-weight:bold">SlicingDeviceUsage</a>
%                       Add all electrodes placed during this activity.
%
%   endTime           : (1,1) datetime
%                       Enter the date and/or time on when this activity ended, formatted as either '2023-02-07T16:00:00+00:00' (date-time) or '16:00:00+00:00' (time).
%
%   input             : (1,:) <a href="matlab:help openminds.core.SubjectState" style="font-weight:bold">SubjectState</a>, <a href="matlab:help openminds.core.TissueSampleState" style="font-weight:bold">TissueSampleState</a>
%                       Add the state of the specimen that the device is being placed in or on during this activity.
%
%   isPartOf          : (1,1) <a href="matlab:help openminds.core.DatasetVersion" style="font-weight:bold">DatasetVersion</a>
%                       Add the dataset version in which this activity was conducted.
%
%   lookupLabel       : (1,1) string
%                       Enter a lookup label for this activity that may help you to find this instance more easily.
%
%   output            : (1,:) <a href="matlab:help openminds.core.SubjectState" style="font-weight:bold">SubjectState</a>, <a href="matlab:help openminds.core.TissueSampleState" style="font-weight:bold">TissueSampleState</a>
%                       Add all states of the specimen(s) that the device was placed in or on as a result of this activity.
%
%   performedBy       : (1,:) <a href="matlab:help openminds.computation.SoftwareAgent" style="font-weight:bold">SoftwareAgent</a>, <a href="matlab:help openminds.core.Person" style="font-weight:bold">Person</a>
%                       Add all agents that performed this activity.
%
%   preparationDesign : (1,1) <a href="matlab:help openminds.controlledterms.PreparationType" style="font-weight:bold">PreparationType</a>
%                       Add the initial preparation type for this activity.
%
%   protocol          : (1,:) <a href="matlab:help openminds.core.Protocol" style="font-weight:bold">Protocol</a>
%                       Add all protocols used during this activity.
%
%   startTime         : (1,1) datetime
%                       Enter the date and/or time on when this activity started, formatted as either '2023-02-07T16:00:00+00:00' (date-time) or '16:00:00+00:00' (time).
%
%   studyTarget       : (1,:) <a href="matlab:help openminds.controlledterms.AuditoryStimulusType" style="font-weight:bold">AuditoryStimulusType</a>, <a href="matlab:help openminds.controlledterms.BiologicalOrder" style="font-weight:bold">BiologicalOrder</a>, <a href="matlab:help openminds.controlledterms.BiologicalSex" style="font-weight:bold">BiologicalSex</a>, <a href="matlab:help openminds.controlledterms.BreedingType" style="font-weight:bold">BreedingType</a>, <a href="matlab:help openminds.controlledterms.CellCultureType" style="font-weight:bold">CellCultureType</a>, <a href="matlab:help openminds.controlledterms.CellType" style="font-weight:bold">CellType</a>, <a href="matlab:help openminds.controlledterms.Disease" style="font-weight:bold">Disease</a>, <a href="matlab:help openminds.controlledterms.DiseaseModel" style="font-weight:bold">DiseaseModel</a>, <a href="matlab:help openminds.controlledterms.ElectricalStimulusType" style="font-weight:bold">ElectricalStimulusType</a>, <a href="matlab:help openminds.controlledterms.GeneticStrainType" style="font-weight:bold">GeneticStrainType</a>, <a href="matlab:help openminds.controlledterms.GustatoryStimulusType" style="font-weight:bold">GustatoryStimulusType</a>, <a href="matlab:help openminds.controlledterms.Handedness" style="font-weight:bold">Handedness</a>, <a href="matlab:help openminds.controlledterms.MolecularEntity" style="font-weight:bold">MolecularEntity</a>, <a href="matlab:help openminds.controlledterms.OlfactoryStimulusType" style="font-weight:bold">OlfactoryStimulusType</a>, <a href="matlab:help openminds.controlledterms.OpticalStimulusType" style="font-weight:bold">OpticalStimulusType</a>, <a href="matlab:help openminds.controlledterms.Organ" style="font-weight:bold">Organ</a>, <a href="matlab:help openminds.controlledterms.OrganismSubstance" style="font-weight:bold">OrganismSubstance</a>, <a href="matlab:help openminds.controlledterms.OrganismSystem" style="font-weight:bold">OrganismSystem</a>, <a href="matlab:help openminds.controlledterms.Species" style="font-weight:bold">Species</a>, <a href="matlab:help openminds.controlledterms.SubcellularEntity" style="font-weight:bold">SubcellularEntity</a>, <a href="matlab:help openminds.controlledterms.TactileStimulusType" style="font-weight:bold">TactileStimulusType</a>, <a href="matlab:help openminds.controlledterms.TermSuggestion" style="font-weight:bold">TermSuggestion</a>, <a href="matlab:help openminds.controlledterms.UBERONParcellation" style="font-weight:bold">UBERONParcellation</a>, <a href="matlab:help openminds.controlledterms.VisualStimulusType" style="font-weight:bold">VisualStimulusType</a>, <a href="matlab:help openminds.sands.CustomAnatomicalEntity" style="font-weight:bold">CustomAnatomicalEntity</a>, <a href="matlab:help openminds.sands.ParcellationEntity" style="font-weight:bold">ParcellationEntity</a>, <a href="matlab:help openminds.sands.ParcellationEntityVersion" style="font-weight:bold">ParcellationEntityVersion</a>
%                       Add all study targets of this activity.
%
%   targetPosition    : (1,1) <a href="matlab:help openminds.sands.AnatomicalTargetPosition" style="font-weight:bold">AnatomicalTargetPosition</a>
%                       Enter the anatomical target position for the placement of the device.

%   This class was auto-generated by the openMINDS pipeline

    properties
        % Add any user-defined parameters grouped in context-specific sets that are not covered in the standardized properties of this activity.
        customPropertySet (1,:) openminds.core.CustomPropertySet ...
            {mustBeListOfUniqueItems(customPropertySet)}

        % Enter a description of this activity.
        description (1,1) string

        % Add all electrodes placed during this activity.
        device (1,:) openminds.internal.mixedtype.electrodeplacement.Device ...
            {mustBeListOfUniqueItems(device)}

        % Enter the date and/or time on when this activity ended, formatted as either '2023-02-07T16:00:00+00:00' (date-time) or '16:00:00+00:00' (time).
        endTime (1,:) datetime ...
            {mustBeSpecifiedLength(endTime, 0, 1)}

        % Add the state of the specimen that the device is being placed in or on during this activity.
        input (1,:) openminds.internal.mixedtype.electrodeplacement.Input ...
            {mustBeListOfUniqueItems(input)}

        % Add the dataset version in which this activity was conducted.
        isPartOf (1,:) openminds.core.DatasetVersion ...
            {mustBeSpecifiedLength(isPartOf, 0, 1)}

        % Enter a lookup label for this activity that may help you to find this instance more easily.
        lookupLabel (1,1) string

        % Add all states of the specimen(s) that the device was placed in or on as a result of this activity.
        output (1,:) openminds.internal.mixedtype.electrodeplacement.Output ...
            {mustBeListOfUniqueItems(output)}

        % Add all agents that performed this activity.
        performedBy (1,:) openminds.internal.mixedtype.electrodeplacement.PerformedBy ...
            {mustBeListOfUniqueItems(performedBy)}

        % Add the initial preparation type for this activity.
        preparationDesign (1,:) openminds.controlledterms.PreparationType ...
            {mustBeSpecifiedLength(preparationDesign, 0, 1)}

        % Add all protocols used during this activity.
        protocol (1,:) openminds.core.Protocol ...
            {mustBeListOfUniqueItems(protocol)}

        % Enter the date and/or time on when this activity started, formatted as either '2023-02-07T16:00:00+00:00' (date-time) or '16:00:00+00:00' (time).
        startTime (1,:) datetime ...
            {mustBeSpecifiedLength(startTime, 0, 1)}

        % Add all study targets of this activity.
        studyTarget (1,:) openminds.internal.mixedtype.electrodeplacement.StudyTarget ...
            {mustBeListOfUniqueItems(studyTarget)}

        % Enter the anatomical target position for the placement of the device.
        targetPosition (1,:) openminds.sands.AnatomicalTargetPosition ...
            {mustBeSpecifiedLength(targetPosition, 0, 1)}
    end

    properties (Access = protected)
        Required = ["device", "input", "isPartOf", "output", "protocol"]
    end

    properties (Constant, Hidden)
        X_TYPE = "https://openminds.ebrains.eu/ephys/ElectrodePlacement"
    end

    properties (Constant, Hidden)
        LINKED_PROPERTIES = struct(...
            'device', ["openminds.ephys.ElectrodeArrayUsage", "openminds.ephys.ElectrodeUsage", "openminds.ephys.PipetteUsage", "openminds.specimenprep.SlicingDeviceUsage"], ...
            'input', ["openminds.core.SubjectState", "openminds.core.TissueSampleState"], ...
            'isPartOf', "openminds.core.DatasetVersion", ...
            'output', ["openminds.core.SubjectState", "openminds.core.TissueSampleState"], ...
            'performedBy', ["openminds.computation.SoftwareAgent", "openminds.core.Person"], ...
            'preparationDesign', "openminds.controlledterms.PreparationType", ...
            'protocol', "openminds.core.Protocol", ...
            'studyTarget', ["openminds.controlledterms.AuditoryStimulusType", "openminds.controlledterms.BiologicalOrder", "openminds.controlledterms.BiologicalSex", "openminds.controlledterms.BreedingType", "openminds.controlledterms.CellCultureType", "openminds.controlledterms.CellType", "openminds.controlledterms.Disease", "openminds.controlledterms.DiseaseModel", "openminds.controlledterms.ElectricalStimulusType", "openminds.controlledterms.GeneticStrainType", "openminds.controlledterms.GustatoryStimulusType", "openminds.controlledterms.Handedness", "openminds.controlledterms.MolecularEntity", "openminds.controlledterms.OlfactoryStimulusType", "openminds.controlledterms.OpticalStimulusType", "openminds.controlledterms.Organ", "openminds.controlledterms.OrganismSubstance", "openminds.controlledterms.OrganismSystem", "openminds.controlledterms.Species", "openminds.controlledterms.SubcellularEntity", "openminds.controlledterms.TactileStimulusType", "openminds.controlledterms.TermSuggestion", "openminds.controlledterms.UBERONParcellation", "openminds.controlledterms.VisualStimulusType", "openminds.sands.CustomAnatomicalEntity", "openminds.sands.ParcellationEntity", "openminds.sands.ParcellationEntityVersion"] ...
        )
        EMBEDDED_PROPERTIES = struct(...
            'customPropertySet', "openminds.core.CustomPropertySet", ...
            'targetPosition', "openminds.sands.AnatomicalTargetPosition" ...
        )
    end

    methods
        function obj = ElectrodePlacement(varargin)
            obj@openminds.abstract.Schema(varargin{:})
        end
    end

    methods (Access = protected)
        function str = getDisplayLabel(obj)

        end
    end

end