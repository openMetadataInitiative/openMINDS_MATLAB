classdef FileBundle < openminds.abstract.Schema
%FileBundle - Structured information on a bundle of file instances.
%
%   PROPERTIES:
%
%   contentDescription : (1,1) string
%                        Enter a short content description for this file bundle.
%
%   format             : (1,1) <a href="matlab:help openminds.core.data.ContentType" style="font-weight:bold">ContentType</a>
%                        If the files within this bundle are organised and formatted according to a formal data structure, add the content type of this file bundle. Leave blank if no formal data structure has been applied to the files within this bundle.
%
%   groupedBy          : (1,:) <a href="matlab:help openminds.controlledterms.AnalysisTechnique" style="font-weight:bold">AnalysisTechnique</a>, <a href="matlab:help openminds.controlledterms.AnatomicalCavity" style="font-weight:bold">AnatomicalCavity</a>, <a href="matlab:help openminds.controlledterms.AuditoryStimulusType" style="font-weight:bold">AuditoryStimulusType</a>, <a href="matlab:help openminds.controlledterms.BiologicalOrder" style="font-weight:bold">BiologicalOrder</a>, <a href="matlab:help openminds.controlledterms.BiologicalSex" style="font-weight:bold">BiologicalSex</a>, <a href="matlab:help openminds.controlledterms.BreedingType" style="font-weight:bold">BreedingType</a>, <a href="matlab:help openminds.controlledterms.CellCultureType" style="font-weight:bold">CellCultureType</a>, <a href="matlab:help openminds.controlledterms.CellType" style="font-weight:bold">CellType</a>, <a href="matlab:help openminds.controlledterms.DeviceType" style="font-weight:bold">DeviceType</a>, <a href="matlab:help openminds.controlledterms.Disease" style="font-weight:bold">Disease</a>, <a href="matlab:help openminds.controlledterms.DiseaseModel" style="font-weight:bold">DiseaseModel</a>, <a href="matlab:help openminds.controlledterms.ElectricalStimulusType" style="font-weight:bold">ElectricalStimulusType</a>, <a href="matlab:help openminds.controlledterms.ExternalBodyRegion" style="font-weight:bold">ExternalBodyRegion</a>, <a href="matlab:help openminds.controlledterms.GeneticStrainType" style="font-weight:bold">GeneticStrainType</a>, <a href="matlab:help openminds.controlledterms.GustatoryStimulusType" style="font-weight:bold">GustatoryStimulusType</a>, <a href="matlab:help openminds.controlledterms.Handedness" style="font-weight:bold">Handedness</a>, <a href="matlab:help openminds.controlledterms.MRIPulseSequence" style="font-weight:bold">MRIPulseSequence</a>, <a href="matlab:help openminds.controlledterms.MRIWeighting" style="font-weight:bold">MRIWeighting</a>, <a href="matlab:help openminds.controlledterms.MolecularEntity" style="font-weight:bold">MolecularEntity</a>, <a href="matlab:help openminds.controlledterms.MuscularStructure" style="font-weight:bold">MuscularStructure</a>, <a href="matlab:help openminds.controlledterms.NervousSystemStructure" style="font-weight:bold">NervousSystemStructure</a>, <a href="matlab:help openminds.controlledterms.OlfactoryStimulusType" style="font-weight:bold">OlfactoryStimulusType</a>, <a href="matlab:help openminds.controlledterms.OpticalStimulusType" style="font-weight:bold">OpticalStimulusType</a>, <a href="matlab:help openminds.controlledterms.Organ" style="font-weight:bold">Organ</a>, <a href="matlab:help openminds.controlledterms.OrganSystemStructure" style="font-weight:bold">OrganSystemStructure</a>, <a href="matlab:help openminds.controlledterms.OrganismSubstance" style="font-weight:bold">OrganismSubstance</a>, <a href="matlab:help openminds.controlledterms.OrganismSystem" style="font-weight:bold">OrganismSystem</a>, <a href="matlab:help openminds.controlledterms.SkeletalStructure" style="font-weight:bold">SkeletalStructure</a>, <a href="matlab:help openminds.controlledterms.Species" style="font-weight:bold">Species</a>, <a href="matlab:help openminds.controlledterms.StimulationApproach" style="font-weight:bold">StimulationApproach</a>, <a href="matlab:help openminds.controlledterms.StimulationTechnique" style="font-weight:bold">StimulationTechnique</a>, <a href="matlab:help openminds.controlledterms.SubcellularEntity" style="font-weight:bold">SubcellularEntity</a>, <a href="matlab:help openminds.controlledterms.TactileStimulusType" style="font-weight:bold">TactileStimulusType</a>, <a href="matlab:help openminds.controlledterms.Technique" style="font-weight:bold">Technique</a>, <a href="matlab:help openminds.controlledterms.TermSuggestion" style="font-weight:bold">TermSuggestion</a>, <a href="matlab:help openminds.controlledterms.TissueSampleType" style="font-weight:bold">TissueSampleType</a>, <a href="matlab:help openminds.controlledterms.TissueStructure" style="font-weight:bold">TissueStructure</a>, <a href="matlab:help openminds.controlledterms.VascularStructure" style="font-weight:bold">VascularStructure</a>, <a href="matlab:help openminds.controlledterms.VisualStimulusType" style="font-weight:bold">VisualStimulusType</a>, <a href="matlab:help openminds.core.data.File" style="font-weight:bold">File</a>, <a href="matlab:help openminds.core.data.FileBundle" style="font-weight:bold">FileBundle</a>, <a href="matlab:help openminds.core.data.LocalFile" style="font-weight:bold">LocalFile</a>, <a href="matlab:help openminds.core.research.BehavioralProtocol" style="font-weight:bold">BehavioralProtocol</a>, <a href="matlab:help openminds.core.research.Subject" style="font-weight:bold">Subject</a>, <a href="matlab:help openminds.core.research.SubjectGroup" style="font-weight:bold">SubjectGroup</a>, <a href="matlab:help openminds.core.research.SubjectGroupState" style="font-weight:bold">SubjectGroupState</a>, <a href="matlab:help openminds.core.research.SubjectState" style="font-weight:bold">SubjectState</a>, <a href="matlab:help openminds.core.research.TissueSample" style="font-weight:bold">TissueSample</a>, <a href="matlab:help openminds.core.research.TissueSampleCollection" style="font-weight:bold">TissueSampleCollection</a>, <a href="matlab:help openminds.core.research.TissueSampleCollectionState" style="font-weight:bold">TissueSampleCollectionState</a>, <a href="matlab:help openminds.core.research.TissueSampleState" style="font-weight:bold">TissueSampleState</a>, <a href="matlab:help openminds.sands.atlas.CommonCoordinateFramework" style="font-weight:bold">CommonCoordinateFramework</a>, <a href="matlab:help openminds.sands.atlas.CommonCoordinateFrameworkVersion" style="font-weight:bold">CommonCoordinateFrameworkVersion</a>, <a href="matlab:help openminds.sands.atlas.ParcellationEntity" style="font-weight:bold">ParcellationEntity</a>, <a href="matlab:help openminds.sands.atlas.ParcellationEntityVersion" style="font-weight:bold">ParcellationEntityVersion</a>, <a href="matlab:help openminds.sands.nonatlas.CustomAnatomicalEntity" style="font-weight:bold">CustomAnatomicalEntity</a>, <a href="matlab:help openminds.sands.nonatlas.CustomCoordinateFramework" style="font-weight:bold">CustomCoordinateFramework</a>
%                        Add all entities that defined which files were grouped into this file bundle. Note that the schema types of the instances stated here, need to match the ones stated under 'groupingType'.
%
%   groupingType       : (1,:) <a href="matlab:help openminds.controlledterms.FileBundleGrouping" style="font-weight:bold">FileBundleGrouping</a>
%                        Add all grouping types that were used to define this file bundle. Note that the grouping types define the possible schema type of the instances stated under 'groupedBy'.
%
%   hash               : (1,1) <a href="matlab:help openminds.core.data.Hash" style="font-weight:bold">Hash</a>
%                        Add the hash that was generated for this file bundle.
%
%   isPartOf           : (1,1) <a href="matlab:help openminds.core.data.FileBundle" style="font-weight:bold">FileBundle</a>, <a href="matlab:help openminds.core.data.FileRepository" style="font-weight:bold">FileRepository</a>
%                        Add the file bundle or file repository this file bundle is part of.
%
%   name               : (1,1) string
%                        Enter the name of this file bundle.
%
%   storageSize        : (1,1) <a href="matlab:help openminds.core.miscellaneous.QuantitativeValue" style="font-weight:bold">QuantitativeValue</a>
%                        Enter the storage size of this file bundle.

%   This class was auto-generated by the openMINDS pipeline

    properties
        % Enter a short content description for this file bundle.
        contentDescription (1,1) string

        % If the files within this bundle are organised and formatted according to a formal data structure, add the content type of this file bundle. Leave blank if no formal data structure has been applied to the files within this bundle.
        format (1,:) openminds.core.data.ContentType ...
            {mustBeScalarOrEmpty(format)}

        % Add all entities that defined which files were grouped into this file bundle. Note that the schema types of the instances stated here, need to match the ones stated under 'groupingType'.
        groupedBy (1,:) openminds.internal.mixedtype.filebundle.GroupedBy ...
            {mustBeMinLength(groupedBy, 1), mustBeListOfUniqueItems(groupedBy)}

        % Add all grouping types that were used to define this file bundle. Note that the grouping types define the possible schema type of the instances stated under 'groupedBy'.
        groupingType (1,:) openminds.controlledterms.FileBundleGrouping ...
            {mustBeMinLength(groupingType, 1), mustBeListOfUniqueItems(groupingType)}

        % Add the hash that was generated for this file bundle.
        hash (1,:) openminds.core.data.Hash ...
            {mustBeScalarOrEmpty(hash)}

        % Add the file bundle or file repository this file bundle is part of.
        isPartOf (1,:) openminds.internal.mixedtype.filebundle.IsPartOf ...
            {mustBeScalarOrEmpty(isPartOf)}

        % Enter the name of this file bundle.
        name (1,1) string

        % Enter the storage size of this file bundle.
        storageSize (1,:) openminds.core.miscellaneous.QuantitativeValue ...
            {mustBeScalarOrEmpty(storageSize)}
    end

    properties (Access = protected)
        Required = ["isPartOf", "name"]
    end

    properties (Constant, Hidden)
        X_TYPE = "https://openminds.om-i.org/types/FileBundle"
    end

    properties (Constant, Hidden)
        LINKED_PROPERTIES = struct(...
            'format', "openminds.core.data.ContentType", ...
            'groupedBy', ["openminds.controlledterms.AnalysisTechnique", "openminds.controlledterms.AnatomicalCavity", "openminds.controlledterms.AuditoryStimulusType", "openminds.controlledterms.BiologicalOrder", "openminds.controlledterms.BiologicalSex", "openminds.controlledterms.BreedingType", "openminds.controlledterms.CellCultureType", "openminds.controlledterms.CellType", "openminds.controlledterms.DeviceType", "openminds.controlledterms.Disease", "openminds.controlledterms.DiseaseModel", "openminds.controlledterms.ElectricalStimulusType", "openminds.controlledterms.ExternalBodyRegion", "openminds.controlledterms.GeneticStrainType", "openminds.controlledterms.GustatoryStimulusType", "openminds.controlledterms.Handedness", "openminds.controlledterms.MRIPulseSequence", "openminds.controlledterms.MRIWeighting", "openminds.controlledterms.MolecularEntity", "openminds.controlledterms.MuscularStructure", "openminds.controlledterms.NervousSystemStructure", "openminds.controlledterms.OlfactoryStimulusType", "openminds.controlledterms.OpticalStimulusType", "openminds.controlledterms.Organ", "openminds.controlledterms.OrganSystemStructure", "openminds.controlledterms.OrganismSubstance", "openminds.controlledterms.OrganismSystem", "openminds.controlledterms.SkeletalStructure", "openminds.controlledterms.Species", "openminds.controlledterms.StimulationApproach", "openminds.controlledterms.StimulationTechnique", "openminds.controlledterms.SubcellularEntity", "openminds.controlledterms.TactileStimulusType", "openminds.controlledterms.Technique", "openminds.controlledterms.TermSuggestion", "openminds.controlledterms.TissueSampleType", "openminds.controlledterms.TissueStructure", "openminds.controlledterms.VascularStructure", "openminds.controlledterms.VisualStimulusType", "openminds.core.data.File", "openminds.core.data.FileBundle", "openminds.core.data.LocalFile", "openminds.core.research.BehavioralProtocol", "openminds.core.research.Subject", "openminds.core.research.SubjectGroup", "openminds.core.research.SubjectGroupState", "openminds.core.research.SubjectState", "openminds.core.research.TissueSample", "openminds.core.research.TissueSampleCollection", "openminds.core.research.TissueSampleCollectionState", "openminds.core.research.TissueSampleState", "openminds.sands.atlas.CommonCoordinateFramework", "openminds.sands.atlas.CommonCoordinateFrameworkVersion", "openminds.sands.atlas.ParcellationEntity", "openminds.sands.atlas.ParcellationEntityVersion", "openminds.sands.nonatlas.CustomAnatomicalEntity", "openminds.sands.nonatlas.CustomCoordinateFramework"], ...
            'groupingType', "openminds.controlledterms.FileBundleGrouping", ...
            'isPartOf', ["openminds.core.data.FileBundle", "openminds.core.data.FileRepository"] ...
        )
        EMBEDDED_PROPERTIES = struct(...
            'hash', "openminds.core.data.Hash", ...
            'storageSize', "openminds.core.miscellaneous.QuantitativeValue" ...
        )
    end

    methods
        function obj = FileBundle(structInstance, propValues)
            arguments
                structInstance (1,:) {mustBeA(structInstance, 'struct')} = struct.empty
                propValues.?openminds.core.data.FileBundle
                propValues.id (1,1) string
            end
            propValues = namedargs2cell(propValues);
            obj@openminds.abstract.Schema(structInstance, propValues{:})
        end
    end

    methods (Access = protected)
        function str = getDisplayLabel(obj)
            str = sprintf('%s (%s)', obj.name, obj.groupedBy);
        end
    end
end
