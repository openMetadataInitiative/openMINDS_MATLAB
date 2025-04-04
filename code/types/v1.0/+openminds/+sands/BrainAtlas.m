classdef BrainAtlas < openminds.abstract.Schema & openminds.internal.mixin.HasControlledInstance
%BrainAtlas - No description available.
%
%   PROPERTIES:
%
%   description : (1,1) string
%                 Enter a short description for this brain atlas.
%
%   fullName    : (1,1) string
%                 Enter a descriptive full name for this brain atlas.
%
%   hasVersion  : (1,:) <a href="matlab:help openminds.sands.BrainAtlasVersion" style="font-weight:bold">BrainAtlasVersion</a>
%                 Add one or several brain atlas versions that belong to this brain atlas.
%
%   homepage    : (1,1) string
%                 Enter the internationalized resource identifier (IRI) to the homepage of this brain atlas.
%
%   shortName   : (1,1) string
%                 Enter a descriptive short name for this brain atlas.

%   This class was auto-generated by the openMINDS pipeline

    properties
        % Enter a short description for this brain atlas.
        description (1,1) string

        % Enter a descriptive full name for this brain atlas.
        fullName (1,1) string

        % Add one or several brain atlas versions that belong to this brain atlas.
        hasVersion (1,:) openminds.sands.BrainAtlasVersion ...
            {mustBeListOfUniqueItems(hasVersion)}

        % Enter the internationalized resource identifier (IRI) to the homepage of this brain atlas.
        homepage (1,1) string

        % Enter a descriptive short name for this brain atlas.
        shortName (1,1) string
    end

    properties (Access = protected)
        Required = ["description", "fullName", "hasVersion", "shortName"]
    end

    properties (Constant, Hidden)
        X_TYPE = "https://openminds.ebrains.eu/sands/BrainAtlas"
    end

    properties (Constant, Hidden)
        LINKED_PROPERTIES = struct(...
            'hasVersion', "openminds.sands.BrainAtlasVersion" ...
        )
        EMBEDDED_PROPERTIES = struct(...
        )
    end

    methods
        function obj = BrainAtlas(varargin)
            obj@openminds.abstract.Schema(varargin{:})
        end
    end

    methods (Access = protected)
        function str = getDisplayLabel(obj)
            str = obj.fullName;
        end
    end

    methods (Static)
        function instance = fromName(name)
            typeName = mfilename('classname');
            instance = openminds.internal.mixin.HasControlledInstance.fromName(name, typeName);
        end
        function instanceNames = listInstances()
            typeName = mfilename('classname');
            instanceNames = openminds.internal.mixin.HasControlledInstance.listInstances(typeName);
        end
    end
end
