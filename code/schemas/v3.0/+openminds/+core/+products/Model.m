classdef Model < openminds.abstract.Schema
%Model - Structured information on a computational model (concept level).
%
%   PROPERTIES:
%
%   abstractionLevel  : (1,1) <a href="matlab:help openminds.controlledterms.ModelAbstractionLevel" style="font-weight:bold">ModelAbstractionLevel</a>
%                       Add the abstraction level of this computational model.
%
%   custodian         : (1,:) <a href="matlab:help openminds.core.actors.Consortium" style="font-weight:bold">Consortium</a>, <a href="matlab:help openminds.core.actors.Organization" style="font-weight:bold">Organization</a>, <a href="matlab:help openminds.core.actors.Person" style="font-weight:bold">Person</a>
%                       Add all parties that fulfill the role of a custodian for this research product (e.g., a research group leader or principle investigator). Custodians are typically the main contact in case of misconduct, obtain permission from the contributors to publish personal information, and maintain the content and quality of the data, metadata, and/or code of the research product. Unless specified differently, this custodian will be responsible for all attached research product versions.
%
%   description       : (1,1) string
%                       Enter a description (or abstract) of this research product. Note that this should be a suitable description for all attached research product versions.
%
%   developer         : (1,:) <a href="matlab:help openminds.core.actors.Consortium" style="font-weight:bold">Consortium</a>, <a href="matlab:help openminds.core.actors.Organization" style="font-weight:bold">Organization</a>, <a href="matlab:help openminds.core.actors.Person" style="font-weight:bold">Person</a>
%                       Add all parties that developed this computational model.
%
%   digitalIdentifier : (1,1) <a href="matlab:help openminds.core.digitalidentifier.DOI" style="font-weight:bold">DOI</a>, <a href="matlab:help openminds.core.digitalidentifier.SWHID" style="font-weight:bold">SWHID</a>
%                       Add the globally unique and persistent digital identifier of this research product. Note that this digital identifier will be used to reference all attached research product versions.
%
%   fullName          : (1,1) string
%                       Enter a descriptive full name (or title) for this research product. Note that this should be a suitable full name for all attached research product versions.
%
%   hasVersion        : (1,:) <a href="matlab:help openminds.core.products.ModelVersion" style="font-weight:bold">ModelVersion</a>
%                       Add all versions of this computational model.
%
%   homepage          : (1,1) string
%                       Enter the internationalized resource identifier (IRI) to the homepage of this research product.
%
%   howToCite         : (1,1) string
%                       Enter the preferred citation text for this research product. Leave blank if citation text can be extracted from the assigned digital identifier.
%
%   scope             : (1,1) <a href="matlab:help openminds.controlledterms.ModelScope" style="font-weight:bold">ModelScope</a>
%                       Add the scope of this computational model.
%
%   shortName         : (1,1) string
%                       Enter a short name (or alias) for this research product that could be used as a shortened display title (e.g., for web services with too little space to display the full name).
%
%   studyTarget       : (1,:) <a href="matlab:help openminds.controlledterms.AuditoryStimulusType" style="font-weight:bold">AuditoryStimulusType</a>, <a href="matlab:help openminds.controlledterms.BiologicalOrder" style="font-weight:bold">BiologicalOrder</a>, <a href="matlab:help openminds.controlledterms.BiologicalSex" style="font-weight:bold">BiologicalSex</a>, <a href="matlab:help openminds.controlledterms.BreedingType" style="font-weight:bold">BreedingType</a>, <a href="matlab:help openminds.controlledterms.CellCultureType" style="font-weight:bold">CellCultureType</a>, <a href="matlab:help openminds.controlledterms.CellType" style="font-weight:bold">CellType</a>, <a href="matlab:help openminds.controlledterms.Disease" style="font-weight:bold">Disease</a>, <a href="matlab:help openminds.controlledterms.DiseaseModel" style="font-weight:bold">DiseaseModel</a>, <a href="matlab:help openminds.controlledterms.ElectricalStimulusType" style="font-weight:bold">ElectricalStimulusType</a>, <a href="matlab:help openminds.controlledterms.GeneticStrainType" style="font-weight:bold">GeneticStrainType</a>, <a href="matlab:help openminds.controlledterms.GustatoryStimulusType" style="font-weight:bold">GustatoryStimulusType</a>, <a href="matlab:help openminds.controlledterms.Handedness" style="font-weight:bold">Handedness</a>, <a href="matlab:help openminds.controlledterms.MolecularEntity" style="font-weight:bold">MolecularEntity</a>, <a href="matlab:help openminds.controlledterms.OlfactoryStimulusType" style="font-weight:bold">OlfactoryStimulusType</a>, <a href="matlab:help openminds.controlledterms.OpticalStimulusType" style="font-weight:bold">OpticalStimulusType</a>, <a href="matlab:help openminds.controlledterms.Organ" style="font-weight:bold">Organ</a>, <a href="matlab:help openminds.controlledterms.OrganismSubstance" style="font-weight:bold">OrganismSubstance</a>, <a href="matlab:help openminds.controlledterms.OrganismSystem" style="font-weight:bold">OrganismSystem</a>, <a href="matlab:help openminds.controlledterms.Species" style="font-weight:bold">Species</a>, <a href="matlab:help openminds.controlledterms.SubcellularEntity" style="font-weight:bold">SubcellularEntity</a>, <a href="matlab:help openminds.controlledterms.TactileStimulusType" style="font-weight:bold">TactileStimulusType</a>, <a href="matlab:help openminds.controlledterms.TermSuggestion" style="font-weight:bold">TermSuggestion</a>, <a href="matlab:help openminds.controlledterms.UBERONParcellation" style="font-weight:bold">UBERONParcellation</a>, <a href="matlab:help openminds.controlledterms.VisualStimulusType" style="font-weight:bold">VisualStimulusType</a>, <a href="matlab:help openminds.sands.atlas.ParcellationEntity" style="font-weight:bold">ParcellationEntity</a>, <a href="matlab:help openminds.sands.atlas.ParcellationEntityVersion" style="font-weight:bold">ParcellationEntityVersion</a>, <a href="matlab:help openminds.sands.nonatlas.CustomAnatomicalEntity" style="font-weight:bold">CustomAnatomicalEntity</a>
%                       Add all study targets of this computational model.

%   This class was auto-generated by the openMINDS pipeline

    properties
        % Add the abstraction level of this computational model.
        abstractionLevel (1,:) openminds.controlledterms.ModelAbstractionLevel ...
            {mustBeSpecifiedLength(abstractionLevel, 0, 1)}

        % Add all parties that fulfill the role of a custodian for this research product (e.g., a research group leader or principle investigator). Custodians are typically the main contact in case of misconduct, obtain permission from the contributors to publish personal information, and maintain the content and quality of the data, metadata, and/or code of the research product. Unless specified differently, this custodian will be responsible for all attached research product versions.
        custodian (1,:) openminds.internal.mixedtype.model.Custodian ...
            {mustBeListOfUniqueItems(custodian)}

        % Enter a description (or abstract) of this research product. Note that this should be a suitable description for all attached research product versions.
        description (1,1) string

        % Add all parties that developed this computational model.
        developer (1,:) openminds.internal.mixedtype.model.Developer ...
            {mustBeListOfUniqueItems(developer)}

        % Add the globally unique and persistent digital identifier of this research product. Note that this digital identifier will be used to reference all attached research product versions.
        digitalIdentifier (1,:) openminds.internal.mixedtype.model.DigitalIdentifier ...
            {mustBeSpecifiedLength(digitalIdentifier, 0, 1)}

        % Enter a descriptive full name (or title) for this research product. Note that this should be a suitable full name for all attached research product versions.
        fullName (1,1) string

        % Add all versions of this computational model.
        hasVersion (1,:) openminds.core.products.ModelVersion ...
            {mustBeListOfUniqueItems(hasVersion)}

        % Enter the internationalized resource identifier (IRI) to the homepage of this research product.
        homepage (1,1) string

        % Enter the preferred citation text for this research product. Leave blank if citation text can be extracted from the assigned digital identifier.
        howToCite (1,1) string

        % Add the scope of this computational model.
        scope (1,:) openminds.controlledterms.ModelScope ...
            {mustBeSpecifiedLength(scope, 0, 1)}

        % Enter a short name (or alias) for this research product that could be used as a shortened display title (e.g., for web services with too little space to display the full name).
        shortName (1,1) string

        % Add all study targets of this computational model.
        studyTarget (1,:) openminds.internal.mixedtype.model.StudyTarget ...
            {mustBeListOfUniqueItems(studyTarget)}
    end

    properties (Access = protected)
        Required = ["abstractionLevel", "description", "developer", "fullName", "hasVersion", "scope", "shortName", "studyTarget"]
    end

    properties (Constant, Hidden)
        X_TYPE = "https://openminds.ebrains.eu/core/Model"
    end

    properties (Constant, Hidden)
        LINKED_PROPERTIES = struct(...
            'abstractionLevel', "openminds.controlledterms.ModelAbstractionLevel", ...
            'custodian', ["openminds.core.actors.Consortium", "openminds.core.actors.Organization", "openminds.core.actors.Person"], ...
            'developer', ["openminds.core.actors.Consortium", "openminds.core.actors.Organization", "openminds.core.actors.Person"], ...
            'digitalIdentifier', ["openminds.core.digitalidentifier.DOI", "openminds.core.digitalidentifier.SWHID"], ...
            'hasVersion', "openminds.core.products.ModelVersion", ...
            'scope', "openminds.controlledterms.ModelScope", ...
            'studyTarget', ["openminds.controlledterms.AuditoryStimulusType", "openminds.controlledterms.BiologicalOrder", "openminds.controlledterms.BiologicalSex", "openminds.controlledterms.BreedingType", "openminds.controlledterms.CellCultureType", "openminds.controlledterms.CellType", "openminds.controlledterms.Disease", "openminds.controlledterms.DiseaseModel", "openminds.controlledterms.ElectricalStimulusType", "openminds.controlledterms.GeneticStrainType", "openminds.controlledterms.GustatoryStimulusType", "openminds.controlledterms.Handedness", "openminds.controlledterms.MolecularEntity", "openminds.controlledterms.OlfactoryStimulusType", "openminds.controlledterms.OpticalStimulusType", "openminds.controlledterms.Organ", "openminds.controlledterms.OrganismSubstance", "openminds.controlledterms.OrganismSystem", "openminds.controlledterms.Species", "openminds.controlledterms.SubcellularEntity", "openminds.controlledterms.TactileStimulusType", "openminds.controlledterms.TermSuggestion", "openminds.controlledterms.UBERONParcellation", "openminds.controlledterms.VisualStimulusType", "openminds.sands.atlas.ParcellationEntity", "openminds.sands.atlas.ParcellationEntityVersion", "openminds.sands.nonatlas.CustomAnatomicalEntity"] ...
        )
        EMBEDDED_PROPERTIES = struct(...
        )
    end

    methods
        function obj = Model(varargin)
            obj@openminds.abstract.Schema(varargin{:})
        end
    end

    methods (Access = protected)
        function str = getDisplayLabel(obj)
            str = sprintf('%s', obj.fullName);
        end
    end
end