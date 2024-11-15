classdef Copyright < openminds.abstract.Schema
%Copyright - Structured information on the copyright.
%
%   PROPERTIES:
%
%   holder : (1,:) <a href="matlab:help openminds.core.actors.Consortium" style="font-weight:bold">Consortium</a>, <a href="matlab:help openminds.core.actors.Organization" style="font-weight:bold">Organization</a>, <a href="matlab:help openminds.core.actors.Person" style="font-weight:bold">Person</a>
%            Add all parties that hold this copyright.
%
%   year   : (1,:) string
%            Enter the year during which the copyright was first asserted and, optionally, later years during which updated versions were published.

%   This class was auto-generated by the openMINDS pipeline

    properties
        % Add all parties that hold this copyright.
        holder (1,:) openminds.internal.mixedtype.copyright.Holder ...
            {mustBeListOfUniqueItems(holder)}

        % Enter the year during which the copyright was first asserted and, optionally, later years during which updated versions were published.
        year (1,:) string ...
            {mustBeListOfUniqueItems(year)}
    end

    properties (Access = protected)
        Required = ["holder", "year"]
    end

    properties (Constant, Hidden)
        X_TYPE = "https://openminds.ebrains.eu/core/Copyright"
    end

    properties (Constant, Hidden)
        LINKED_PROPERTIES = struct(...
            'holder', ["openminds.core.actors.Consortium", "openminds.core.actors.Organization", "openminds.core.actors.Person"] ...
        )
        EMBEDDED_PROPERTIES = struct(...
        )
    end

    methods
        function obj = Copyright(varargin)
            obj@openminds.abstract.Schema(varargin{:})
        end
    end

    methods (Access = protected)
        function str = getDisplayLabel(obj)
            str = sprintf('%s (%s)', obj.holder, obj.year);
        end
    end
end