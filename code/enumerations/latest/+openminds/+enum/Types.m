classdef Types < openminds.base.TypesEnumerationBase
    enumeration
        None('None')
        AtlasAnnotation("openminds.sands.atlas.AtlasAnnotation")
        BrainAtlas("openminds.sands.atlas.BrainAtlas")
        BrainAtlasVersion("openminds.sands.atlas.BrainAtlasVersion")
        CommonCoordinateSpace("openminds.sands.atlas.CommonCoordinateSpace")
        CommonCoordinateSpaceVersion("openminds.sands.atlas.CommonCoordinateSpaceVersion")
        ParcellationEntity("openminds.sands.atlas.ParcellationEntity")
        ParcellationEntityVersion("openminds.sands.atlas.ParcellationEntityVersion")
        ParcellationTerminology("openminds.sands.atlas.ParcellationTerminology")
        ParcellationTerminologyVersion("openminds.sands.atlas.ParcellationTerminologyVersion")
        Circle("openminds.sands.mathematicalshapes.Circle")
        Ellipse("openminds.sands.mathematicalshapes.Ellipse")
        Rectangle("openminds.sands.mathematicalshapes.Rectangle")
        AnatomicalTargetPosition("openminds.sands.miscellaneous.AnatomicalTargetPosition")
        CoordinatePoint("openminds.sands.miscellaneous.CoordinatePoint")
        QualitativeRelationAssessment("openminds.sands.miscellaneous.QualitativeRelationAssessment")
        QuantitativeRelationAssessment("openminds.sands.miscellaneous.QuantitativeRelationAssessment")
        SingleColor("openminds.sands.miscellaneous.SingleColor")
        ViewerSpecification("openminds.sands.miscellaneous.ViewerSpecification")
        CustomAnatomicalEntity("openminds.sands.nonatlas.CustomAnatomicalEntity")
        CustomAnnotation("openminds.sands.nonatlas.CustomAnnotation")
        CustomCoordinateSpace("openminds.sands.nonatlas.CustomCoordinateSpace")
        AmountOfChemical("openminds.chemicals.AmountOfChemical")
        ChemicalMixture("openminds.chemicals.ChemicalMixture")
        ChemicalSubstance("openminds.chemicals.ChemicalSubstance")
        ProductSource("openminds.chemicals.ProductSource")
        DataAnalysis("openminds.computation.DataAnalysis")
        DataCopy("openminds.computation.DataCopy")
        Environment("openminds.computation.Environment")
        GenericComputation("openminds.computation.GenericComputation")
        HardwareSystem("openminds.computation.HardwareSystem")
        LaunchConfiguration("openminds.computation.LaunchConfiguration")
        LocalFile("openminds.computation.LocalFile")
        ModelValidation("openminds.computation.ModelValidation")
        Optimization("openminds.computation.Optimization")
        Simulation("openminds.computation.Simulation")
        SoftwareAgent("openminds.computation.SoftwareAgent")
        ValidationTest("openminds.computation.ValidationTest")
        ValidationTestVersion("openminds.computation.ValidationTestVersion")
        Visualization("openminds.computation.Visualization")
        WorkflowExecution("openminds.computation.WorkflowExecution")
        WorkflowRecipe("openminds.computation.WorkflowRecipe")
        WorkflowRecipeVersion("openminds.computation.WorkflowRecipeVersion")
        MRAcquisitionType("openminds.controlledterms.MRAcquisitionType")
        MRIPulseSequence("openminds.controlledterms.MRIPulseSequence")
        MRIWeighting("openminds.controlledterms.MRIWeighting")
        UBERONParcellation("openminds.controlledterms.UBERONParcellation")
        ActionStatusType("openminds.controlledterms.ActionStatusType")
        AgeCategory("openminds.controlledterms.AgeCategory")
        AnalysisTechnique("openminds.controlledterms.AnalysisTechnique")
        AnatomicalAxesOrientation("openminds.controlledterms.AnatomicalAxesOrientation")
        AnatomicalIdentificationType("openminds.controlledterms.AnatomicalIdentificationType")
        AnatomicalPlane("openminds.controlledterms.AnatomicalPlane")
        AnnotationCriteriaType("openminds.controlledterms.AnnotationCriteriaType")
        AnnotationType("openminds.controlledterms.AnnotationType")
        AtlasType("openminds.controlledterms.AtlasType")
        AuditoryStimulusType("openminds.controlledterms.AuditoryStimulusType")
        BiologicalOrder("openminds.controlledterms.BiologicalOrder")
        BiologicalProcess("openminds.controlledterms.BiologicalProcess")
        BiologicalSex("openminds.controlledterms.BiologicalSex")
        BreedingType("openminds.controlledterms.BreedingType")
        CellCultureType("openminds.controlledterms.CellCultureType")
        CellType("openminds.controlledterms.CellType")
        ChemicalMixtureType("openminds.controlledterms.ChemicalMixtureType")
        Colormap("openminds.controlledterms.Colormap")
        ContributionType("openminds.controlledterms.ContributionType")
        CranialWindowConstructionType("openminds.controlledterms.CranialWindowConstructionType")
        CranialWindowReinforcementType("openminds.controlledterms.CranialWindowReinforcementType")
        CriteriaQualityType("openminds.controlledterms.CriteriaQualityType")
        DataType("openminds.controlledterms.DataType")
        DeviceType("openminds.controlledterms.DeviceType")
        DifferenceMeasure("openminds.controlledterms.DifferenceMeasure")
        Disease("openminds.controlledterms.Disease")
        DiseaseModel("openminds.controlledterms.DiseaseModel")
        EducationalLevel("openminds.controlledterms.EducationalLevel")
        ElectricalStimulusType("openminds.controlledterms.ElectricalStimulusType")
        EthicsAssessment("openminds.controlledterms.EthicsAssessment")
        ExperimentalApproach("openminds.controlledterms.ExperimentalApproach")
        FileBundleGrouping("openminds.controlledterms.FileBundleGrouping")
        FileRepositoryType("openminds.controlledterms.FileRepositoryType")
        FileUsageRole("openminds.controlledterms.FileUsageRole")
        GeneticStrainType("openminds.controlledterms.GeneticStrainType")
        GustatoryStimulusType("openminds.controlledterms.GustatoryStimulusType")
        Handedness("openminds.controlledterms.Handedness")
        Language("openminds.controlledterms.Language")
        Laterality("openminds.controlledterms.Laterality")
        LearningResourceType("openminds.controlledterms.LearningResourceType")
        MeasuredQuantity("openminds.controlledterms.MeasuredQuantity")
        MeasuredSignalType("openminds.controlledterms.MeasuredSignalType")
        MetaDataModelType("openminds.controlledterms.MetaDataModelType")
        ModelAbstractionLevel("openminds.controlledterms.ModelAbstractionLevel")
        ModelScope("openminds.controlledterms.ModelScope")
        MolecularEntity("openminds.controlledterms.MolecularEntity")
        OlfactoryStimulusType("openminds.controlledterms.OlfactoryStimulusType")
        OperatingDevice("openminds.controlledterms.OperatingDevice")
        OperatingSystem("openminds.controlledterms.OperatingSystem")
        OpticalStimulusType("openminds.controlledterms.OpticalStimulusType")
        Organ("openminds.controlledterms.Organ")
        OrganismSubstance("openminds.controlledterms.OrganismSubstance")
        OrganismSystem("openminds.controlledterms.OrganismSystem")
        PatchClampVariation("openminds.controlledterms.PatchClampVariation")
        PreparationType("openminds.controlledterms.PreparationType")
        ProductAccessibility("openminds.controlledterms.ProductAccessibility")
        ProgrammingLanguage("openminds.controlledterms.ProgrammingLanguage")
        QualitativeOverlap("openminds.controlledterms.QualitativeOverlap")
        SemanticDataType("openminds.controlledterms.SemanticDataType")
        Service("openminds.controlledterms.Service")
        SetupType("openminds.controlledterms.SetupType")
        SoftwareApplicationCategory("openminds.controlledterms.SoftwareApplicationCategory")
        SoftwareFeature("openminds.controlledterms.SoftwareFeature")
        Species("openminds.controlledterms.Species")
        StimulationApproach("openminds.controlledterms.StimulationApproach")
        StimulationTechnique("openminds.controlledterms.StimulationTechnique")
        SubcellularEntity("openminds.controlledterms.SubcellularEntity")
        SubjectAttribute("openminds.controlledterms.SubjectAttribute")
        TactileStimulusType("openminds.controlledterms.TactileStimulusType")
        Technique("openminds.controlledterms.Technique")
        TermSuggestion("openminds.controlledterms.TermSuggestion")
        Terminology("openminds.controlledterms.Terminology")
        TissueSampleAttribute("openminds.controlledterms.TissueSampleAttribute")
        TissueSampleType("openminds.controlledterms.TissueSampleType")
        TypeOfUncertainty("openminds.controlledterms.TypeOfUncertainty")
        UnitOfMeasurement("openminds.controlledterms.UnitOfMeasurement")
        VisualStimulusType("openminds.controlledterms.VisualStimulusType")
        AccountInformation("openminds.core.actors.AccountInformation")
        Affiliation("openminds.core.actors.Affiliation")
        Consortium("openminds.core.actors.Consortium")
        ContactInformation("openminds.core.actors.ContactInformation")
        Contribution("openminds.core.actors.Contribution")
        Organization("openminds.core.actors.Organization")
        Person("openminds.core.actors.Person")
        ContentType("openminds.core.data.ContentType")
        ContentTypePattern("openminds.core.data.ContentTypePattern")
        Copyright("openminds.core.data.Copyright")
        File("openminds.core.data.File")
        FileArchive("openminds.core.data.FileArchive")
        FileBundle("openminds.core.data.FileBundle")
        FilePathPattern("openminds.core.data.FilePathPattern")
        FileRepository("openminds.core.data.FileRepository")
        FileRepositoryStructure("openminds.core.data.FileRepositoryStructure")
        Hash("openminds.core.data.Hash")
        License("openminds.core.data.License")
        Measurement("openminds.core.data.Measurement")
        ServiceLink("openminds.core.data.ServiceLink")
        DOI("openminds.core.digitalidentifier.DOI")
        GRIDID("openminds.core.digitalidentifier.GRIDID")
        HANDLE("openminds.core.digitalidentifier.HANDLE")
        ISBN("openminds.core.digitalidentifier.ISBN")
        ISSN("openminds.core.digitalidentifier.ISSN")
        IdentifiersDotOrgID("openminds.core.digitalidentifier.IdentifiersDotOrgID")
        ORCID("openminds.core.digitalidentifier.ORCID")
        RORID("openminds.core.digitalidentifier.RORID")
        RRID("openminds.core.digitalidentifier.RRID")
        SWHID("openminds.core.digitalidentifier.SWHID")
        StockNumber("openminds.core.digitalidentifier.StockNumber")
        Comment("openminds.core.miscellaneous.Comment")
        Funding("openminds.core.miscellaneous.Funding")
        QuantitativeValue("openminds.core.miscellaneous.QuantitativeValue")
        QuantitativeValueArray("openminds.core.miscellaneous.QuantitativeValueArray")
        QuantitativeValueRange("openminds.core.miscellaneous.QuantitativeValueRange")
        ResearchProductGroup("openminds.core.miscellaneous.ResearchProductGroup")
        WebResource("openminds.core.miscellaneous.WebResource")
        Dataset("openminds.core.products.Dataset")
        DatasetVersion("openminds.core.products.DatasetVersion")
        MetaDataModel("openminds.core.products.MetaDataModel")
        MetaDataModelVersion("openminds.core.products.MetaDataModelVersion")
        Model("openminds.core.products.Model")
        ModelVersion("openminds.core.products.ModelVersion")
        Project("openminds.core.products.Project")
        Setup("openminds.core.products.Setup")
        Software("openminds.core.products.Software")
        SoftwareVersion("openminds.core.products.SoftwareVersion")
        WebService("openminds.core.products.WebService")
        WebServiceVersion("openminds.core.products.WebServiceVersion")
        BehavioralProtocol("openminds.core.research.BehavioralProtocol")
        Configuration("openminds.core.research.Configuration")
        CustomPropertySet("openminds.core.research.CustomPropertySet")
        NumericalProperty("openminds.core.research.NumericalProperty")
        PropertyValueList("openminds.core.research.PropertyValueList")
        Protocol("openminds.core.research.Protocol")
        ProtocolExecution("openminds.core.research.ProtocolExecution")
        Strain("openminds.core.research.Strain")
        StringProperty("openminds.core.research.StringProperty")
        Subject("openminds.core.research.Subject")
        SubjectGroup("openminds.core.research.SubjectGroup")
        SubjectGroupState("openminds.core.research.SubjectGroupState")
        SubjectState("openminds.core.research.SubjectState")
        TissueSample("openminds.core.research.TissueSample")
        TissueSampleCollection("openminds.core.research.TissueSampleCollection")
        TissueSampleCollectionState("openminds.core.research.TissueSampleCollectionState")
        TissueSampleState("openminds.core.research.TissueSampleState")
        CellPatching("openminds.ephys.activity.CellPatching")
        ElectrodePlacement("openminds.ephys.activity.ElectrodePlacement")
        RecordingActivity("openminds.ephys.activity.RecordingActivity")
        Electrode("openminds.ephys.device.Electrode")
        ElectrodeArray("openminds.ephys.device.ElectrodeArray")
        ElectrodeArrayUsage("openminds.ephys.device.ElectrodeArrayUsage")
        ElectrodeUsage("openminds.ephys.device.ElectrodeUsage")
        Pipette("openminds.ephys.device.Pipette")
        PipetteUsage("openminds.ephys.device.PipetteUsage")
        Channel("openminds.ephys.entity.Channel")
        Recording("openminds.ephys.entity.Recording")
        Book("openminds.publications.Book")
        Chapter("openminds.publications.Chapter")
        LearningResource("openminds.publications.LearningResource")
        LivePaper("openminds.publications.LivePaper")
        LivePaperResourceItem("openminds.publications.LivePaperResourceItem")
        LivePaperSection("openminds.publications.LivePaperSection")
        LivePaperVersion("openminds.publications.LivePaperVersion")
        Periodical("openminds.publications.Periodical")
        PublicationIssue("openminds.publications.PublicationIssue")
        PublicationVolume("openminds.publications.PublicationVolume")
        ScholarlyArticle("openminds.publications.ScholarlyArticle")
        CranialWindowPreparation("openminds.specimenprep.activity.CranialWindowPreparation")
        TissueCulturePreparation("openminds.specimenprep.activity.TissueCulturePreparation")
        TissueSampleSlicing("openminds.specimenprep.activity.TissueSampleSlicing")
        SlicingDevice("openminds.specimenprep.device.SlicingDevice")
        SlicingDeviceUsage("openminds.specimenprep.device.SlicingDeviceUsage")
        StimulationActivity("openminds.stimulation.activity.StimulationActivity")
        EphysStimulus("openminds.stimulation.stimulus.EphysStimulus")
    end
end