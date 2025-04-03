classdef ContentTypePattern < openminds.abstract.Schema
%ContentTypePattern - No description available.
%
%   PROPERTIES:
%
%   contentType : (1,1) <a href="matlab:help openminds.core.data.ContentType" style="font-weight:bold">ContentType</a>
%                 Enter the content type that can be defined by the given regular expression for file names/extensions.
%
%   lookupLabel : (1,1) string
%                 Enter a lookup label for this content type pattern.
%
%   regex       : (1,1) string
%                 Enter a regular expression for the file names/extensions that defines the give content type.

%   This class was auto-generated by the openMINDS pipeline

    properties
        % Enter the content type that can be defined by the given regular expression for file names/extensions.
        contentType (1,:) openminds.core.data.ContentType ...
            {mustBeSpecifiedLength(contentType, 0, 1)}

        % Enter a lookup label for this content type pattern.
        lookupLabel (1,1) string

        % Enter a regular expression for the file names/extensions that defines the give content type.
        regex (1,1) string
    end

    properties (Access = protected)
        Required = ["contentType", "regex"]
    end

    properties (Constant, Hidden)
        X_TYPE = "https://openminds.ebrains.eu/core/ContentTypePattern"
    end

    properties (Constant, Hidden)
        LINKED_PROPERTIES = struct(...
            'contentType', "openminds.core.data.ContentType" ...
        )
        EMBEDDED_PROPERTIES = struct(...
        )
    end

    methods
        function obj = ContentTypePattern(varargin)
            obj@openminds.abstract.Schema(varargin{:})
        end
    end

    methods (Access = protected)
        function str = getDisplayLabel(obj)
            str = sprintf('%s', obj.lookupLabel);
        end
    end
end
