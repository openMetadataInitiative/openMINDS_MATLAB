classdef TissueSample < openminds.abstract.Schema
%TissueSample - Structured information on a tissue sample.
%
%   PROPERTIES:
%
%   biologicalSex      : (1,1) <a href="matlab:help openminds.controlledterms.BiologicalSex" style="font-weight:bold">BiologicalSex</a>
%                        Add the biological sex of this specimen.
%
%   internalIdentifier : (1,1) string
%                        Enter the identifier of this specimen that is used within the corresponding data.
%
%   isPartOf           : (1,:) <a href="matlab:help openminds.core.research.TissueSampleCollection" style="font-weight:bold">TissueSampleCollection</a>
%                        Add all tissue sample collections of which this tissue sample is part of.
%
%   laterality         : (1,:) <a href="matlab:help openminds.controlledterms.Laterality" style="font-weight:bold">Laterality</a>
%                        Add one or both hemisphere sides from which this tissue sample originates from.
%
%   lookupLabel        : (1,1) string
%                        Enter a lookup label for this specimen that may help you to more easily find it again.
%
%   origin             : (1,1) <a href="matlab:help openminds.controlledterms.CellType" style="font-weight:bold">CellType</a>, <a href="matlab:help openminds.controlledterms.Organ" style="font-weight:bold">Organ</a>
%                        Add the biogical origin (organ or cell type) of this tissue sample.
%
%   phenotype          : (1,1) <a href="matlab:help openminds.controlledterms.Phenotype" style="font-weight:bold">Phenotype</a>
%                        Add the phenotype of this specimen.
%
%   species            : (1,1) <a href="matlab:help openminds.controlledterms.Species" style="font-weight:bold">Species</a>
%                        Add the species of this specimen.
%
%   strain             : (1,1) <a href="matlab:help openminds.controlledterms.Strain" style="font-weight:bold">Strain</a>
%                        Add the strain of this specimen.
%
%   studiedState       : (1,:) <a href="matlab:help openminds.core.research.TissueSampleState" style="font-weight:bold">TissueSampleState</a>
%                        Add all states in which this tissue sample was studied.
%
%   type               : (1,1) <a href="matlab:help openminds.controlledterms.TissueSampleType" style="font-weight:bold">TissueSampleType</a>
%                        Add the type of this tissue sample.

%   This class was auto-generated by the openMINDS pipeline

    properties
        % Add the biological sex of this specimen.
        biologicalSex (1,:) openminds.controlledterms.BiologicalSex ...
            {mustBeSpecifiedLength(biologicalSex, 0, 1)}

        % Enter the identifier of this specimen that is used within the corresponding data.
        internalIdentifier (1,1) string

        % Add all tissue sample collections of which this tissue sample is part of.
        isPartOf (1,:) openminds.core.research.TissueSampleCollection ...
            {mustBeListOfUniqueItems(isPartOf)}

        % Add one or both hemisphere sides from which this tissue sample originates from.
        laterality (1,:) openminds.controlledterms.Laterality ...
            {mustBeSpecifiedLength(laterality, 1, 2)}

        % Enter a lookup label for this specimen that may help you to more easily find it again.
        lookupLabel (1,1) string

        % Add the biogical origin (organ or cell type) of this tissue sample.
        origin (1,:) openminds.internal.mixedtype.tissuesample.Origin ...
            {mustBeSpecifiedLength(origin, 0, 1)}

        % Add the phenotype of this specimen.
        phenotype (1,:) openminds.controlledterms.Phenotype ...
            {mustBeSpecifiedLength(phenotype, 0, 1)}

        % Add the species of this specimen.
        species (1,:) openminds.controlledterms.Species ...
            {mustBeSpecifiedLength(species, 0, 1)}

        % Add the strain of this specimen.
        strain (1,:) openminds.controlledterms.Strain ...
            {mustBeSpecifiedLength(strain, 0, 1)}

        % Add all states in which this tissue sample was studied.
        studiedState (1,:) openminds.core.research.TissueSampleState ...
            {mustBeListOfUniqueItems(studiedState)}

        % Add the type of this tissue sample.
        type (1,:) openminds.controlledterms.TissueSampleType ...
            {mustBeSpecifiedLength(type, 0, 1)}
    end

    properties (Access = protected)
        Required = ["biologicalSex", "internalIdentifier", "origin", "species", "studiedState", "type"]
    end

    properties (Constant, Hidden)
        X_TYPE = "https://openminds.ebrains.eu/core/TissueSample"
    end

    properties (Constant, Hidden)
        LINKED_PROPERTIES = struct(...
            'biologicalSex', "openminds.controlledterms.BiologicalSex", ...
            'isPartOf', "openminds.core.research.TissueSampleCollection", ...
            'laterality', "openminds.controlledterms.Laterality", ...
            'origin', ["openminds.controlledterms.CellType", "openminds.controlledterms.Organ"], ...
            'phenotype', "openminds.controlledterms.Phenotype", ...
            'species', "openminds.controlledterms.Species", ...
            'strain', "openminds.controlledterms.Strain", ...
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