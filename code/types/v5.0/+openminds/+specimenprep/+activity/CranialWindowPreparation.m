classdef CranialWindowPreparation < openminds.abstract.Schema
%CranialWindowPreparation - No description available.
%
%   PROPERTIES:
%
%   constructionType  : (1,1) <a href="matlab:help openminds.controlledterms.CranialWindowConstructionType" style="font-weight:bold">CranialWindowConstructionType</a>
%                       Add the construction type of the cranial window.
%
%   customPropertySet : (1,:) <a href="matlab:help openminds.core.research.CustomPropertySet" style="font-weight:bold">CustomPropertySet</a>
%                       Add any user-defined parameters grouped in context-specific sets that are not covered in the standardized properties of this activity.
%
%   description       : (1,1) string
%                       Enter a description of this activity.
%
%   dimension         : (1,1) <a href="matlab:help openminds.sands.mathematicalshape.CentroidalPyramid" style="font-weight:bold">CentroidalPyramid</a>, <a href="matlab:help openminds.sands.mathematicalshape.Circle" style="font-weight:bold">Circle</a>, <a href="matlab:help openminds.sands.mathematicalshape.CircularSector" style="font-weight:bold">CircularSector</a>, <a href="matlab:help openminds.sands.mathematicalshape.Cube" style="font-weight:bold">Cube</a>, <a href="matlab:help openminds.sands.mathematicalshape.Ellipse" style="font-weight:bold">Ellipse</a>, <a href="matlab:help openminds.sands.mathematicalshape.Ellipsoid" style="font-weight:bold">Ellipsoid</a>, <a href="matlab:help openminds.sands.mathematicalshape.EquilateralTriangle" style="font-weight:bold">EquilateralTriangle</a>, <a href="matlab:help openminds.sands.mathematicalshape.Frustum" style="font-weight:bold">Frustum</a>, <a href="matlab:help openminds.sands.mathematicalshape.IsoscelesTriangle" style="font-weight:bold">IsoscelesTriangle</a>, <a href="matlab:help openminds.sands.mathematicalshape.Kite" style="font-weight:bold">Kite</a>, <a href="matlab:help openminds.sands.mathematicalshape.Parallelogram" style="font-weight:bold">Parallelogram</a>, <a href="matlab:help openminds.sands.mathematicalshape.Rectangle" style="font-weight:bold">Rectangle</a>, <a href="matlab:help openminds.sands.mathematicalshape.RegularPolygon" style="font-weight:bold">RegularPolygon</a>, <a href="matlab:help openminds.sands.mathematicalshape.Rhombus" style="font-weight:bold">Rhombus</a>, <a href="matlab:help openminds.sands.mathematicalshape.RightCone" style="font-weight:bold">RightCone</a>, <a href="matlab:help openminds.sands.mathematicalshape.RightCylinder" style="font-weight:bold">RightCylinder</a>, <a href="matlab:help openminds.sands.mathematicalshape.RightPrism" style="font-weight:bold">RightPrism</a>, <a href="matlab:help openminds.sands.mathematicalshape.RightTriangle" style="font-weight:bold">RightTriangle</a>, <a href="matlab:help openminds.sands.mathematicalshape.Sphere" style="font-weight:bold">Sphere</a>, <a href="matlab:help openminds.sands.mathematicalshape.Spheroid" style="font-weight:bold">Spheroid</a>, <a href="matlab:help openminds.sands.mathematicalshape.Square" style="font-weight:bold">Square</a>, <a href="matlab:help openminds.sands.mathematicalshape.Trapezoid" style="font-weight:bold">Trapezoid</a>, <a href="matlab:help openminds.sands.mathematicalshape.Triangle" style="font-weight:bold">Triangle</a>
%                       Enter the dimension of the cranial window by defining its mathematical shape.
%
%   endTime           : (1,1) datetime
%                       Enter the date and/or time on when this activity ended, formatted as either '2023-02-07T16:00:00+00:00' (date-time) or '16:00:00+00:00' (time).
%
%   input             : (1,:) <a href="matlab:help openminds.core.research.SubjectState" style="font-weight:bold">SubjectState</a>
%                       Add the state of the subject which received the cranial window before this activity.
%
%   isPartOf          : (1,1) <a href="matlab:help openminds.core.products.DatasetVersion" style="font-weight:bold">DatasetVersion</a>
%                       Add the dataset version in which this activity was conducted.
%
%   lookupLabel       : (1,1) string
%                       Enter a lookup label for this activity that may help you to find this instance more easily.
%
%   output            : (1,:) <a href="matlab:help openminds.core.research.SubjectState" style="font-weight:bold">SubjectState</a>
%                       Add the state of the subject which received the cranial window as a result of this activity.
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
%   reinforcementType : (1,1) <a href="matlab:help openminds.controlledterms.CranialWindowReinforcementType" style="font-weight:bold">CranialWindowReinforcementType</a>
%                       Add the reinforcement type of the cranial window.
%
%   startTime         : (1,1) datetime
%                       Enter the date and/or time on when this activity started, formatted as either '2023-02-07T16:00:00+00:00' (date-time) or '16:00:00+00:00' (time).
%
%   studyTarget       : (1,:) <a href="matlab:help openminds.controlledterms.AnatomicalCavity" style="font-weight:bold">AnatomicalCavity</a>, <a href="matlab:help openminds.controlledterms.AuditoryStimulusType" style="font-weight:bold">AuditoryStimulusType</a>, <a href="matlab:help openminds.controlledterms.BiologicalOrder" style="font-weight:bold">BiologicalOrder</a>, <a href="matlab:help openminds.controlledterms.BiologicalSex" style="font-weight:bold">BiologicalSex</a>, <a href="matlab:help openminds.controlledterms.BreedingType" style="font-weight:bold">BreedingType</a>, <a href="matlab:help openminds.controlledterms.CellCultureType" style="font-weight:bold">CellCultureType</a>, <a href="matlab:help openminds.controlledterms.CellType" style="font-weight:bold">CellType</a>, <a href="matlab:help openminds.controlledterms.DeviceType" style="font-weight:bold">DeviceType</a>, <a href="matlab:help openminds.controlledterms.Disease" style="font-weight:bold">Disease</a>, <a href="matlab:help openminds.controlledterms.DiseaseModel" style="font-weight:bold">DiseaseModel</a>, <a href="matlab:help openminds.controlledterms.ElectricalStimulusType" style="font-weight:bold">ElectricalStimulusType</a>, <a href="matlab:help openminds.controlledterms.ExternalBodyRegion" style="font-weight:bold">ExternalBodyRegion</a>, <a href="matlab:help openminds.controlledterms.GeneticStrainType" style="font-weight:bold">GeneticStrainType</a>, <a href="matlab:help openminds.controlledterms.GustatoryStimulusType" style="font-weight:bold">GustatoryStimulusType</a>, <a href="matlab:help openminds.controlledterms.Handedness" style="font-weight:bold">Handedness</a>, <a href="matlab:help openminds.controlledterms.MolecularEntity" style="font-weight:bold">MolecularEntity</a>, <a href="matlab:help openminds.controlledterms.MuscularStructure" style="font-weight:bold">MuscularStructure</a>, <a href="matlab:help openminds.controlledterms.NervousSystemStructure" style="font-weight:bold">NervousSystemStructure</a>, <a href="matlab:help openminds.controlledterms.OlfactoryStimulusType" style="font-weight:bold">OlfactoryStimulusType</a>, <a href="matlab:help openminds.controlledterms.OpticalStimulusType" style="font-weight:bold">OpticalStimulusType</a>, <a href="matlab:help openminds.controlledterms.Organ" style="font-weight:bold">Organ</a>, <a href="matlab:help openminds.controlledterms.OrganSystemStructure" style="font-weight:bold">OrganSystemStructure</a>, <a href="matlab:help openminds.controlledterms.OrganismSubstance" style="font-weight:bold">OrganismSubstance</a>, <a href="matlab:help openminds.controlledterms.OrganismSystem" style="font-weight:bold">OrganismSystem</a>, <a href="matlab:help openminds.controlledterms.SkeletalStructure" style="font-weight:bold">SkeletalStructure</a>, <a href="matlab:help openminds.controlledterms.Species" style="font-weight:bold">Species</a>, <a href="matlab:help openminds.controlledterms.SubcellularEntity" style="font-weight:bold">SubcellularEntity</a>, <a href="matlab:help openminds.controlledterms.TactileStimulusType" style="font-weight:bold">TactileStimulusType</a>, <a href="matlab:help openminds.controlledterms.TermSuggestion" style="font-weight:bold">TermSuggestion</a>, <a href="matlab:help openminds.controlledterms.TissueSampleType" style="font-weight:bold">TissueSampleType</a>, <a href="matlab:help openminds.controlledterms.TissueStructure" style="font-weight:bold">TissueStructure</a>, <a href="matlab:help openminds.controlledterms.VascularStructure" style="font-weight:bold">VascularStructure</a>, <a href="matlab:help openminds.controlledterms.VisualStimulusType" style="font-weight:bold">VisualStimulusType</a>, <a href="matlab:help openminds.sands.atlas.ParcellationEntity" style="font-weight:bold">ParcellationEntity</a>, <a href="matlab:help openminds.sands.atlas.ParcellationEntityVersion" style="font-weight:bold">ParcellationEntityVersion</a>, <a href="matlab:help openminds.sands.nonatlas.CustomAnatomicalEntity" style="font-weight:bold">CustomAnatomicalEntity</a>
%                       Add all study targets of this activity.

%   This class was auto-generated by the openMINDS pipeline

    properties
        % Add the construction type of the cranial window.
        constructionType (1,:) openminds.controlledterms.CranialWindowConstructionType ...
            {mustBeSpecifiedLength(constructionType, 0, 1)}

        % Add any user-defined parameters grouped in context-specific sets that are not covered in the standardized properties of this activity.
        customPropertySet (1,:) openminds.core.research.CustomPropertySet ...
            {mustBeListOfUniqueItems(customPropertySet)}

        % Enter a description of this activity.
        description (1,1) string

        % Enter the dimension of the cranial window by defining its mathematical shape.
        dimension (1,:) openminds.internal.mixedtype.cranialwindowpreparation.Dimension ...
            {mustBeSpecifiedLength(dimension, 0, 1)}

        % Enter the date and/or time on when this activity ended, formatted as either '2023-02-07T16:00:00+00:00' (date-time) or '16:00:00+00:00' (time).
        endTime (1,:) datetime ...
            {mustBeSpecifiedLength(endTime, 0, 1)}

        % Add the state of the subject which received the cranial window before this activity.
        input (1,:) openminds.core.research.SubjectState ...
            {mustBeListOfUniqueItems(input)}

        % Add the dataset version in which this activity was conducted.
        isPartOf (1,:) openminds.core.products.DatasetVersion ...
            {mustBeSpecifiedLength(isPartOf, 0, 1)}

        % Enter a lookup label for this activity that may help you to find this instance more easily.
        lookupLabel (1,1) string

        % Add the state of the subject which received the cranial window as a result of this activity.
        output (1,:) openminds.core.research.SubjectState ...
            {mustBeListOfUniqueItems(output)}

        % Add all agents that performed this activity.
        performedBy (1,:) openminds.internal.mixedtype.cranialwindowpreparation.PerformedBy ...
            {mustBeListOfUniqueItems(performedBy)}

        % Add the initial preparation type for this activity.
        preparationDesign (1,:) openminds.controlledterms.PreparationType ...
            {mustBeSpecifiedLength(preparationDesign, 0, 1)}

        % Add all protocols used during this activity.
        protocol (1,:) openminds.core.research.Protocol ...
            {mustBeListOfUniqueItems(protocol)}

        % Add the reinforcement type of the cranial window.
        reinforcementType (1,:) openminds.controlledterms.CranialWindowReinforcementType ...
            {mustBeSpecifiedLength(reinforcementType, 0, 1)}

        % Enter the date and/or time on when this activity started, formatted as either '2023-02-07T16:00:00+00:00' (date-time) or '16:00:00+00:00' (time).
        startTime (1,:) datetime ...
            {mustBeSpecifiedLength(startTime, 0, 1)}

        % Add all study targets of this activity.
        studyTarget (1,:) openminds.internal.mixedtype.cranialwindowpreparation.StudyTarget ...
            {mustBeListOfUniqueItems(studyTarget)}
    end

    properties (Access = protected)
        Required = ["constructionType", "input", "isPartOf", "output", "protocol"]
    end

    properties (Constant, Hidden)
        X_TYPE = "https://openminds.om-i.org/types/CranialWindowPreparation"
    end

    properties (Constant, Hidden)
        LINKED_PROPERTIES = struct(...
            'constructionType', "openminds.controlledterms.CranialWindowConstructionType", ...
            'input', "openminds.core.research.SubjectState", ...
            'isPartOf', "openminds.core.products.DatasetVersion", ...
            'output', "openminds.core.research.SubjectState", ...
            'performedBy', ["openminds.computation.SoftwareAgent", "openminds.core.actors.Person"], ...
            'preparationDesign', "openminds.controlledterms.PreparationType", ...
            'protocol', "openminds.core.research.Protocol", ...
            'reinforcementType', "openminds.controlledterms.CranialWindowReinforcementType", ...
            'studyTarget', ["openminds.controlledterms.AnatomicalCavity", "openminds.controlledterms.AuditoryStimulusType", "openminds.controlledterms.BiologicalOrder", "openminds.controlledterms.BiologicalSex", "openminds.controlledterms.BreedingType", "openminds.controlledterms.CellCultureType", "openminds.controlledterms.CellType", "openminds.controlledterms.DeviceType", "openminds.controlledterms.Disease", "openminds.controlledterms.DiseaseModel", "openminds.controlledterms.ElectricalStimulusType", "openminds.controlledterms.ExternalBodyRegion", "openminds.controlledterms.GeneticStrainType", "openminds.controlledterms.GustatoryStimulusType", "openminds.controlledterms.Handedness", "openminds.controlledterms.MolecularEntity", "openminds.controlledterms.MuscularStructure", "openminds.controlledterms.NervousSystemStructure", "openminds.controlledterms.OlfactoryStimulusType", "openminds.controlledterms.OpticalStimulusType", "openminds.controlledterms.Organ", "openminds.controlledterms.OrganSystemStructure", "openminds.controlledterms.OrganismSubstance", "openminds.controlledterms.OrganismSystem", "openminds.controlledterms.SkeletalStructure", "openminds.controlledterms.Species", "openminds.controlledterms.SubcellularEntity", "openminds.controlledterms.TactileStimulusType", "openminds.controlledterms.TermSuggestion", "openminds.controlledterms.TissueSampleType", "openminds.controlledterms.TissueStructure", "openminds.controlledterms.VascularStructure", "openminds.controlledterms.VisualStimulusType", "openminds.sands.atlas.ParcellationEntity", "openminds.sands.atlas.ParcellationEntityVersion", "openminds.sands.nonatlas.CustomAnatomicalEntity"] ...
        )
        EMBEDDED_PROPERTIES = struct(...
            'customPropertySet', "openminds.core.research.CustomPropertySet", ...
            'dimension', ["openminds.sands.mathematicalshape.CentroidalPyramid", "openminds.sands.mathematicalshape.Circle", "openminds.sands.mathematicalshape.CircularSector", "openminds.sands.mathematicalshape.Cube", "openminds.sands.mathematicalshape.Ellipse", "openminds.sands.mathematicalshape.Ellipsoid", "openminds.sands.mathematicalshape.EquilateralTriangle", "openminds.sands.mathematicalshape.Frustum", "openminds.sands.mathematicalshape.IsoscelesTriangle", "openminds.sands.mathematicalshape.Kite", "openminds.sands.mathematicalshape.Parallelogram", "openminds.sands.mathematicalshape.Rectangle", "openminds.sands.mathematicalshape.RegularPolygon", "openminds.sands.mathematicalshape.Rhombus", "openminds.sands.mathematicalshape.RightCone", "openminds.sands.mathematicalshape.RightCylinder", "openminds.sands.mathematicalshape.RightPrism", "openminds.sands.mathematicalshape.RightTriangle", "openminds.sands.mathematicalshape.Sphere", "openminds.sands.mathematicalshape.Spheroid", "openminds.sands.mathematicalshape.Square", "openminds.sands.mathematicalshape.Trapezoid", "openminds.sands.mathematicalshape.Triangle"] ...
        )
    end

    methods
        function obj = CranialWindowPreparation(structInstance, propValues)
            arguments
                structInstance (1,:) {mustBeA(structInstance, 'struct')} = struct.empty
                propValues.?openminds.specimenprep.activity.CranialWindowPreparation
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
