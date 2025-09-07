classdef PipetteUsage < openminds.abstract.Schema
%PipetteUsage - No description available.
%
%   PROPERTIES:
%
%   anatomicalLocation        : (1,1) <a href="matlab:help openminds.controlledterms.CellType" style="font-weight:bold">CellType</a>, <a href="matlab:help openminds.controlledterms.Organ" style="font-weight:bold">Organ</a>, <a href="matlab:help openminds.controlledterms.OrganismSubstance" style="font-weight:bold">OrganismSubstance</a>, <a href="matlab:help openminds.controlledterms.SubcellularEntity" style="font-weight:bold">SubcellularEntity</a>, <a href="matlab:help openminds.controlledterms.UBERONParcellation" style="font-weight:bold">UBERONParcellation</a>, <a href="matlab:help openminds.sands.atlas.ParcellationEntity" style="font-weight:bold">ParcellationEntity</a>, <a href="matlab:help openminds.sands.atlas.ParcellationEntityVersion" style="font-weight:bold">ParcellationEntityVersion</a>, <a href="matlab:help openminds.sands.nonatlas.CustomAnatomicalEntity" style="font-weight:bold">CustomAnatomicalEntity</a>
%                               Add the anatomical entity that semantically best describes the anatomical location of the pipette tip.
%
%   chlorideReversalPotential : (1,:) <a href="matlab:help openminds.core.data.Measurement" style="font-weight:bold">Measurement</a>
%                               Enter all chloride reversal potentials for the intracellular solution(s) of the pipette measured during its use.
%
%   compensationCurrent       : (1,1) <a href="matlab:help openminds.core.data.Measurement" style="font-weight:bold">Measurement</a>
%                               Enter the compensation current for the series resistance of the pipette measured during its use.
%
%   device                    : (1,1) <a href="matlab:help openminds.ephys.device.Pipette" style="font-weight:bold">Pipette</a>
%                               Add the pipette used.
%
%   endMembranePotential      : (1,1) <a href="matlab:help openminds.core.data.Measurement" style="font-weight:bold">Measurement</a>
%                               Enter the membrane potential of e.g., a patched cell at the end of a recording measured during the use of this pipette.
%
%   holdingPotential          : (1,1) <a href="matlab:help openminds.core.data.Measurement" style="font-weight:bold">Measurement</a>
%                               Enter the holding membrane potential of e.g., a patched cell measured during the use of this pipette.
%
%   inputResistance           : (1,1) <a href="matlab:help openminds.core.data.Measurement" style="font-weight:bold">Measurement</a>
%                               Enter the input resistance of e.g., a patched cell measured during the use of this pipette.
%
%   labelingCompound          : (1,1) <a href="matlab:help openminds.chemicals.ChemicalMixture" style="font-weight:bold">ChemicalMixture</a>, <a href="matlab:help openminds.chemicals.ChemicalSubstance" style="font-weight:bold">ChemicalSubstance</a>, <a href="matlab:help openminds.controlledterms.MolecularEntity" style="font-weight:bold">MolecularEntity</a>
%                               Add the used compound for labelling e.g., a patched cell during the use of this pipette.
%
%   liquidJunctionPotential   : (1,1) <a href="matlab:help openminds.core.data.Measurement" style="font-weight:bold">Measurement</a>
%                               Enter the liquid junction potential of e.g., a patched cell measured during the use of this pipette.
%
%   lookupLabel               : (1,1) string
%                               Enter a lookup label for this device usage that may help you to find this instance more easily.
%
%   metadataLocation          : (1,:) <a href="matlab:help openminds.core.data.File" style="font-weight:bold">File</a>, <a href="matlab:help openminds.core.data.FileBundle" style="font-weight:bold">FileBundle</a>
%                               Add all files or file bundles containing additional information about the usage of this device.
%
%   pipetteResistance         : (1,1) <a href="matlab:help openminds.core.miscellaneous.QuantitativeValue" style="font-weight:bold">QuantitativeValue</a>, <a href="matlab:help openminds.core.miscellaneous.QuantitativeValueRange" style="font-weight:bold">QuantitativeValueRange</a>
%                               Enter the resistance of the pipette during its use.
%
%   pipetteSolution           : (1,1) <a href="matlab:help openminds.chemicals.ChemicalMixture" style="font-weight:bold">ChemicalMixture</a>
%                               Enter the solution with which the pipette was filled during its use.
%
%   sealResistance            : (1,1) <a href="matlab:help openminds.core.data.Measurement" style="font-weight:bold">Measurement</a>
%                               Enter the seal resistance of e.g., a patched cell measured during the use of this pipette.
%
%   seriesResistance          : (1,1) <a href="matlab:help openminds.core.data.Measurement" style="font-weight:bold">Measurement</a>
%                               Enter the series resistance of the pipette measured during its use.
%
%   spatialLocation           : (1,1) <a href="matlab:help openminds.sands.miscellaneous.CoordinatePoint" style="font-weight:bold">CoordinatePoint</a>
%                               Add the coordinate point that best describes the spatial location of the pipette tip during its use.
%
%   startMembranePotential    : (1,1) <a href="matlab:help openminds.core.data.Measurement" style="font-weight:bold">Measurement</a>
%                               Enter the membrane potential of e.g., a patched cell at the beginning of a recording measured during the use of this pipette.
%
%   usedSpecimen              : (1,1) <a href="matlab:help openminds.core.research.SubjectState" style="font-weight:bold">SubjectState</a>, <a href="matlab:help openminds.core.research.TissueSampleState" style="font-weight:bold">TissueSampleState</a>
%                               Add the state of the tissue sample or subject that this device was used on.

%   This class was auto-generated by the openMINDS pipeline

    properties
        % Add the anatomical entity that semantically best describes the anatomical location of the pipette tip.
        anatomicalLocation (1,:) openminds.internal.mixedtype.pipetteusage.AnatomicalLocation ...
            {mustBeSpecifiedLength(anatomicalLocation, 0, 1)}

        % Enter all chloride reversal potentials for the intracellular solution(s) of the pipette measured during its use.
        chlorideReversalPotential (1,:) openminds.core.data.Measurement

        % Enter the compensation current for the series resistance of the pipette measured during its use.
        compensationCurrent (1,:) openminds.core.data.Measurement ...
            {mustBeSpecifiedLength(compensationCurrent, 0, 1)}

        % Add the pipette used.
        device (1,:) openminds.ephys.device.Pipette ...
            {mustBeSpecifiedLength(device, 0, 1)}

        % Enter the membrane potential of e.g., a patched cell at the end of a recording measured during the use of this pipette.
        endMembranePotential (1,:) openminds.core.data.Measurement ...
            {mustBeSpecifiedLength(endMembranePotential, 0, 1)}

        % Enter the holding membrane potential of e.g., a patched cell measured during the use of this pipette.
        holdingPotential (1,:) openminds.core.data.Measurement ...
            {mustBeSpecifiedLength(holdingPotential, 0, 1)}

        % Enter the input resistance of e.g., a patched cell measured during the use of this pipette.
        inputResistance (1,:) openminds.core.data.Measurement ...
            {mustBeSpecifiedLength(inputResistance, 0, 1)}

        % Add the used compound for labelling e.g., a patched cell during the use of this pipette.
        labelingCompound (1,:) openminds.internal.mixedtype.pipetteusage.LabelingCompound ...
            {mustBeSpecifiedLength(labelingCompound, 0, 1)}

        % Enter the liquid junction potential of e.g., a patched cell measured during the use of this pipette.
        liquidJunctionPotential (1,:) openminds.core.data.Measurement ...
            {mustBeSpecifiedLength(liquidJunctionPotential, 0, 1)}

        % Enter a lookup label for this device usage that may help you to find this instance more easily.
        lookupLabel (1,1) string

        % Add all files or file bundles containing additional information about the usage of this device.
        metadataLocation (1,:) openminds.internal.mixedtype.pipetteusage.MetadataLocation ...
            {mustBeListOfUniqueItems(metadataLocation)}

        % Enter the resistance of the pipette during its use.
        pipetteResistance (1,:) openminds.internal.mixedtype.pipetteusage.PipetteResistance ...
            {mustBeSpecifiedLength(pipetteResistance, 0, 1)}

        % Enter the solution with which the pipette was filled during its use.
        pipetteSolution (1,:) openminds.chemicals.ChemicalMixture ...
            {mustBeSpecifiedLength(pipetteSolution, 0, 1)}

        % Enter the seal resistance of e.g., a patched cell measured during the use of this pipette.
        sealResistance (1,:) openminds.core.data.Measurement ...
            {mustBeSpecifiedLength(sealResistance, 0, 1)}

        % Enter the series resistance of the pipette measured during its use.
        seriesResistance (1,:) openminds.core.data.Measurement ...
            {mustBeSpecifiedLength(seriesResistance, 0, 1)}

        % Add the coordinate point that best describes the spatial location of the pipette tip during its use.
        spatialLocation (1,:) openminds.sands.miscellaneous.CoordinatePoint ...
            {mustBeSpecifiedLength(spatialLocation, 0, 1)}

        % Enter the membrane potential of e.g., a patched cell at the beginning of a recording measured during the use of this pipette.
        startMembranePotential (1,:) openminds.core.data.Measurement ...
            {mustBeSpecifiedLength(startMembranePotential, 0, 1)}

        % Add the state of the tissue sample or subject that this device was used on.
        usedSpecimen (1,:) openminds.internal.mixedtype.pipetteusage.UsedSpecimen ...
            {mustBeSpecifiedLength(usedSpecimen, 0, 1)}
    end

    properties (Access = protected)
        Required = ["device", "pipetteSolution"]
    end

    properties (Constant, Hidden)
        X_TYPE = "https://openminds.ebrains.eu/ephys/PipetteUsage"
    end

    properties (Constant, Hidden)
        LINKED_PROPERTIES = struct(...
            'anatomicalLocation', ["openminds.controlledterms.CellType", "openminds.controlledterms.Organ", "openminds.controlledterms.OrganismSubstance", "openminds.controlledterms.SubcellularEntity", "openminds.controlledterms.UBERONParcellation", "openminds.sands.atlas.ParcellationEntity", "openminds.sands.atlas.ParcellationEntityVersion", "openminds.sands.nonatlas.CustomAnatomicalEntity"], ...
            'device', "openminds.ephys.device.Pipette", ...
            'labelingCompound', ["openminds.chemicals.ChemicalMixture", "openminds.chemicals.ChemicalSubstance", "openminds.controlledterms.MolecularEntity"], ...
            'metadataLocation', ["openminds.core.data.File", "openminds.core.data.FileBundle"], ...
            'pipetteSolution', "openminds.chemicals.ChemicalMixture", ...
            'usedSpecimen', ["openminds.core.research.SubjectState", "openminds.core.research.TissueSampleState"] ...
        )
        EMBEDDED_PROPERTIES = struct(...
            'chlorideReversalPotential', "openminds.core.data.Measurement", ...
            'compensationCurrent', "openminds.core.data.Measurement", ...
            'endMembranePotential', "openminds.core.data.Measurement", ...
            'holdingPotential', "openminds.core.data.Measurement", ...
            'inputResistance', "openminds.core.data.Measurement", ...
            'liquidJunctionPotential', "openminds.core.data.Measurement", ...
            'pipetteResistance', ["openminds.core.miscellaneous.QuantitativeValue", "openminds.core.miscellaneous.QuantitativeValueRange"], ...
            'sealResistance', "openminds.core.data.Measurement", ...
            'seriesResistance', "openminds.core.data.Measurement", ...
            'spatialLocation', "openminds.sands.miscellaneous.CoordinatePoint", ...
            'startMembranePotential', "openminds.core.data.Measurement" ...
        )
    end

    methods
        function obj = PipetteUsage(structInstance, propValues)
            arguments
                structInstance (1,:) struct = struct.empty
                propValues.?openminds.ephys.device.PipetteUsage
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
