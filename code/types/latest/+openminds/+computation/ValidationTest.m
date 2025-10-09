classdef ValidationTest < openminds.abstract.Schema
%ValidationTest - Structured information about the definition of a process for validating a computational model.
%
%   PROPERTIES:
%
%   custodian                : (1,:) <a href="matlab:help openminds.core.actors.Consortium" style="font-weight:bold">Consortium</a>, <a href="matlab:help openminds.core.actors.Organization" style="font-weight:bold">Organization</a>, <a href="matlab:help openminds.core.actors.Person" style="font-weight:bold">Person</a>
%                              Add all parties that fulfill the role of a custodian for this research product (e.g., a research group leader or principle investigator). Custodians are typically the main contact in case of misconduct, obtain permission from the contributors to publish personal information, and maintain the content and quality of the data, metadata, and/or code of the research product. Unless specified differently, this custodian will be responsible for all attached research product versions.
%
%   description              : (1,1) string
%                              Enter a description (or abstract) of this research product. Note that this should be a suitable description for all attached research product versions.
%
%   developer                : (1,:) <a href="matlab:help openminds.core.actors.Consortium" style="font-weight:bold">Consortium</a>, <a href="matlab:help openminds.core.actors.Organization" style="font-weight:bold">Organization</a>, <a href="matlab:help openminds.core.actors.Person" style="font-weight:bold">Person</a>
%                              Add all parties that developed this validation test.
%
%   digitalIdentifier        : (1,1) <a href="matlab:help openminds.core.digitalidentifier.DOI" style="font-weight:bold">DOI</a>
%                              Add the globally unique and persistent digital identifier of this research product. Note that this digital identifier will be used to reference all attached research product versions.
%
%   fullName                 : (1,1) string
%                              Enter a descriptive full name (or title) for this research product. Note that this should be a suitable full name for all attached research product versions.
%
%   hasVersion               : (1,:) <a href="matlab:help openminds.computation.ValidationTestVersion" style="font-weight:bold">ValidationTestVersion</a>
%                              Add all versions of this validation test.
%
%   homepage                 : (1,1) string
%                              Enter the internationalized resource identifier (IRI) to the homepage of this research product.
%
%   howToCite                : (1,1) string
%                              Enter the preferred citation text for this research product. Leave blank if citation text can be extracted from the assigned digital identifier.
%
%   referenceDataAcquisition : (1,:) <a href="matlab:help openminds.controlledterms.Technique" style="font-weight:bold">Technique</a>
%                              Add all acquisition techniques that were used to obtain the reference data for this validation test.
%
%   scope                    : (1,1) <a href="matlab:help openminds.controlledterms.ModelScope" style="font-weight:bold">ModelScope</a>
%                              Add the scope of this validation test.
%
%   scoreType                : (1,1) <a href="matlab:help openminds.controlledterms.DifferenceMeasure" style="font-weight:bold">DifferenceMeasure</a>
%                              Add the type of score calculated in this validation test.
%
%   shortName                : (1,1) string
%                              Enter a short name (or alias) for this research product that could be used as a shortened display title (e.g., for web services with too little space to display the full name).
%
%   studyTarget              : (1,:) <a href="matlab:help openminds.controlledterms.AuditoryStimulusType" style="font-weight:bold">AuditoryStimulusType</a>, <a href="matlab:help openminds.controlledterms.BiologicalOrder" style="font-weight:bold">BiologicalOrder</a>, <a href="matlab:help openminds.controlledterms.BiologicalSex" style="font-weight:bold">BiologicalSex</a>, <a href="matlab:help openminds.controlledterms.BreedingType" style="font-weight:bold">BreedingType</a>, <a href="matlab:help openminds.controlledterms.CellCultureType" style="font-weight:bold">CellCultureType</a>, <a href="matlab:help openminds.controlledterms.CellType" style="font-weight:bold">CellType</a>, <a href="matlab:help openminds.controlledterms.Disease" style="font-weight:bold">Disease</a>, <a href="matlab:help openminds.controlledterms.DiseaseModel" style="font-weight:bold">DiseaseModel</a>, <a href="matlab:help openminds.controlledterms.ElectricalStimulusType" style="font-weight:bold">ElectricalStimulusType</a>, <a href="matlab:help openminds.controlledterms.GeneticStrainType" style="font-weight:bold">GeneticStrainType</a>, <a href="matlab:help openminds.controlledterms.GustatoryStimulusType" style="font-weight:bold">GustatoryStimulusType</a>, <a href="matlab:help openminds.controlledterms.Handedness" style="font-weight:bold">Handedness</a>, <a href="matlab:help openminds.controlledterms.MolecularEntity" style="font-weight:bold">MolecularEntity</a>, <a href="matlab:help openminds.controlledterms.OlfactoryStimulusType" style="font-weight:bold">OlfactoryStimulusType</a>, <a href="matlab:help openminds.controlledterms.OpticalStimulusType" style="font-weight:bold">OpticalStimulusType</a>, <a href="matlab:help openminds.controlledterms.Organ" style="font-weight:bold">Organ</a>, <a href="matlab:help openminds.controlledterms.OrganismSubstance" style="font-weight:bold">OrganismSubstance</a>, <a href="matlab:help openminds.controlledterms.OrganismSystem" style="font-weight:bold">OrganismSystem</a>, <a href="matlab:help openminds.controlledterms.Species" style="font-weight:bold">Species</a>, <a href="matlab:help openminds.controlledterms.SubcellularEntity" style="font-weight:bold">SubcellularEntity</a>, <a href="matlab:help openminds.controlledterms.TactileStimulusType" style="font-weight:bold">TactileStimulusType</a>, <a href="matlab:help openminds.controlledterms.TermSuggestion" style="font-weight:bold">TermSuggestion</a>, <a href="matlab:help openminds.controlledterms.TissueSampleType" style="font-weight:bold">TissueSampleType</a>, <a href="matlab:help openminds.controlledterms.UBERONParcellation" style="font-weight:bold">UBERONParcellation</a>, <a href="matlab:help openminds.controlledterms.VisualStimulusType" style="font-weight:bold">VisualStimulusType</a>, <a href="matlab:help openminds.sands.atlas.ParcellationEntity" style="font-weight:bold">ParcellationEntity</a>, <a href="matlab:help openminds.sands.atlas.ParcellationEntityVersion" style="font-weight:bold">ParcellationEntityVersion</a>, <a href="matlab:help openminds.sands.nonatlas.CustomAnatomicalEntity" style="font-weight:bold">CustomAnatomicalEntity</a>
%                              Add all study targets of this validation test.

%   This class was auto-generated by the openMINDS pipeline

    properties
        % Add all parties that fulfill the role of a custodian for this research product (e.g., a research group leader or principle investigator). Custodians are typically the main contact in case of misconduct, obtain permission from the contributors to publish personal information, and maintain the content and quality of the data, metadata, and/or code of the research product. Unless specified differently, this custodian will be responsible for all attached research product versions.
        custodian (1,:) openminds.internal.mixedtype.validationtest.Custodian ...
            {mustBeListOfUniqueItems(custodian)}

        % Enter a description (or abstract) of this research product. Note that this should be a suitable description for all attached research product versions.
        description (1,1) string

        % Add all parties that developed this validation test.
        developer (1,:) openminds.internal.mixedtype.validationtest.Developer ...
            {mustBeListOfUniqueItems(developer)}

        % Add the globally unique and persistent digital identifier of this research product. Note that this digital identifier will be used to reference all attached research product versions.
        digitalIdentifier (1,:) openminds.core.digitalidentifier.DOI ...
            {mustBeSpecifiedLength(digitalIdentifier, 0, 1)}

        % Enter a descriptive full name (or title) for this research product. Note that this should be a suitable full name for all attached research product versions.
        fullName (1,1) string

        % Add all versions of this validation test.
        hasVersion (1,:) openminds.computation.ValidationTestVersion ...
            {mustBeListOfUniqueItems(hasVersion)}

        % Enter the internationalized resource identifier (IRI) to the homepage of this research product.
        homepage (1,1) string

        % Enter the preferred citation text for this research product. Leave blank if citation text can be extracted from the assigned digital identifier.
        howToCite (1,1) string

        % Add all acquisition techniques that were used to obtain the reference data for this validation test.
        referenceDataAcquisition (1,:) openminds.controlledterms.Technique ...
            {mustBeListOfUniqueItems(referenceDataAcquisition)}

        % Add the scope of this validation test.
        scope (1,:) openminds.controlledterms.ModelScope ...
            {mustBeSpecifiedLength(scope, 0, 1)}

        % Add the type of score calculated in this validation test.
        scoreType (1,:) openminds.controlledterms.DifferenceMeasure ...
            {mustBeSpecifiedLength(scoreType, 0, 1)}

        % Enter a short name (or alias) for this research product that could be used as a shortened display title (e.g., for web services with too little space to display the full name).
        shortName (1,1) string

        % Add all study targets of this validation test.
        studyTarget (1,:) openminds.internal.mixedtype.validationtest.StudyTarget ...
            {mustBeListOfUniqueItems(studyTarget)}
    end

    properties (Access = protected)
        Required = ["description", "developer", "fullName", "hasVersion", "shortName"]
    end

    properties (Constant, Hidden)
        X_TYPE = "https://openminds.om-i.org/types/ValidationTest"
    end

    properties (Constant, Hidden)
        LINKED_PROPERTIES = struct(...
            'custodian', ["openminds.core.actors.Consortium", "openminds.core.actors.Organization", "openminds.core.actors.Person"], ...
            'developer', ["openminds.core.actors.Consortium", "openminds.core.actors.Organization", "openminds.core.actors.Person"], ...
            'digitalIdentifier', "openminds.core.digitalidentifier.DOI", ...
            'hasVersion', "openminds.computation.ValidationTestVersion", ...
            'referenceDataAcquisition', "openminds.controlledterms.Technique", ...
            'scope', "openminds.controlledterms.ModelScope", ...
            'scoreType', "openminds.controlledterms.DifferenceMeasure", ...
            'studyTarget', ["openminds.controlledterms.AuditoryStimulusType", "openminds.controlledterms.BiologicalOrder", "openminds.controlledterms.BiologicalSex", "openminds.controlledterms.BreedingType", "openminds.controlledterms.CellCultureType", "openminds.controlledterms.CellType", "openminds.controlledterms.Disease", "openminds.controlledterms.DiseaseModel", "openminds.controlledterms.ElectricalStimulusType", "openminds.controlledterms.GeneticStrainType", "openminds.controlledterms.GustatoryStimulusType", "openminds.controlledterms.Handedness", "openminds.controlledterms.MolecularEntity", "openminds.controlledterms.OlfactoryStimulusType", "openminds.controlledterms.OpticalStimulusType", "openminds.controlledterms.Organ", "openminds.controlledterms.OrganismSubstance", "openminds.controlledterms.OrganismSystem", "openminds.controlledterms.Species", "openminds.controlledterms.SubcellularEntity", "openminds.controlledterms.TactileStimulusType", "openminds.controlledterms.TermSuggestion", "openminds.controlledterms.TissueSampleType", "openminds.controlledterms.UBERONParcellation", "openminds.controlledterms.VisualStimulusType", "openminds.sands.atlas.ParcellationEntity", "openminds.sands.atlas.ParcellationEntityVersion", "openminds.sands.nonatlas.CustomAnatomicalEntity"] ...
        )
        EMBEDDED_PROPERTIES = struct(...
        )
    end

    methods
        function obj = ValidationTest(structInstance, propValues)
            arguments
                structInstance (1,:) {mustBeA(structInstance, 'struct')} = struct.empty
                propValues.?openminds.computation.ValidationTest
                propValues.id (1,1) string
            end
            propValues = namedargs2cell(propValues);
            obj@openminds.abstract.Schema(structInstance, propValues{:})
        end
    end

    methods (Access = protected)
        function str = getDisplayLabel(obj)
            str = obj.fullName;
        end
    end
end
