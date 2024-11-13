classdef ParcellationTerminology < openminds.abstract.Schema
%ParcellationTerminology - No description available.
%
%   PROPERTIES:
%
%   definedIn              : (1,:) <a href="matlab:help openminds.core.data.File" style="font-weight:bold">File</a>
%                            Add one or several files in which this parcellation terminology is stored in.
%
%   fullName               : (1,1) string
%                            Enter a descriptive full name for this parcellation terminology.
%
%   isAlternativeVersionOf : (1,:) <a href="matlab:help openminds.sands.atlas.BrainAtlasVersion" style="font-weight:bold">BrainAtlasVersion</a>
%                            Add one or several alternative versions to this parcellation terminology.
%
%   isNewVersionOf         : (1,1) <a href="matlab:help openminds.sands.atlas.BrainAtlasVersion" style="font-weight:bold">BrainAtlasVersion</a>
%                            Add the earlier version of this parcellation terminology.
%
%   ontologyIdentifier     : (1,1) string
%                            Enter the identifier (IRI) of the related ontological term matching this parcellation terminology.
%
%   shortName              : (1,1) string
%                            Enter a descriptive short name for this parcellation terminology.
%
%   versionIdentifier      : (1,1) string
%                            Enter the version identifier of this parcellation terminology.
%
%   versionInnovation      : (1,1) string
%                            Enter a short description of the novelties/peculiarities of this parcellation terminology.

%   This class was auto-generated by the openMINDS pipeline

    properties
        % Add one or several files in which this parcellation terminology is stored in.
        definedIn (1,:) openminds.core.data.File ...
            {mustBeListOfUniqueItems(definedIn)}

        % Enter a descriptive full name for this parcellation terminology.
        fullName (1,1) string

        % Add one or several alternative versions to this parcellation terminology.
        isAlternativeVersionOf (1,:) openminds.sands.atlas.BrainAtlasVersion ...
            {mustBeListOfUniqueItems(isAlternativeVersionOf)}

        % Add the earlier version of this parcellation terminology.
        isNewVersionOf (1,:) openminds.sands.atlas.BrainAtlasVersion ...
            {mustBeSpecifiedLength(isNewVersionOf, 0, 1)}

        % Enter the identifier (IRI) of the related ontological term matching this parcellation terminology.
        ontologyIdentifier (1,1) string

        % Enter a descriptive short name for this parcellation terminology.
        shortName (1,1) string

        % Enter the version identifier of this parcellation terminology.
        versionIdentifier (1,1) string

        % Enter a short description of the novelties/peculiarities of this parcellation terminology.
        versionInnovation (1,1) string
    end

    properties (Access = protected)
        Required = ["fullName", "shortName", "versionIdentifier", "versionInnovation"]
    end

    properties (Constant, Hidden)
        X_TYPE = "https://openminds.ebrains.eu/sands/ParcellationTerminology"
    end

    properties (Constant, Hidden)
        LINKED_PROPERTIES = struct(...
            'definedIn', "openminds.core.data.File", ...
            'isAlternativeVersionOf', "openminds.sands.atlas.BrainAtlasVersion", ...
            'isNewVersionOf', "openminds.sands.atlas.BrainAtlasVersion" ...
        )
        EMBEDDED_PROPERTIES = struct(...
        )
    end

    methods
        function obj = ParcellationTerminology(varargin)
            obj@openminds.abstract.Schema(varargin{:})
        end
    end

    methods (Access = protected)
        function str = getDisplayLabel(obj)
            str = obj.fullName;
        end
    end
end