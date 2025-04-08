classdef CellType < openminds.abstract.ControlledTerm
%CellType - No description available.
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
        X_TYPE = "https://openminds.ebrains.eu/controlledTerms/CellType"
    end

    properties (Constant, Hidden)
        CONTROLLED_INSTANCES = [ ...
            "D1ReceptorExpressingNeuron", ...
            "D2ReceptorExpressingNeuron", ...
            "PurkinjeCell", ...
            "aromataseExpressingNeuron", ...
            "astrocyte", ...
            "basketCell", ...
            "calbindinExpressingNeuron", ...
            "calretininExpressingNeuron", ...
            "cerebellarInterneuron", ...
            "cerebellumBasketCell", ...
            "cerebellumGolgiCell", ...
            "cerebellumGranuleCell", ...
            "cerebellumStellateNeuron", ...
            "cholecystokininExpressingNeuron", ...
            "cholineAcetyltransferaseExpressingNeuron", ...
            "cholinergicInterneuron", ...
            "cholinergicNeuron", ...
            "corticalBasketCell", ...
            "corticalInterneuron", ...
            "dopaminergicNeuron", ...
            "excitatoryNeuron", ...
            "fastSpikingInterneuron", ...
            "glialCell", ...
            "granuleNeuron", ...
            "hippocampusCA1PyramidalNeuron", ...
            "inhibitoryNeuron", ...
            "interneuron", ...
            "macroglialCell", ...
            "mainOlfactoryBulbDeepTuftedNeuron", ...
            "mainOlfactoryBulbExternalTuftedNeuron", ...
            "mainOlfactoryBulbGranuleNeuron", ...
            "mainOlfactoryBulbMiddleTuftedNeuron", ...
            "mainOlfactoryBulbMitralNeuron", ...
            "mainOlfactoryBulbPeriglomerularNeuron", ...
            "mainOlfactoryBulbSuperficialTuftedNeuron", ...
            "mainOlfactoryBulbTuftedNeuron", ...
            "microglialCell", ...
            "motorNeuron", ...
            "neocortexLayer2-3PyramidalNeuron", ...
            "neocortexLayer5TuftedPyramidalNeuron", ...
            "neostriatumCholinergicInterneuron", ...
            "neostriatumDirectPathwaySpinyNeuron", ...
            "neostriatumIndirectPathwaySpinyNeuron", ...
            "neuron", ...
            "neuropeptideYExpressingNeuron", ...
            "nitricOxideSynthaseExpressingNeuron", ...
            "parvalbuminExpressingNeuron", ...
            "potmitoticCell", ...
            "progenitorCell", ...
            "pyramidalNeuron", ...
            "sensoryNeuron", ...
            "somatostatinExpressingNeuron", ...
            "spinalInterneuron", ...
            "spinyNeuron", ...
            "stellateNeuron", ...
            "striatalInterneuron", ...
            "striatumMediumSpinyNeuron", ...
            "vascularEndothelialCell", ...
            "vascularSmoothMuscleCell", ...
            "vasoactiveIntestinalPeptideExpressingNeuron" ...
        ]
    end

    methods
        function obj = CellType(varargin)
            obj@openminds.abstract.ControlledTerm(varargin{:})
        end
    end

    methods (Static)
        function instances = listInstances()
            instances = openminds.controlledterms.CellType.CONTROLLED_INSTANCES';
        end
    end
end
