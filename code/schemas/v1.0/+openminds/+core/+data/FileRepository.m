classdef FileRepository < openminds.abstract.Schema
%FileRepository - Structured information on a file repository.
%
%   PROPERTIES:
%
%   IRI         : (1,1) string
%                 Enter the internationalized resource identifier (IRI) of this file repository.
%
%   format      : (1,1) <a href="matlab:help openminds.core.data.ContentType" style="font-weight:bold">ContentType</a>
%                 Add the content type of this file repository.
%
%   hash        : (1,1) <a href="matlab:help openminds.core.data.Hash" style="font-weight:bold">Hash</a>
%                 Add the hash that was generated for this file repository.
%
%   hostedBy    : (1,1) <a href="matlab:help openminds.core.actors.Organization" style="font-weight:bold">Organization</a>
%                 Add the host of this file repository.
%
%   name        : (1,1) string
%                 Enter the name of this file repository.
%
%   storageSize : (1,1) <a href="matlab:help openminds.core.miscellaneous.QuantitativeValue" style="font-weight:bold">QuantitativeValue</a>
%                 Enter the storage size this file repository allocates.

%   This class was auto-generated by the openMINDS pipeline

    properties
        % Enter the internationalized resource identifier (IRI) of this file repository.
        IRI (1,1) string

        % Add the content type of this file repository.
        format (1,:) openminds.core.data.ContentType ...
            {mustBeSpecifiedLength(format, 0, 1)}

        % Add the hash that was generated for this file repository.
        hash (1,:) openminds.core.data.Hash ...
            {mustBeSpecifiedLength(hash, 0, 1)}

        % Add the host of this file repository.
        hostedBy (1,:) openminds.core.actors.Organization ...
            {mustBeSpecifiedLength(hostedBy, 0, 1)}

        % Enter the name of this file repository.
        name (1,1) string

        % Enter the storage size this file repository allocates.
        storageSize (1,:) openminds.core.miscellaneous.QuantitativeValue ...
            {mustBeSpecifiedLength(storageSize, 0, 1)}
    end

    properties (Access = protected)
        Required = ["IRI", "hostedBy", "name"]
    end

    properties (Constant, Hidden)
        X_TYPE = "https://openminds.ebrains.eu/core/FileRepository"
    end

    properties (Constant, Hidden)
        LINKED_PROPERTIES = struct(...
            'format', "openminds.core.data.ContentType", ...
            'hash', "openminds.core.data.Hash", ...
            'hostedBy', "openminds.core.actors.Organization" ...
        )
        EMBEDDED_PROPERTIES = struct(...
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
