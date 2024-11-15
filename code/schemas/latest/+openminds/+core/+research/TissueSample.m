classdef TissueSample < openminds.abstract.Schema
%TissueSample - Structured information on a tissue sample.
%
%   PROPERTIES:
%
%   anatomicalLocation : (1,:) <a href="matlab:help openminds.controlledterms.CellType" style="font-weight:bold">CellType</a>, <a href="matlab:help openminds.controlledterms.Organ" style="font-weight:bold">Organ</a>, <a href="matlab:help openminds.controlledterms.OrganismSubstance" style="font-weight:bold">OrganismSubstance</a>, <a href="matlab:help openminds.controlledterms.SubcellularEntity" style="font-weight:bold">SubcellularEntity</a>, <a href="matlab:help openminds.controlledterms.UBERONParcellation" style="font-weight:bold">UBERONParcellation</a>, <a href="matlab:help openminds.sands.atlas.ParcellationEntity" style="font-weight:bold">ParcellationEntity</a>, <a href="matlab:help openminds.sands.atlas.ParcellationEntityVersion" style="font-weight:bold">ParcellationEntityVersion</a>, <a href="matlab:help openminds.sands.nonatlas.CustomAnatomicalEntity" style="font-weight:bold">CustomAnatomicalEntity</a>
%                        Add all anatomical entities that describe the anatomical location of this tissue sample.
%
%   biologicalSex      : (1,1) <a href="matlab:help openminds.controlledterms.BiologicalSex" style="font-weight:bold">BiologicalSex</a>
%                        Add the biological sex of this specimen.
%
%   internalIdentifier : (1,1) string
%                        Enter the identifier (or label) of this specimen that is used within the corresponding data files to identify this specimen.
%
%   isPartOf           : (1,:) <a href="matlab:help openminds.core.research.TissueSampleCollection" style="font-weight:bold">TissueSampleCollection</a>
%                        Add all tissue sample collections this tissue sample is part of.
%
%   laterality         : (1,:) <a href="matlab:help openminds.controlledterms.Laterality" style="font-weight:bold">Laterality</a>
%                        Add one or both sides of the body, bilateral organ or bilateral organ part that this tissue sample originates from.
%
%   lookupLabel        : (1,1) string
%                        Enter a lookup label for this specimen that may help you to find this instance more easily.
%
%   origin             : (1,1) <a href="matlab:help openminds.controlledterms.CellType" style="font-weight:bold">CellType</a>, <a href="matlab:help openminds.controlledterms.Organ" style="font-weight:bold">Organ</a>, <a href="matlab:help openminds.controlledterms.OrganismSubstance" style="font-weight:bold">OrganismSubstance</a>
%                        Add the biogical origin of this tissue sample.
%
%   species            : (1,1) <a href="matlab:help openminds.controlledterms.Species" style="font-weight:bold">Species</a>, <a href="matlab:help openminds.core.research.Strain" style="font-weight:bold">Strain</a>
%                        Add the species or strain (a sub-type of a genetic variant of species) of this specimen.
%
%   studiedState       : (1,:) <a href="matlab:help openminds.core.research.TissueSampleState" style="font-weight:bold">TissueSampleState</a>
%                        Add all states in which this tissue sample was studied.
%
%   type               : (1,1) <a href="matlab:help openminds.controlledterms.TissueSampleType" style="font-weight:bold">TissueSampleType</a>
%                        Add the type of this tissue sample.

%   This class was auto-generated by the openMINDS pipeline

    properties
        % Add all anatomical entities that describe the anatomical location of this tissue sample.
        anatomicalLocation (1,:) openminds.internal.mixedtype.tissuesample.AnatomicalLocation ...
            {mustBeListOfUniqueItems(anatomicalLocation)}

        % Add the biological sex of this specimen.
        biologicalSex (1,:) openminds.controlledterms.BiologicalSex ...
            {mustBeSpecifiedLength(biologicalSex, 0, 1)}

        % Enter the identifier (or label) of this specimen that is used within the corresponding data files to identify this specimen.
        internalIdentifier (1,1) string

        % Add all tissue sample collections this tissue sample is part of.
        isPartOf (1,:) openminds.core.research.TissueSampleCollection ...
            {mustBeListOfUniqueItems(isPartOf)}

        % Add one or both sides of the body, bilateral organ or bilateral organ part that this tissue sample originates from.
        laterality (1,:) openminds.controlledterms.Laterality ...
            {mustBeSpecifiedLength(laterality, 1, 2)}

        % Enter a lookup label for this specimen that may help you to find this instance more easily.
        lookupLabel (1,1) string

        % Add the biogical origin of this tissue sample.
        origin (1,:) openminds.internal.mixedtype.tissuesample.Origin ...
            {mustBeSpecifiedLength(origin, 0, 1)}

        % Add the species or strain (a sub-type of a genetic variant of species) of this specimen.
        species (1,:) openminds.internal.mixedtype.tissuesample.Species ...
            {mustBeSpecifiedLength(species, 0, 1)}

        % Add all states in which this tissue sample was studied.
        studiedState (1,:) openminds.core.research.TissueSampleState ...
            {mustBeListOfUniqueItems(studiedState)}

        % Add the type of this tissue sample.
        type (1,:) openminds.controlledterms.TissueSampleType ...
            {mustBeSpecifiedLength(type, 0, 1)}
    end

    properties (Access = protected)
        Required = ["origin", "species", "studiedState", "type"]
    end

    properties (Constant, Hidden)
        X_TYPE = "https://openminds.om-i.org/types/TissueSample"
    end

    properties (Constant, Hidden)
        LINKED_PROPERTIES = struct(...
            'anatomicalLocation', ["openminds.controlledterms.CellType", "openminds.controlledterms.Organ", "openminds.controlledterms.OrganismSubstance", "openminds.controlledterms.SubcellularEntity", "openminds.controlledterms.UBERONParcellation", "openminds.sands.atlas.ParcellationEntity", "openminds.sands.atlas.ParcellationEntityVersion", "openminds.sands.nonatlas.CustomAnatomicalEntity"], ...
            'biologicalSex', "openminds.controlledterms.BiologicalSex", ...
            'isPartOf', "openminds.core.research.TissueSampleCollection", ...
            'laterality', "openminds.controlledterms.Laterality", ...
            'origin', ["openminds.controlledterms.CellType", "openminds.controlledterms.Organ", "openminds.controlledterms.OrganismSubstance"], ...
            'species', ["openminds.controlledterms.Species", "openminds.core.research.Strain"], ...
            'studiedState', "openminds.core.research.TissueSampleState", ...
            'type', "openminds.controlledterms.TissueSampleType" ...
        )
        EMBEDDED_PROPERTIES = struct(...
        )
    end

    methods
        function obj = TissueSample(varargin)
            obj@openminds.abstract.Schema(varargin{:})
        end
    end

    methods (Access = protected)
        function str = getDisplayLabel(obj)
            str = sprintf('%s', obj.lookupLabel);
        end
    end
end