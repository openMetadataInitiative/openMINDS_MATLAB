classdef File < openminds.abstract.Schema
%File - Structured information on a file instance that is accessible via a URL.
%
%   PROPERTIES:
%
%   IRI                : (1,1) string
%                        Enter the internationalized resource identifier (IRI) to this file instance.
%
%   contentDescription : (1,1) string
%                        Enter a short content description for this file instance.
%
%   dataType           : (1,:) <a href="matlab:help openminds.controlledterms.DataType" style="font-weight:bold">DataType</a>
%                        Add all data types that are specifically represented in this file instance.
%
%   fileRepository     : (1,1) <a href="matlab:help openminds.core.data.FileRepository" style="font-weight:bold">FileRepository</a>
%                        Add the overarching repository to which this file instance belongs.
%
%   format             : (1,1) <a href="matlab:help openminds.core.data.ContentType" style="font-weight:bold">ContentType</a>
%                        Add the content type of this file instance.
%
%   hash               : (1,:) <a href="matlab:help openminds.core.data.Hash" style="font-weight:bold">Hash</a>
%                        Add all hashes that were generated for this file instance.
%
%   isPartOf           : (1,:) <a href="matlab:help openminds.core.data.FileBundle" style="font-weight:bold">FileBundle</a>
%                        Add all file bundles in which this file instance is grouped into.
%
%   name               : (1,1) string
%                        Enter the name of this file instance.
%
%   specialUsageRole   : (1,1) <a href="matlab:help openminds.controlledterms.FileUsageRole" style="font-weight:bold">FileUsageRole</a>
%                        Add the special usage role of this file instance.
%
%   storageSize        : (1,1) <a href="matlab:help openminds.core.miscellaneous.QuantitativeValue" style="font-weight:bold">QuantitativeValue</a>
%                        Enter the storage size of this file instance.

%   This class was auto-generated by the openMINDS pipeline

    properties
        % Enter the internationalized resource identifier (IRI) to this file instance.
        IRI (1,1) string

        % Enter a short content description for this file instance.
        contentDescription (1,1) string

        % Add all data types that are specifically represented in this file instance.
        dataType (1,:) openminds.controlledterms.DataType ...
            {mustBeListOfUniqueItems(dataType)}

        % Add the overarching repository to which this file instance belongs.
        fileRepository (1,:) openminds.core.data.FileRepository ...
            {mustBeSpecifiedLength(fileRepository, 0, 1)}

        % Add the content type of this file instance.
        format (1,:) openminds.core.data.ContentType ...
            {mustBeSpecifiedLength(format, 0, 1)}

        % Add all hashes that were generated for this file instance.
        hash (1,:) openminds.core.data.Hash ...
            {mustBeListOfUniqueItems(hash)}

        % Add all file bundles in which this file instance is grouped into.
        isPartOf (1,:) openminds.core.data.FileBundle ...
            {mustBeListOfUniqueItems(isPartOf)}

        % Enter the name of this file instance.
        name (1,1) string

        % Add the special usage role of this file instance.
        specialUsageRole (1,:) openminds.controlledterms.FileUsageRole ...
            {mustBeSpecifiedLength(specialUsageRole, 0, 1)}

        % Enter the storage size of this file instance.
        storageSize (1,:) openminds.core.miscellaneous.QuantitativeValue ...
            {mustBeSpecifiedLength(storageSize, 0, 1)}
    end

    properties (Access = protected)
        Required = ["IRI", "name"]
    end

    properties (Constant, Hidden)
        X_TYPE = "https://openminds.om-i.org/types/File"
    end

    properties (Constant, Hidden)
        LINKED_PROPERTIES = struct(...
            'dataType', "openminds.controlledterms.DataType", ...
            'fileRepository', "openminds.core.data.FileRepository", ...
            'format', "openminds.core.data.ContentType", ...
            'isPartOf', "openminds.core.data.FileBundle", ...
            'specialUsageRole', "openminds.controlledterms.FileUsageRole" ...
        )
        EMBEDDED_PROPERTIES = struct(...
            'hash', "openminds.core.data.Hash", ...
            'storageSize', "openminds.core.miscellaneous.QuantitativeValue" ...
        )
    end

    methods
        function obj = File(varargin)
            obj@openminds.abstract.Schema(varargin{:})
        end
    end

    methods (Access = protected)
        function str = getDisplayLabel(obj)
            str = obj.name;
        end
    end
end
