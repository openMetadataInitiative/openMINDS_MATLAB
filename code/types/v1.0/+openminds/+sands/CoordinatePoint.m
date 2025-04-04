classdef CoordinatePoint < openminds.abstract.Schema
%CoordinatePoint - No description available.
%
%   PROPERTIES:
%
%   coordinateSpace : (1,1) <a href="matlab:help openminds.sands.CoordinateSpace" style="font-weight:bold">CoordinateSpace</a>
%                     Add the coordinate space in which this coordinate point exists in.
%
%   coordinates     : (1,:) <a href="matlab:help openminds.core.miscellaneous.QuantitativeValue" style="font-weight:bold">QuantitativeValue</a>
%                     Add two or three coordinates (2D: [x, y] or 3D: [x, y, z]) that define the exact location of this point in the stated space.

%   This class was auto-generated by the openMINDS pipeline

    properties
        % Add the coordinate space in which this coordinate point exists in.
        coordinateSpace (1,:) openminds.sands.CoordinateSpace ...
            {mustBeSpecifiedLength(coordinateSpace, 0, 1)}

        % Add two or three coordinates (2D: [x, y] or 3D: [x, y, z]) that define the exact location of this point in the stated space.
        coordinates (1,:) openminds.core.miscellaneous.QuantitativeValue ...
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
            'coordinateSpace', "openminds.sands.CoordinateSpace" ...
        )
        EMBEDDED_PROPERTIES = struct(...
            'coordinates', "openminds.core.miscellaneous.QuantitativeValue" ...
        )
    end

    methods
        function obj = CoordinatePoint(varargin)
            obj@openminds.abstract.Schema(varargin{:})
        end
    end

    methods (Access = protected)
        function str = getDisplayLabel(obj)
            str = obj.createLabelForMissingLabelDefinition();
        end
    end
end
