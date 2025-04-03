classdef Funding < openminds.abstract.Schema
%Funding - Structured information on used funding.
%
%   PROPERTIES:
%
%   acknowledgement : (1,1) string
%                     Enter the acknowledgement that should be used with this funding.
%
%   awardNumber     : (1,1) string
%                     Enter the associated award number of this funding.
%
%   awardTitle      : (1,1) string
%                     Enter the award title of this funding.
%
%   funder          : (1,1) <a href="matlab:help openminds.core.actors.Consortium" style="font-weight:bold">Consortium</a>, <a href="matlab:help openminds.core.actors.Organization" style="font-weight:bold">Organization</a>, <a href="matlab:help openminds.core.actors.Person" style="font-weight:bold">Person</a>
%                     Add the party that provided this funding.

%   This class was auto-generated by the openMINDS pipeline

    properties
        % Enter the acknowledgement that should be used with this funding.
        acknowledgement (1,1) string

        % Enter the associated award number of this funding.
        awardNumber (1,1) string

        % Enter the award title of this funding.
        awardTitle (1,1) string

        % Add the party that provided this funding.
        funder (1,:) openminds.internal.mixedtype.funding.Funder ...
            {mustBeSpecifiedLength(funder, 0, 1)}
    end

    properties (Access = protected)
        Required = ["funder"]
    end

    properties (Constant, Hidden)
        X_TYPE = "https://openminds.ebrains.eu/core/Funding"
    end

    properties (Constant, Hidden)
        LINKED_PROPERTIES = struct(...
            'funder', ["openminds.core.actors.Consortium", "openminds.core.actors.Organization", "openminds.core.actors.Person"] ...
        )
        EMBEDDED_PROPERTIES = struct(...
        )
    end

    methods
        function obj = Funding(varargin)
            obj@openminds.abstract.Schema(varargin{:})
        end
    end

    methods (Access = protected)
        function str = getDisplayLabel(obj)
            str = sprintf('%s (%s)', obj.funder, obj.awardNumber);
        end
    end
end
