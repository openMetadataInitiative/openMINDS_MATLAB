classdef Subject < openminds.abstract.Schema
%Subject - Structured information on a subject.
%
%   PROPERTIES:
%
%   biologicalSex      : (1,1) <a href="matlab:help openminds.controlledterms.BiologicalSex" style="font-weight:bold">BiologicalSex</a>
%                        Add the biological sex of this specimen.
%
%   genotype           : (1,1) <a href="matlab:help openminds.controlledterms.Genotype" style="font-weight:bold">Genotype</a>
%                        Add the genotype of this specimen.
%
%   internalIdentifier : (1,1) string
%                        Enter the identifier of this specimen that is used within the corresponding data.
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
%   studiedState       : (1,:) <a href="matlab:help openminds.core.research.SubjectState" style="font-weight:bold">SubjectState</a>
%                        Add all states in which this subject was studied.

%   This class was auto-generated by the openMINDS pipeline

    properties
        % Add the biological sex of this specimen.
        biologicalSex (1,:) openminds.controlledterms.BiologicalSex ...
            {mustBeSpecifiedLength(biologicalSex, 0, 1)}

        % Add the genotype of this specimen.
        genotype (1,:) openminds.controlledterms.Genotype ...
            {mustBeSpecifiedLength(genotype, 0, 1)}

        % Enter the identifier of this specimen that is used within the corresponding data.
        internalIdentifier (1,1) string

        % Add the phenotype of this specimen.
        phenotype (1,:) openminds.controlledterms.Phenotype ...
            {mustBeSpecifiedLength(phenotype, 0, 1)}

        % Add the species of this specimen.
        species (1,:) openminds.controlledterms.Species ...
            {mustBeSpecifiedLength(species, 0, 1)}

        % Add the strain of this specimen.
        strain (1,:) openminds.controlledterms.Strain ...
            {mustBeSpecifiedLength(strain, 0, 1)}

        % Add all states in which this subject was studied.
        studiedState (1,:) openminds.core.research.SubjectState ...
            {mustBeListOfUniqueItems(studiedState)}
    end

    properties (Access = protected)
        Required = ["biologicalSex", "internalIdentifier", "species", "studiedState"]
    end

    properties (Constant, Hidden)
        X_TYPE = "https://openminds.ebrains.eu/core/Subject"
    end

    properties (Constant, Hidden)
        LINKED_PROPERTIES = struct(...
            'biologicalSex', "openminds.controlledterms.BiologicalSex", ...
            'genotype', "openminds.controlledterms.Genotype", ...
            'phenotype', "openminds.controlledterms.Phenotype", ...
            'species', "openminds.controlledterms.Species", ...
            'strain', "openminds.controlledterms.Strain", ...
            'studiedState', "openminds.core.research.SubjectState" ...
        )
        EMBEDDED_PROPERTIES = struct(...
        )
    end

    methods
        function obj = Subject(varargin)
            obj@openminds.abstract.Schema(varargin{:})
        end
    end

    methods (Access = protected)
        function str = getDisplayLabel(obj)
            str = sprintf('%s', obj.lookupLabel);
        end
    end
end
