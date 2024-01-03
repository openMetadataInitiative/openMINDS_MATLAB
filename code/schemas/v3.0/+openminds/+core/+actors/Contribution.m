classdef Contribution < openminds.abstract.Schema
%Contribution - Structured information on the contribution made to a research product.
%
%   PROPERTIES:
%
%   contributor : (1,1) <a href="matlab:help openminds.core.Consortium" style="font-weight:bold">Consortium</a>, <a href="matlab:help openminds.core.Organization" style="font-weight:bold">Organization</a>, <a href="matlab:help openminds.core.Person" style="font-weight:bold">Person</a>
%                 Add all types of contribution made by the stated 'contributor'.
%
%   type        : (1,:) <a href="matlab:help openminds.controlledterms.ContributionType" style="font-weight:bold">ContributionType</a>
%                 Add the party that performed the contribution.

%   This class was auto-generated by the openMINDS pipeline

    properties
        % Add all types of contribution made by the stated 'contributor'.
        contributor (1,:) openminds.internal.mixedtype.contribution.Contributor ...
            {mustBeSpecifiedLength(contributor, 0, 1)}

        % Add the party that performed the contribution.
        type (1,:) openminds.controlledterms.ContributionType ...
            {mustBeListOfUniqueItems(type)}
    end

    properties (Access = protected)
        Required = ["contributor", "type"]
    end

    properties (Constant, Hidden)
        X_TYPE = "https://openminds.ebrains.eu/core/Contribution"
    end

    properties (Constant, Hidden)
        LINKED_PROPERTIES = struct(...
            'contributor', ["openminds.core.Consortium", "openminds.core.Organization", "openminds.core.Person"], ...
            'type', "openminds.controlledterms.ContributionType" ...
        )
        EMBEDDED_PROPERTIES = struct(...
        )
    end

    methods
        function obj = Contribution(varargin)
            obj@openminds.abstract.Schema(varargin{:})
        end
    end

    methods (Access = protected)
        function str = getDisplayLabel(obj)
            str = sprintf('%s (%s)', obj.contributor, type);
        end
    end

end