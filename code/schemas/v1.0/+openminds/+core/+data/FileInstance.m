classdef FileInstance < openminds.abstract.Schema
%FileInstance - Structured information on a file instances.
%
%   PROPERTIES:
%
%   IRI              : (1,1) string
%                      Enter the internationalized resource identifier of this file instance.
%
%   content          : (1,1) string
%                      Enter a short content description for this file instance.
%
%   format           : (1,1) <a href="matlab:help openminds.core.data.ContentType" style="font-weight:bold">ContentType</a>
%                      Add the content type of this file instance.
%
%   hash             : (1,1) <a href="matlab:help openminds.core.data.Hash" style="font-weight:bold">Hash</a>
%                      Add the hash that was generated for this file instance.
%
%   isPartOf         : (1,:) <a href="matlab:help openminds.core.data.FileBundle" style="font-weight:bold">FileBundle</a>
%                      Add one or several file bundles in which this file instance can be grouped in.
%
%   name             : (1,1) string
%                      Enter the name of this file instance.
%
%   specialUsageRole : (1,1) <a href="matlab:help openminds.controlledterms.FileUsageRole" style="font-weight:bold">FileUsageRole</a>
%                      Add a special usage role for this file instance.
%
%   storageSize      : (1,1) <a href="matlab:help openminds.core.miscellaneous.QuantitativeValue" style="font-weight:bold">QuantitativeValue</a>
%                      Enter the storage size this file instance allocates.

%   This class was auto-generated by the openMINDS pipeline

    properties
        % Enter the internationalized resource identifier of this file instance.
        IRI (1,1) string

        % Enter a short content description for this file instance.
        content (1,1) string

        % Add the content type of this file instance.
        format (1,:) openminds.core.data.ContentType ...
            {mustBeSpecifiedLength(format, 0, 1)}

        % Add the hash that was generated for this file instance.
        hash (1,:) openminds.core.data.Hash ...
            {mustBeSpecifiedLength(hash, 0, 1)}

        % Add one or several file bundles in which this file instance can be grouped in.
        isPartOf (1,:) openminds.core.data.FileBundle ...
            {mustBeListOfUniqueItems(isPartOf)}

        % Enter the name of this file instance.
        name (1,1) string

        % Add a special usage role for this file instance.
        specialUsageRole (1,:) openminds.controlledterms.FileUsageRole ...
            {mustBeSpecifiedLength(specialUsageRole, 0, 1)}

        % Enter the storage size this file instance allocates.
        storageSize (1,:) openminds.core.miscellaneous.QuantitativeValue ...
            {mustBeSpecifiedLength(storageSize, 0, 1)}
    end

    properties (Access = protected)
        Required = ["IRI", "isPartOf", "name"]
    end

    properties (Constant, Hidden)
        X_TYPE = "https://openminds.ebrains.eu/core/FileInstance"
    end

    properties (Constant, Hidden)
        LINKED_PROPERTIES = struct(...
            'format', "openminds.core.data.ContentType", ...
            'hash', "openminds.core.data.Hash", ...
            'isPartOf', "openminds.core.data.FileBundle", ...
            'specialUsageRole', "openminds.controlledterms.FileUsageRole" ...
        )
        EMBEDDED_PROPERTIES = struct(...
            'storageSize', "openminds.core.miscellaneous.QuantitativeValue" ...
        )
    end

    methods
        function obj = FileInstance(varargin)
            obj@openminds.abstract.Schema(varargin{:})
        end
    end

    methods (Access = protected)
        function str = getDisplayLabel(obj)
            str = obj.name;
        end
    end
end
