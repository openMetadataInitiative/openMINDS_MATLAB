classdef Organization < openminds.abstract.Schema
%Organization - An entity comprised of one or more natural persons with a particular purpose. [adapted from Wikipedia](https://en.wikipedia.org/wiki/Organization)
%
%   PROPERTIES:
%
%   affiliation       : (1,:) <a href="matlab:help openminds.core.actors.Affiliation" style="font-weight:bold">Affiliation</a>
%                       Enter all current and, if necessary, past affiliations of this organization.
%
%   digitalIdentifier : (1,:) <a href="matlab:help openminds.core.digitalidentifier.GRIDID" style="font-weight:bold">GRIDID</a>, <a href="matlab:help openminds.core.digitalidentifier.RORID" style="font-weight:bold">RORID</a>, <a href="matlab:help openminds.core.digitalidentifier.RRID" style="font-weight:bold">RRID</a>
%                       Add all globally unique and persistent digital identifier of this organization.
%
%   fullName          : (1,1) string
%                       Enter the full name of this organization.
%
%   hasParent         : (1,:) <a href="matlab:help openminds.core.actors.Organization" style="font-weight:bold">Organization</a>
%                       Add all parent organizations of this organization.
%
%   homepage          : (1,1) string
%                       Enter the internationalized resource identifier (IRI) to the homepage of this organization.
%
%   shortName         : (1,1) string
%                       Enter a short name (or alias) for this organization that could be used as a shortened display title (e.g., for web services with too little space to display the full name).

%   This class was auto-generated by the openMINDS pipeline

    properties
        % Enter all current and, if necessary, past affiliations of this organization.
        affiliation (1,:) openminds.core.actors.Affiliation ...
            {mustBeListOfUniqueItems(affiliation)}

        % Add all globally unique and persistent digital identifier of this organization.
        digitalIdentifier (1,:) openminds.internal.mixedtype.organization.DigitalIdentifier ...
            {mustBeListOfUniqueItems(digitalIdentifier)}

        % Enter the full name of this organization.
        fullName (1,1) string

        % Add all parent organizations of this organization.
        hasParent (1,:) openminds.core.actors.Organization ...
            {mustBeListOfUniqueItems(hasParent)}

        % Enter the internationalized resource identifier (IRI) to the homepage of this organization.
        homepage (1,1) string

        % Enter a short name (or alias) for this organization that could be used as a shortened display title (e.g., for web services with too little space to display the full name).
        shortName (1,1) string
    end

    properties (Access = protected)
        Required = ["fullName"]
    end

    properties (Constant, Hidden)
        X_TYPE = "https://openminds.om-i.org/types/Organization"
    end

    properties (Constant, Hidden)
        LINKED_PROPERTIES = struct(...
            'digitalIdentifier', ["openminds.core.digitalidentifier.GRIDID", "openminds.core.digitalidentifier.RORID", "openminds.core.digitalidentifier.RRID"], ...
            'hasParent', "openminds.core.actors.Organization" ...
        )
        EMBEDDED_PROPERTIES = struct(...
            'affiliation', "openminds.core.actors.Affiliation" ...
        )
    end

    methods
        function obj = Organization(varargin)
            obj@openminds.abstract.Schema(varargin{:})
        end
    end

    methods (Access = protected)
        function str = getDisplayLabel(obj)
            str = sprintf('%s', obj.fullName);
        end
    end
end
