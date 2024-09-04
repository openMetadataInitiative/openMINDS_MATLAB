classdef AtlasTerminology < openminds.abstract.Schema
%AtlasTerminology - No description available.
%
%   PROPERTIES:
%
%   anatomicalEntity   : (1,:) <a href="matlab:help openminds.sands.AnatomicalEntity" style="font-weight:bold">AnatomicalEntity</a>
%                        Add all anatomical entities that belong to this atlas terminology.
%
%   definedIn          : (1,:) <a href="matlab:help openminds.core.FileInstance" style="font-weight:bold">FileInstance</a>
%                        Add one or several files in which this atlas terminology is stored in.
%
%   fullName           : (1,1) string
%                        Enter a descriptive full name for this atlas terminology.
%
%   ontologyIdentifier : (1,1) string
%                        Enter the identifier (IRI) of the related ontological term matching this atlas terminology.
%
%   shortName          : (1,1) string
%                        Enter a descriptive short name for this atlas terminology.

%   This class was auto-generated by the openMINDS pipeline

    properties
        % Add all anatomical entities that belong to this atlas terminology.
        anatomicalEntity (1,:) openminds.sands.AnatomicalEntity ...
            {mustBeListOfUniqueItems(anatomicalEntity)}

        % Add one or several files in which this atlas terminology is stored in.
        definedIn (1,:) openminds.core.FileInstance ...
            {mustBeListOfUniqueItems(definedIn)}

        % Enter a descriptive full name for this atlas terminology.
        fullName (1,1) string

        % Enter the identifier (IRI) of the related ontological term matching this atlas terminology.
        ontologyIdentifier (1,1) string

        % Enter a descriptive short name for this atlas terminology.
        shortName (1,1) string
    end

    properties (Access = protected)
        Required = ["anatomicalEntity", "fullName", "shortName"]
    end

    properties (Constant, Hidden)
        X_TYPE = "https://openminds.ebrains.eu/sands/AtlasTerminology"
    end

    properties (Constant, Hidden)
        LINKED_PROPERTIES = struct(...
            'anatomicalEntity', "openminds.sands.AnatomicalEntity", ...
            'definedIn', "openminds.core.FileInstance" ...
        )
        EMBEDDED_PROPERTIES = struct(...
        )
    end

    methods
        function obj = AtlasTerminology(varargin)
            obj@openminds.abstract.Schema(varargin{:})
        end
    end

    methods (Access = protected)
        function str = getDisplayLabel(obj)
            str = obj.fullName;
        end
    end

end