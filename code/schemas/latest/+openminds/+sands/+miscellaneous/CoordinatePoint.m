classdef CoordinatePoint < openminds.abstract.Schema
%CoordinatePoint - Structured information on a coordinate point.
%
%   PROPERTIES:
%
%   coordinateSpace : (1,1) <a href="matlab:help openminds.sands.CommonCoordinateSpaceVersion" style="font-weight:bold">CommonCoordinateSpaceVersion</a>, <a href="matlab:help openminds.sands.CustomCoordinateSpace" style="font-weight:bold">CustomCoordinateSpace</a>
%                     Add the coordinate space in which this coordinate point exists in.
%
%   coordinates     : (1,:) <a href="matlab:help openminds.core.QuantitativeValue" style="font-weight:bold">QuantitativeValue</a>
%                     Enter the coordinates of this point within the stated coordinate space for two-dimensonal spaces as [x, y] or for three-dimensional space as [x, y, z].

%   This class was auto-generated by the openMINDS pipeline

    properties
        % Add the coordinate space in which this coordinate point exists in.
        coordinateSpace (1,:) openminds.internal.mixedtype.coordinatepoint.CoordinateSpace ...
            {mustBeSpecifiedLength(coordinateSpace, 0, 1)}

        % Enter the coordinates of this point within the stated coordinate space for two-dimensonal spaces as [x, y] or for three-dimensional space as [x, y, z].
        coordinates (1,:) openminds.core.QuantitativeValue ...
            {mustBeSpecifiedLength(coordinates, 2, 3)}
    end

    properties (Access = protected)
        Required = ["coordinateSpace", "coordinates"]
    end

    properties (Constant, Hidden)
        X_TYPE = "https://openminds.ebrains.eu/sands/CoordinatePoint"
    end

    properties (Constant, Hidden)
        LINKED_PROPERTIES = struct(...
            'coordinateSpace', ["openminds.sands.CommonCoordinateSpaceVersion", "openminds.sands.CustomCoordinateSpace"] ...
        )
        EMBEDDED_PROPERTIES = struct(...
            'coordinates', "openminds.core.QuantitativeValue" ...
        )
    end

    methods
        function obj = CoordinatePoint(varargin)
            obj@openminds.abstract.Schema(varargin{:})
        end
    end

    methods (Access = protected)
        function str = getDisplayLabel(obj)
            str = '<missing name>';
        end
    end

end