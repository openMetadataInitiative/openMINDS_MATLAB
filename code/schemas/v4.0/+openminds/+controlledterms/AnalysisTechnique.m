classdef AnalysisTechnique < openminds.abstract.ControlledTerm
%AnalysisTechnique - No description available.
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
        X_TYPE = "https://openminds.om-i.org/types/AnalysisTechnique"
    end

    properties (Constant, Hidden)
        CONTROLLED_INSTANCES = [ ...
            "4PointsCongruentSetsAlignment", ...
            "GrubbsTest", ...
            "HilbertTransform", ...
            "ICABasedDenoisingTechnique", ...
            "Isomap", ...
            "MannWhitneyUTest", ...
            "ShapiroWilkTest", ...
            "SpearmansRankOrderCorrelation", ...
            "WardClustering", ...
            "activationLikelihoodEstimation", ...
            "affineImageRegistration", ...
            "affineTransformation", ...
            "anatomicalDelineationTechnique", ...
            "averageLinkageClustering", ...
            "biasFieldCorrection", ...
            "bootstrapAggregating", ...
            "bootstrapping", ...
            "boundaryBasedRegistration", ...
            "clusterAnalysis", ...
            "combinedVolumeSurfaceRegistration", ...
            "communicationProfiling", ...
            "conjunctionAnalysis", ...
            "connected-componentAnalysis", ...
            "connectivityBasedParcellationTechnique", ...
            "convolution", ...
            "correlationAnalysis", ...
            "covarianceAnalysis", ...
            "currentSourceDensityAnalysis", ...
            "cytoarchitectonicMapping", ...
            "deepLearningBasedAnalysis", ...
            "densityMeasurement", ...
            "dictionaryLearning", ...
            "diffeomorphicRegistration", ...
            "dynamicCausalModeling", ...
            "eyeMovementAnalysis", ...
            "generalLinearModelAnalysis", ...
            "geneticCorrelationAnalysis", ...
            "geneticRiskScoreAnalysis", ...
            "globalSignalRegression", ...
            "hierarchicalAgglomerativeClustering", ...
            "hierarchicalClustering", ...
            "hierarchicalDivisiveClustering", ...
            "imageDistortionCorrection", ...
            "imageRegistration", ...
            "independentComponentAnalysis", ...
            "interSubjectAnalysis", ...
            "interpolation", ...
            "intraSubjectAnalysis", ...
            "isometricMapping", ...
            "k-meansClustering", ...
            "linearImageRegistration", ...
            "linearRegression", ...
            "linearTransformation", ...
            "literatureMining", ...
            "macromolecularTissueVolumeImageProcessing", ...
            "magnetizationTransferRatioImageProcessing", ...
            "magnetizationTransferSaturationImageProcessing", ...
            "manifoldLearning", ...
            "massUnivariateAnalysis", ...
            "maximumLikelihoodEstimation", ...
            "maximumProbabilityProjection", ...
            "metaAnalysis", ...
            "metaAnalyticConnectivityModeling", ...
            "metadataParsing", ...
            "modelBasedStimulationArtifactCorrection", ...
            "morphometry", ...
            "motionAnalysis", ...
            "motionCorrection", ...
            "multi-scaleIndividualComponentClustering", ...
            "multiVoxelPatternAnalysis", ...
            "multipleLinearRegression", ...
            "multivariateAnalysis", ...
            "myelinWaterFractionImageProcessing", ...
            "nonlinearImageRegistration", ...
            "nonlinearTransformation", ...
            "nonrigidImageRegistration", ...
            "nonrigidMotionCorrection", ...
            "nonrigidTransformation", ...
            "nuisanceRegression", ...
            "pathwayAnalysis", ...
            "performanceProfiling", ...
            "phaseSynchronizationAnalysis", ...
            "principalComponentAnalysis", ...
            "probabilisticAnatomicalParcellationTechnique", ...
            "probabilisticDiffusionTractography", ...
            "qualitativeAnalysis", ...
            "quantitativeAnalysis", ...
            "ratiometry", ...
            "reconstructionTechnique", ...
            "rigidImageRegistration", ...
            "rigidMotionCorrection", ...
            "rigidTransformation", ...
            "seed-basedCorrelationAnalysis", ...
            "semanticAnchoring", ...
            "semiquantitativeAnalysis", ...
            "signalFilteringTechnique", ...
            "signalProcessingTechnique", ...
            "sliceTimingCorrection", ...
            "spectralPowerAutoSegmentationTechnique", ...
            "spikeSorting", ...
            "stochasticOnlineMatrixFactorization", ...
            "structuralCovarianceAnalysis", ...
            "supportVectorMachineClassifier", ...
            "supportVectorMachineRegression", ...
            "surfaceProjection", ...
            "temporalFiltering", ...
            "tractography", ...
            "transformation", ...
            "univariateAnalysis", ...
            "videoAnnotation", ...
            "voxel-basedMorphometry", ...
            "zScoreAnalysis" ...
        ]
    end

    methods
        function obj = AnalysisTechnique(varargin)
            obj@openminds.abstract.ControlledTerm(varargin{:})
        end
    end
end
