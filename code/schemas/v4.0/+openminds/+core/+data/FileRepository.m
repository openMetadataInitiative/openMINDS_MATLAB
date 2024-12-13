classdef FileRepository < openminds.abstract.Schema
%FileRepository - Structured information on a file repository.
%
%   PROPERTIES:
%
%   IRI                : (1,1) string
%                        Enter the internationalized resource identifier (IRI) to this file repository.
%
%   contentTypePattern : (1,:) <a href="matlab:help openminds.core.data.ContentTypePattern" style="font-weight:bold">ContentTypePattern</a>
%                        Add all content type patterns that identify matching content types for files within this file repository.
%
%   format             : (1,1) <a href="matlab:help openminds.core.data.ContentType" style="font-weight:bold">ContentType</a>
%                        If the files and file bundles within this repository are organised and formatted according to a formal data structure, add the content type of this formal data structure. Leave blank if no formal data structure has been applied.
%
%   hash               : (1,1) <a href="matlab:help openminds.core.data.Hash" style="font-weight:bold">Hash</a>
%                        Add the hash that was generated for this file repository.
%
%   hostedBy           : (1,1) <a href="matlab:help openminds.core.actors.Organization" style="font-weight:bold">Organization</a>
%                        Add the host organization of this file repository.
%
%   name               : (1,1) string
%                        Enter the name of this file repository.
%
%   storageSize        : (1,1) <a href="matlab:help openminds.core.miscellaneous.QuantitativeValue" style="font-weight:bold">QuantitativeValue</a>
%                        Enter the storage size of this file repository.
%
%   structurePattern   : (1,1) <a href="matlab:help openminds.core.data.FileRepositoryStructure" style="font-weight:bold">FileRepositoryStructure</a>
%                        Add the file repository structure that identifies the file path patterns used in this file repository.
%
%   type               : (1,1) <a href="matlab:help openminds.controlledterms.FileRepositoryType" style="font-weight:bold">FileRepositoryType</a>
%                        Add the type of this file repository.

%   This class was auto-generated by the openMINDS pipeline

    properties
        % Enter the internationalized resource identifier (IRI) to this file repository.
        IRI (1,1) string

        % Add all content type patterns that identify matching content types for files within this file repository.
        contentTypePattern (1,:) openminds.core.data.ContentTypePattern ...
            {mustBeListOfUniqueItems(contentTypePattern)}

        % If the files and file bundles within this repository are organised and formatted according to a formal data structure, add the content type of this formal data structure. Leave blank if no formal data structure has been applied.
        format (1,:) openminds.core.data.ContentType ...
            {mustBeSpecifiedLength(format, 0, 1)}

        % Add the hash that was generated for this file repository.
        hash (1,:) openminds.core.data.Hash ...
            {mustBeSpecifiedLength(hash, 0, 1)}

        % Add the host organization of this file repository.
        hostedBy (1,:) openminds.core.actors.Organization ...
            {mustBeSpecifiedLength(hostedBy, 0, 1)}

        % Enter the name of this file repository.
        name (1,1) string

        % Enter the storage size of this file repository.
        storageSize (1,:) openminds.core.miscellaneous.QuantitativeValue ...
            {mustBeSpecifiedLength(storageSize, 0, 1)}

        % Add the file repository structure that identifies the file path patterns used in this file repository.
        structurePattern (1,:) openminds.core.data.FileRepositoryStructure ...
            {mustBeSpecifiedLength(structurePattern, 0, 1)}

        % Add the type of this file repository.
        type (1,:) openminds.controlledterms.FileRepositoryType ...
            {mustBeSpecifiedLength(type, 0, 1)}
    end

    properties (Access = protected)
        Required = ["IRI", "hostedBy", "name"]
    end

    properties (Constant, Hidden)
        X_TYPE = "https://openminds.om-i.org/types/FileRepository"
    end

    properties (Constant, Hidden)
        LINKED_PROPERTIES = struct(...
            'contentTypePattern', "openminds.core.data.ContentTypePattern", ...
            'format', "openminds.core.data.ContentType", ...
            'hostedBy', "openminds.core.actors.Organization", ...
            'structurePattern', "openminds.core.data.FileRepositoryStructure", ...
            'type', "openminds.controlledterms.FileRepositoryType" ...
        )
        EMBEDDED_PROPERTIES = struct(...
            'hash', "openminds.core.data.Hash", ...
            'storageSize', "openminds.core.miscellaneous.QuantitativeValue" ...
        )
    end

    methods
        function obj = FileRepository(varargin)
            obj@openminds.abstract.Schema(varargin{:})
        end
    end

    methods (Access = protected)
        function str = getDisplayLabel(obj)
            str = sprintf('%s', obj.name);
        end
    end
end
