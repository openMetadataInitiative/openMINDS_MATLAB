classdef Organization < openminds.abstract.Schema
%Organization - An entity comprised of one or more natural persons with a particular purpose. [adapted from Wikipedia](https://en.wikipedia.org/wiki/Organization)
%
%   PROPERTIES:
%
%   digitalIdentifier : (1,:) <a href="matlab:help openminds.core.miscellaneous.GRIDID" style="font-weight:bold">GRIDID</a>, <a href="matlab:help openminds.core.miscellaneous.RORID" style="font-weight:bold">RORID</a>
%                       Add one or several globally unique and persistent digital identifier for this organization.
%
%   fullName          : (1,1) string
%                       Enter the full name of the organization.
%
%   hasParent         : (1,1) <a href="matlab:help openminds.core.actors.Organization" style="font-weight:bold">Organization</a>
%                       Add a parent organization to this organization.
%
%   homepage          : (1,1) <a href="matlab:help openminds.core.miscellaneous.URL" style="font-weight:bold">URL</a>
%                       Add the uniform resource locator (URL) to the homepage of this organization.
%
%   shortName         : (1,1) string
%                       Enter the short name of this organization.

%   This class was auto-generated by the openMINDS pipeline

    properties
        % Add one or several globally unique and persistent digital identifier for this organization.
        digitalIdentifier (1,:) openminds.internal.mixedtype.organization.DigitalIdentifier ...
            {mustBeListOfUniqueItems(digitalIdentifier)}

        % Enter the full name of the organization.
        fullName (1,1) string

        % Add a parent organization to this organization.
        hasParent (1,:) openminds.core.actors.Organization ...
            {mustBeSpecifiedLength(hasParent, 0, 1)}

        % Add the uniform resource locator (URL) to the homepage of this organization.
        homepage (1,:) openminds.core.miscellaneous.URL ...
            {mustBeSpecifiedLength(homepage, 0, 1)}

        % Enter the short name of this organization.
        shortName (1,1) string
    end

    properties (Access = protected)
        Required = ["fullName"]
    end

    properties (Constant, Hidden)
        X_TYPE = "https://openminds.ebrains.eu/core/Organization"
    end

    properties (Constant, Hidden)
        LINKED_PROPERTIES = struct(...
            'digitalIdentifier', ["openminds.core.miscellaneous.GRIDID", "openminds.core.miscellaneous.RORID"], ...
            'hasParent', "openminds.core.actors.Organization", ...
            'homepage', "openminds.core.miscellaneous.URL" ...
        )
        EMBEDDED_PROPERTIES = struct(...
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