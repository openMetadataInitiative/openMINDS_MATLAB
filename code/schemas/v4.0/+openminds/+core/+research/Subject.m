classdef Subject < openminds.abstract.Schema
%Subject - Structured information on a subject.
%
%   PROPERTIES:
%
%   biologicalSex      : (1,1) <a href="matlab:help openminds.controlledterms.BiologicalSex" style="font-weight:bold">BiologicalSex</a>
%                        Add the biological sex of this specimen.
%
%   internalIdentifier : (1,1) string
%                        Enter the identifier (or label) of this specimen that is used within the corresponding data files to identify this specimen.
%
%   isPartOf           : (1,:) <a href="matlab:help openminds.core.research.SubjectGroup" style="font-weight:bold">SubjectGroup</a>
%                        Add all subject groups of which this subject is a member.
%
%   lookupLabel        : (1,1) string
%                        Enter a lookup label for this specimen that may help you to find this instance more easily.
%
%   species            : (1,1) <a href="matlab:help openminds.controlledterms.Species" style="font-weight:bold">Species</a>, <a href="matlab:help openminds.core.research.Strain" style="font-weight:bold">Strain</a>
%                        Add the species or strain (a sub-type of a genetic variant of species) of this specimen.
%
%   studiedState       : (1,:) <a href="matlab:help openminds.core.research.SubjectState" style="font-weight:bold">SubjectState</a>
%                        Add all states in which this subject was studied.

%   This class was auto-generated by the openMINDS pipeline

    properties
        % Add the biological sex of this specimen.
        biologicalSex (1,:) openminds.controlledterms.BiologicalSex ...
            {mustBeSpecifiedLength(biologicalSex, 0, 1)}

        % Enter the identifier (or label) of this specimen that is used within the corresponding data files to identify this specimen.
        internalIdentifier (1,1) string

        % Add all subject groups of which this subject is a member.
        isPartOf (1,:) openminds.core.research.SubjectGroup ...
            {mustBeListOfUniqueItems(isPartOf)}

        % Enter a lookup label for this specimen that may help you to find this instance more easily.
        lookupLabel (1,1) string

        % Add the species or strain (a sub-type of a genetic variant of species) of this specimen.
        species (1,:) openminds.internal.mixedtype.subject.Species ...
            {mustBeSpecifiedLength(species, 0, 1)}

        % Add all states in which this subject was studied.
        studiedState (1,:) openminds.core.research.SubjectState ...
            {mustBeListOfUniqueItems(studiedState)}
    end

    properties (Access = protected)
        Required = ["species", "studiedState"]
    end

    properties (Constant, Hidden)
        X_TYPE = "https://openminds.om-i.org/types/Subject"
    end

    properties (Constant, Hidden)
        LINKED_PROPERTIES = struct(...
            'biologicalSex', "openminds.controlledterms.BiologicalSex", ...
            'isPartOf', "openminds.core.research.SubjectGroup", ...
            'species', ["openminds.controlledterms.Species", "openminds.core.research.Strain"], ...
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
