classdef Periodical < openminds.abstract.Schema
%Periodical - No description available.
%
%   PROPERTIES:
%
%   abbreviation      : (1,1) string
%                       Enter the official (or most commonly used) abbreviation of the periodical (e.g., J. Physiol).
%
%   digitalIdentifier : (1,1) <a href="matlab:help openminds.core.digitalidentifier.ISSN" style="font-weight:bold">ISSN</a>
%                       Add the globally unique and persistent digital identifier of this periodical.
%
%   name              : (1,1) string
%                       Enter the name (or title) of this periodical (e.g., Journal of Physiology).

%   This class was auto-generated by the openMINDS pipeline

    properties
        % Enter the official (or most commonly used) abbreviation of the periodical (e.g., J. Physiol).
        abbreviation (1,1) string

        % Add the globally unique and persistent digital identifier of this periodical.
        digitalIdentifier (1,:) openminds.core.digitalidentifier.ISSN ...
            {mustBeSpecifiedLength(digitalIdentifier, 0, 1)}

        % Enter the name (or title) of this periodical (e.g., Journal of Physiology).
        name (1,1) string
    end

    properties (Access = protected)
        Required = []
    end

    properties (Constant, Hidden)
        X_TYPE = "https://openminds.ebrains.eu/publications/Periodical"
    end

    properties (Constant, Hidden)
        LINKED_PROPERTIES = struct(...
            'digitalIdentifier', "openminds.core.digitalidentifier.ISSN" ...
        )
        EMBEDDED_PROPERTIES = struct(...
        )
    end

    methods
        function obj = Periodical(varargin)
            obj@openminds.abstract.Schema(varargin{:})
        end
    end

    methods (Access = protected)
        function str = getDisplayLabel(obj)
            str = obj.name;
        end
    end
end
