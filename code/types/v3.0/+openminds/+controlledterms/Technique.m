classdef Technique < openminds.abstract.ControlledTerm
%Technique - Structured information on the technique.
%
%   PROPERTIES:
%
%   definition                  : (1,1) string
%                                 Enter one sentence for defining this term.
%
%   description                 : (1,1) string
%                                 Enter a short text describing this term.
%
%   interlexIdentifier          : (1,1) string
%                                 Enter the internationalized resource identifier (IRI) pointing to the integrated ontology entry in the InterLex project.
%
%   knowledgeSpaceLink          : (1,1) string
%                                 Enter the internationalized resource identifier (IRI) pointing to the wiki page of the corresponding term in the KnowledgeSpace.
%
%   name                        : (1,1) string
%                                 Controlled term originating from a defined terminology.
%
%   preferredOntologyIdentifier : (1,1) string
%                                 Enter the internationalized resource identifier (IRI) pointing to the preferred ontological term.
%
%   synonym                     : (1,:) string
%                                 Enter one or several synonyms (including abbreviations) for this controlled term.

%   This class was auto-generated by the openMINDS pipeline

    properties (Constant, Hidden)
        X_TYPE = "https://openminds.ebrains.eu/controlledTerms/Technique"
    end

    properties (Constant, Hidden)
        CONTROLLED_INSTANCES = [ ...
            "3DComputerGraphicModeling", ...
            "3DPolarizedLightImaging", ...
            "3DScanning", ...
            "CLARITY_TDE", ...
            "DABStaining", ...
            "DAPiStaining", ...
            "DNAMethylationAnalysis", ...
            "DNASequencing", ...
            "GolgiStaining", ...
            "HEStaining", ...
            "HPCSimulation", ...
            "HoechstStaining", ...
            "NisslStaining", ...
            "RNASequencing", ...
            "RamanSpectroscopy", ...
            "SDSDigestedFreezeFractureReplicaLabeling", ...
            "SWITCHImmunohistochemistry", ...
            "TDEClearing", ...
            "TimmsStaining", ...
            "activityModulationTechnique", ...
            "anaesthesiaAdministration", ...
            "anaesthesiaMonitoring", ...
            "anaesthesiaTechnique", ...
            "angiography", ...
            "anterogradeTracing", ...
            "autoradiography", ...
            "avidinBiotinComplexStaining", ...
            "beta-galactosidaseStaining", ...
            "biocytinStaining", ...
            "bloodSampling", ...
            "brightfieldMicroscopy", ...
            "calciumImaging", ...
            "callosotomy", ...
            "cellAttachedPatchClamp", ...
            "coherentAntiStokesRamanSpectroscopy", ...
            "coherentStokesRamanSpectroscopy", ...
            "computerTomography", ...
            "confocalMicroscopy", ...
            "contrastAgentAdministration", ...
            "contrastEnhancement", ...
            "cortico-corticalEvokedPotentialMapping", ...
            "craniotomy", ...
            "cryosectioning", ...
            "currentClamp", ...
            "darkfieldMicroscopy", ...
            "differentialInterferenceContrastMicroscopy", ...
            "diffusionFixationTechnique", ...
            "diffusionTensorImaging", ...
            "diffusionWeightedImaging", ...
            "dualViewInvertedSelectivePlaneIlluminationMicroscopy", ...
            "electrocardiography", ...
            "electrocorticography", ...
            "electroencephalography", ...
            "electromyography", ...
            "electronMicroscopy", ...
            "electronTomography", ...
            "electrooculography", ...
            "electroporation", ...
            "enzymeLinkedImmunosorbentAssay", ...
            "epidermalElectrophysiologyTechnique", ...
            "epiduralElectrocorticography", ...
            "epifluorescentMicroscopy", ...
            "extracellularElectrophysiology", ...
            "eyeMovementTracking", ...
            "fixationTechnique", ...
            "fluorescenceMicroscopy", ...
            "focusedIonBeamScanningElectronMicroscopy", ...
            "functionalMagneticResonanceImaging", ...
            "geneExpressionMeasurement", ...
            "geneKnockin", ...
            "geneKnockout", ...
            "genomeWideAssociationStudy", ...
            "heavyMetalNegativeStaining", ...
            "high-resolutionScanning", ...
            "high-speedVideoRecording", ...
            "highDensityElectroencephalography", ...
            "highFieldFunctionalMagneticResonanceImaging", ...
            "highFieldMagneticResonanceImaging", ...
            "highThroughputScanning", ...
            "histochemistry", ...
            "immunohistochemistry", ...
            "immunoprecipitation", ...
            "implantSurgery", ...
            "inSituHybridisation", ...
            "infraredDifferentialInterferenceContrastVideoMicroscopy", ...
            "injection", ...
            "intracellularElectrophysiology", ...
            "intracellularInjection", ...
            "intracranialElectroencephalography", ...
            "intraperitonealInjection", ...
            "intravenousInjection", ...
            "iontophoresis", ...
            "iontophoreticMicroinjection", ...
            "lightMicroscopy", ...
            "lightSheetFluorescenceMicroscopy", ...
            "magneticResonanceImaging", ...
            "magneticResonanceSpectroscopy", ...
            "magnetizationTransferImaging", ...
            "magnetoencephalography", ...
            "massSpectrometry", ...
            "microComputedTomography", ...
            "microtomeSectioning", ...
            "motionCapture", ...
            "multi-compartmentModeling", ...
            "multiElectrodeExtracellularElectrophysiology", ...
            "multiPhotonFluorescenceMicroscopy", ...
            "multipleWholeCellPatchClamp", ...
            "myelinStaining", ...
            "myelinWaterImaging", ...
            "nearInfraredSpectroscopy", ...
            "neuromorphicSimulation", ...
            "nonlinearOpticalMicroscopy", ...
            "nucleicAcidExtraction", ...
            "opticalCoherenceTomography", ...
            "opticalCoherenceTomographyAngiography", ...
            "optogeneticInhibition", ...
            "oralAdministration", ...
            "organExtraction", ...
            "patchClamp", ...
            "perfusionFixationTechnique", ...
            "perfusionTechnique", ...
            "perturbationalComplexityIndexMeasurement", ...
            "phaseContrastMicroscopy", ...
            "phaseContrastXRayComputedTomography", ...
            "phaseContrastXRayImaging", ...
            "photoactivation", ...
            "photoinactivation", ...
            "photoplethysmography", ...
            "polarizedLightMicroscopy", ...
            "populationReceptiveFieldMapping", ...
            "positronEmissionTomography", ...
            "pressureInjection", ...
            "primaryAntibodyStaining", ...
            "pseudoContinuousArterialSpinLabeling", ...
            "psychologicalTesting", ...
            "pupillometry", ...
            "quantification", ...
            "quantitativeMagneticResonanceImaging", ...
            "quantitativeSusceptibilityMapping", ...
            "receptiveFieldMapping", ...
            "reporterGeneBasedExpressionMeasurement", ...
            "reporterProteinBasedExpressionMeasurement", ...
            "retinotopicMapping", ...
            "retrogradeTracing", ...
            "rule-basedModeling", ...
            "scanningElectronMicroscopy", ...
            "scatteredLightImaging", ...
            "secondaryAntibodyStaining", ...
            "serialBlockFaceScanningElectronMicroscopy", ...
            "serialSectionTransmissionElectronMicroscopy", ...
            "sharpElectrodeIntracellularElectrophysiology", ...
            "silverStaining", ...
            "simulation", ...
            "singleCellRNASequencing", ...
            "singleElectrodeExtracellularElectrophysiology", ...
            "singleElectrodeJuxtacellularElectrophysiology", ...
            "singleGeneAnalysis", ...
            "singleNucleotidePolymorphismDetection", ...
            "sodiumMRI", ...
            "sonography", ...
            "standardization", ...
            "stereoelectroencephalography", ...
            "stereology", ...
            "stereotacticSurgery", ...
            "structuralMagneticResonanceImaging", ...
            "structuralNeuroimaging", ...
            "subcutaneousInjection", ...
            "subduralElectrocorticography", ...
            "superResolutionMicroscopy", ...
            "susceptibilityWeightedImaging", ...
            "tetrodeExtracellularElectrophysiology", ...
            "time-of-flightMagneticResonanceAngiography", ...
            "tissueClearing", ...
            "tractTracing", ...
            "transcardialPerfusionFixationTechnique", ...
            "transcardialPerfusionTechnique", ...
            "transmissionElectronMicroscopy", ...
            "twoPhotonFluorescenceMicroscopy", ...
            "ultraHighFieldFunctionalMagneticResonanceImaging", ...
            "ultraHighFieldMagneticResonanceImaging", ...
            "ultraHighFieldMagneticResonanceSpectroscopy", ...
            "vibratomeSectioning", ...
            "video-oculography", ...
            "videoTracking", ...
            "virus-mediatedTransfection", ...
            "voltageClamp", ...
            "voltageSensitiveDyeImaging", ...
            "weightedCorrelationNetworkAnalysis", ...
            "wholeCellPatchClamp", ...
            "wholeGenomeSequencing", ...
            "widefieldFluorescenceMicroscopy" ...
        ]
    end

    methods
        function obj = Technique(varargin)
            obj@openminds.abstract.ControlledTerm(varargin{:})
        end
    end

    methods (Static)
        function instances = listInstances()
            instances = openminds.controlledterms.Technique.CONTROLLED_INSTANCES';
        end
    end
end
