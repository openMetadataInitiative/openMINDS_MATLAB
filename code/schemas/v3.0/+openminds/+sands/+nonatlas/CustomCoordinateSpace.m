classdef CustomCoordinateSpace < openminds.abstract.Schema
%CustomCoordinateSpace - No description available.
%
%   PROPERTIES:
%
%   anatomicalAxesOrientation : (1,1) <a href="matlab:help openminds.controlledterms.AnatomicalAxesOrientation" style="font-weight:bold">AnatomicalAxesOrientation</a>
%                               Add the axes orientation denoted in standard anatomical terms of direction (stated as XYZ) for this custom coordinate space.
%
%   axesOrigin                : (1,:) <a href="matlab:help openminds.core.miscellaneous.QuantitativeValue" style="font-weight:bold">QuantitativeValue</a>
%                               Enter the origin (central point where all axes intersect) of this custom coordinate space for two-dimensional spaces as [x, y] or for three-dimensional space as [x, y, z].
%
%   defaultImage              : (1,:) <a href="matlab:help openminds.core.data.File" style="font-weight:bold">File</a>
%                               Add all image files used as visual representation of this custom coordinate space.
%
%   name                      : (1,1) string
%                               Enter a descriptive name for this custom coordinate space.
%
%   nativeUnit                : (1,1) <a href="matlab:help openminds.controlledterms.UnitOfMeasurement" style="font-weight:bold">UnitOfMeasurement</a>
%                               Add the native unit that is used for this custom coordinate space.

%   This class was auto-generated by the openMINDS pipeline

    properties
        % Add the axes orientation denoted in standard anatomical terms of direction (stated as XYZ) for this custom coordinate space.
        anatomicalAxesOrientation (1,:) openminds.controlledterms.AnatomicalAxesOrientation ...
            {mustBeSpecifiedLength(anatomicalAxesOrientation, 0, 1)}

        % Enter the origin (central point where all axes intersect) of this custom coordinate space for two-dimensional spaces as [x, y] or for three-dimensional space as [x, y, z].
        axesOrigin (1,:) openminds.core.miscellaneous.QuantitativeValue ...
            {mustBeSpecifiedLength(axesOrigin, 2, 3)}

        % Add all image files used as visual representation of this custom coordinate space.
        defaultImage (1,:) openminds.core.data.File ...
            {mustBeListOfUniqueItems(defaultImage)}

        % Enter a descriptive name for this custom coordinate space.
        name (1,1) string

        % Add the native unit that is used for this custom coordinate space.
        nativeUnit (1,:) openminds.controlledterms.UnitOfMeasurement ...
            {mustBeSpecifiedLength(nativeUnit, 0, 1)}
    end

    properties (Access = protected)
        Required = ["anatomicalAxesOrientation", "axesOrigin", "name", "nativeUnit"]
    end

    properties (Constant, Hidden)
        X_TYPE = "https://openminds.ebrains.eu/sands/CustomCoordinateSpace"
    end

    properties (Constant, Hidden)
        LINKED_PROPERTIES = struct(...
            'anatomicalAxesOrientation', "openminds.controlledterms.AnatomicalAxesOrientation", ...
            'defaultImage', "openminds.core.data.File", ...
            'nativeUnit', "openminds.controlledterms.UnitOfMeasurement" ...
        )
        EMBEDDED_PROPERTIES = struct(...
            'axesOrigin', "openminds.core.miscellaneous.QuantitativeValue" ...
        )
    end

    methods
        function obj = CustomCoordinateSpace(varargin)
            obj@openminds.abstract.Schema(varargin{:})
        end
    end

    methods (Access = protected)
        function str = getDisplayLabel(obj)
            str = obj.name;
        end
    end
end
