classdef FileRepositoryStructure < openminds.abstract.Schema
%FileRepositoryStructure - No description available.
%
%   PROPERTIES:
%
%   filePathPattern : (1,:) <a href="matlab:help openminds.core.data.FilePathPattern" style="font-weight:bold">FilePathPattern</a>
%                     Add all file path patterns that define this file repository structure.
%
%   lookupLabel     : (1,1) string
%                     Enter a lookup label for this file repository structure that may help you to find this instance more easily.

%   This class was auto-generated by the openMINDS pipeline

    properties
        % Add all file path patterns that define this file repository structure.
        filePathPattern (1,:) openminds.core.data.FilePathPattern ...
            {mustBeListOfUniqueItems(filePathPattern)}

        % Enter a lookup label for this file repository structure that may help you to find this instance more easily.
        lookupLabel (1,1) string
    end

    properties (Access = protected)
        Required = ["filePathPattern"]
    end

    properties (Constant, Hidden)
        X_TYPE = "https://openminds.om-i.org/types/FileRepositoryStructure"
    end

    properties (Constant, Hidden)
        LINKED_PROPERTIES = struct(...
        )
        EMBEDDED_PROPERTIES = struct(...
            'filePathPattern', "openminds.core.data.FilePathPattern" ...
        )
    end

    methods
        function obj = FileRepositoryStructure(varargin)
            obj@openminds.abstract.Schema(varargin{:})
        end
    end

    methods (Access = protected)
        function str = getDisplayLabel(obj)
            str = sprintf('%s', obj.lookupLabel);
        end
    end
end