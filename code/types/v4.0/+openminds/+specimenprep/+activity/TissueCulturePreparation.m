classdef TissueCulturePreparation < openminds.abstract.Schema
%TissueCulturePreparation - No description available.
%
%   PROPERTIES:
%
%   cultureMedium     : (1,1) <a href="matlab:help openminds.chemicals.ChemicalMixture" style="font-weight:bold">ChemicalMixture</a>
%                       Add the culture medium used during this tissue culture preparation.
%
%   cultureType       : (1,1) <a href="matlab:help openminds.controlledterms.CellCultureType" style="font-weight:bold">CellCultureType</a>
%                       Add the cell culture type of the resulting tissue cell culture.
%
%   customPropertySet : (1,:) <a href="matlab:help openminds.core.research.CustomPropertySet" style="font-weight:bold">CustomPropertySet</a>
%                       Add any user-defined parameters grouped in context-specific sets that are not covered in the standardized properties of this activity.
%
%   description       : (1,1) string
%                       Enter a description of this activity.
%
%   endTime           : (1,1) datetime
%                       Enter the date and/or time on when this activity ended, formatted as either '2023-02-07T16:00:00+00:00' (date-time) or '16:00:00+00:00' (time).
%
%   input             : (1,:) <a href="matlab:help openminds.core.research.SubjectGroupState" style="font-weight:bold">SubjectGroupState</a>, <a href="matlab:help openminds.core.research.SubjectState" style="font-weight:bold">SubjectState</a>, <a href="matlab:help openminds.core.research.TissueSampleCollectionState" style="font-weight:bold">TissueSampleCollectionState</a>, <a href="matlab:help openminds.core.research.TissueSampleState" style="font-weight:bold">TissueSampleState</a>
%                       Add the state of the specimen before it was prepared as culture in this activity.
%
%   isPartOf          : (1,1) <a href="matlab:help openminds.core.products.DatasetVersion" style="font-weight:bold">DatasetVersion</a>
%                       Add the dataset version in which this activity was conducted.
%
%   lookupLabel       : (1,1) string
%                       Enter a lookup label for this activity that may help you to find this instance more easily.
%
%   output            : (1,:) <a href="matlab:help openminds.core.research.TissueSampleState" style="font-weight:bold">TissueSampleState</a>
%                       Add the state of the prepared tissue sample culture that resulted from this activity.
%
%   performedBy       : (1,:) <a href="matlab:help openminds.computation.SoftwareAgent" style="font-weight:bold">SoftwareAgent</a>, <a href="matlab:help openminds.core.actors.Person" style="font-weight:bold">Person</a>
%                       Add all agents that performed this activity.
%
%   preparationDesign : (1,1) <a href="matlab:help openminds.controlledterms.PreparationType" style="font-weight:bold">PreparationType</a>
%                       Add the initial preparation type for this activity.
%
%   protocol          : (1,:) <a href="matlab:help openminds.core.research.Protocol" style="font-weight:bold">Protocol</a>
%                       Add all protocols used during this activity.
%
%   startTime         : (1,1) datetime
%                       Enter the date and/or time on when this activity started, formatted as either '2023-02-07T16:00:00+00:00' (date-time) or '16:00:00+00:00' (time).
%
%   studyTarget       : (1,:) <a href="matlab:help openminds.controlledterms.AuditoryStimulusType" style="font-weight:bold">AuditoryStimulusType</a>, <a href="matlab:help openminds.controlledterms.BiologicalOrder" style="font-weight:bold">BiologicalOrder</a>, <a href="matlab:help openminds.controlledterms.BiologicalSex" style="font-weight:bold">BiologicalSex</a>, <a href="matlab:help openminds.controlledterms.BreedingType" style="font-weight:bold">BreedingType</a>, <a href="matlab:help openminds.controlledterms.CellCultureType" style="font-weight:bold">CellCultureType</a>, <a href="matlab:help openminds.controlledterms.CellType" style="font-weight:bold">CellType</a>, <a href="matlab:help openminds.controlledterms.Disease" style="font-weight:bold">Disease</a>, <a href="matlab:help openminds.controlledterms.DiseaseModel" style="font-weight:bold">DiseaseModel</a>, <a href="matlab:help openminds.controlledterms.ElectricalStimulusType" style="font-weight:bold">ElectricalStimulusType</a>, <a href="matlab:help openminds.controlledterms.GeneticStrainType" style="font-weight:bold">GeneticStrainType</a>, <a href="matlab:help openminds.controlledterms.GustatoryStimulusType" style="font-weight:bold">GustatoryStimulusType</a>, <a href="matlab:help openminds.controlledterms.Handedness" style="font-weight:bold">Handedness</a>, <a href="matlab:help openminds.controlledterms.MolecularEntity" style="font-weight:bold">MolecularEntity</a>, <a href="matlab:help openminds.controlledterms.OlfactoryStimulusType" style="font-weight:bold">OlfactoryStimulusType</a>, <a href="matlab:help openminds.controlledterms.OpticalStimulusType" style="font-weight:bold">OpticalStimulusType</a>, <a href="matlab:help openminds.controlledterms.Organ" style="font-weight:bold">Organ</a>, <a href="matlab:help openminds.controlledterms.OrganismSubstance" style="font-weight:bold">OrganismSubstance</a>, <a href="matlab:help openminds.controlledterms.OrganismSystem" style="font-weight:bold">OrganismSystem</a>, <a href="matlab:help openminds.controlledterms.Species" style="font-weight:bold">Species</a>, <a href="matlab:help openminds.controlledterms.SubcellularEntity" style="font-weight:bold">SubcellularEntity</a>, <a href="matlab:help openminds.controlledterms.TactileStimulusType" style="font-weight:bold">TactileStimulusType</a>, <a href="matlab:help openminds.controlledterms.TermSuggestion" style="font-weight:bold">TermSuggestion</a>, <a href="matlab:help openminds.controlledterms.TissueSampleType" style="font-weight:bold">TissueSampleType</a>, <a href="matlab:help openminds.controlledterms.UBERONParcellation" style="font-weight:bold">UBERONParcellation</a>, <a href="matlab:help openminds.controlledterms.VisualStimulusType" style="font-weight:bold">VisualStimulusType</a>, <a href="matlab:help openminds.sands.atlas.ParcellationEntity" style="font-weight:bold">ParcellationEntity</a>, <a href="matlab:help openminds.sands.atlas.ParcellationEntityVersion" style="font-weight:bold">ParcellationEntityVersion</a>, <a href="matlab:help openminds.sands.nonatlas.CustomAnatomicalEntity" style="font-weight:bold">CustomAnatomicalEntity</a>
%                       Add all study targets of this activity.

%   This class was auto-generated by the openMINDS pipeline

    properties
        % Add the culture medium used during this tissue culture preparation.
        cultureMedium (1,:) openminds.chemicals.ChemicalMixture ...
            {mustBeSpecifiedLength(cultureMedium, 0, 1)}

        % Add the cell culture type of the resulting tissue cell culture.
        cultureType (1,:) openminds.controlledterms.CellCultureType ...
            {mustBeSpecifiedLength(cultureType, 0, 1)}

        % Add any user-defined parameters grouped in context-specific sets that are not covered in the standardized properties of this activity.
        customPropertySet (1,:) openminds.core.research.CustomPropertySet ...
            {mustBeListOfUniqueItems(customPropertySet)}

        % Enter a description of this activity.
        description (1,1) string

        % Enter the date and/or time on when this activity ended, formatted as either '2023-02-07T16:00:00+00:00' (date-time) or '16:00:00+00:00' (time).
        endTime (1,:) datetime ...
            {mustBeSpecifiedLength(endTime, 0, 1)}

        % Add the state of the specimen before it was prepared as culture in this activity.
        input (1,:) openminds.internal.mixedtype.tissueculturepreparation.Input ...
            {mustBeListOfUniqueItems(input)}

        % Add the dataset version in which this activity was conducted.
        isPartOf (1,:) openminds.core.products.DatasetVersion ...
            {mustBeSpecifiedLength(isPartOf, 0, 1)}

        % Enter a lookup label for this activity that may help you to find this instance more easily.
        lookupLabel (1,1) string

        % Add the state of the prepared tissue sample culture that resulted from this activity.
        output (1,:) openminds.core.research.TissueSampleState ...
            {mustBeListOfUniqueItems(output)}

        % Add all agents that performed this activity.
        performedBy (1,:) openminds.internal.mixedtype.tissueculturepreparation.PerformedBy ...
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
        studyTarget (1,:) openminds.internal.mixedtype.tissueculturepreparation.StudyTarget ...
            {mustBeListOfUniqueItems(studyTarget)}
    end

    properties (Access = protected)
        Required = ["cultureMedium", "cultureType", "input", "isPartOf", "output", "protocol"]
    end

    properties (Constant, Hidden)
        X_TYPE = "https://openminds.om-i.org/types/TissueCulturePreparation"
    end

    properties (Constant, Hidden)
        LINKED_PROPERTIES = struct(...
            'cultureMedium', "openminds.chemicals.ChemicalMixture", ...
            'cultureType', "openminds.controlledterms.CellCultureType", ...
            'input', ["openminds.core.research.SubjectGroupState", "openminds.core.research.SubjectState", "openminds.core.research.TissueSampleCollectionState", "openminds.core.research.TissueSampleState"], ...
            'isPartOf', "openminds.core.products.DatasetVersion", ...
            'output', "openminds.core.research.TissueSampleState", ...
            'performedBy', ["openminds.computation.SoftwareAgent", "openminds.core.actors.Person"], ...
            'preparationDesign', "openminds.controlledterms.PreparationType", ...
            'protocol', "openminds.core.research.Protocol", ...
            'studyTarget', ["openminds.controlledterms.AuditoryStimulusType", "openminds.controlledterms.BiologicalOrder", "openminds.controlledterms.BiologicalSex", "openminds.controlledterms.BreedingType", "openminds.controlledterms.CellCultureType", "openminds.controlledterms.CellType", "openminds.controlledterms.Disease", "openminds.controlledterms.DiseaseModel", "openminds.controlledterms.ElectricalStimulusType", "openminds.controlledterms.GeneticStrainType", "openminds.controlledterms.GustatoryStimulusType", "openminds.controlledterms.Handedness", "openminds.controlledterms.MolecularEntity", "openminds.controlledterms.OlfactoryStimulusType", "openminds.controlledterms.OpticalStimulusType", "openminds.controlledterms.Organ", "openminds.controlledterms.OrganismSubstance", "openminds.controlledterms.OrganismSystem", "openminds.controlledterms.Species", "openminds.controlledterms.SubcellularEntity", "openminds.controlledterms.TactileStimulusType", "openminds.controlledterms.TermSuggestion", "openminds.controlledterms.TissueSampleType", "openminds.controlledterms.UBERONParcellation", "openminds.controlledterms.VisualStimulusType", "openminds.sands.atlas.ParcellationEntity", "openminds.sands.atlas.ParcellationEntityVersion", "openminds.sands.nonatlas.CustomAnatomicalEntity"] ...
        )
        EMBEDDED_PROPERTIES = struct(...
            'customPropertySet', "openminds.core.research.CustomPropertySet" ...
        )
    end

    methods
        function obj = TissueCulturePreparation(structInstance, propValues)
            arguments
                structInstance (1,:) struct = struct.empty
                propValues.?openminds.specimenprep.activity.TissueCulturePreparation
                propValues.id (1,1) string
            end
            propValues = namedargs2cell(propValues);
            obj@openminds.abstract.Schema(structInstance, propValues{:})
        end
    end

    methods (Access = protected)
        function str = getDisplayLabel(obj)
            str = obj.lookupLabel;
        end
    end
end
