classdef CoordinateSpace < openminds.abstract.Schema
%CoordinateSpace - Structured information on a coordinate space.
%
%   PROPERTIES:
%
%   anatomicalAxesOrientation : (1,1) <a href="matlab:help openminds.controlledterms.AnatomicalAxesOrientation" style="font-weight:bold">AnatomicalAxesOrientation</a>
%                               Add the axes orientation denoted in standard anatomical terms of direction (stated as XYZ).
%
%   axesOrigin                : (1,:) <a href="matlab:help openminds.core.QuantitativeValue" style="font-weight:bold">QuantitativeValue</a>
%                               Enter the origin of the coordinate system (central point where axes intersect; 2D: [x, y] or 3D:[x, y, z]).
%
%   defaultImage              : (1,:) <a href="matlab:help openminds.sands.Image" style="font-weight:bold">Image</a>
%                               Add one or several images used as visual representation of this coordinate space.
%
%   digitalIdentifier         : (1,1) <a href="matlab:help openminds.core.DigitalIdentifier" style="font-weight:bold">DigitalIdentifier</a>
%                               Add the globally unique and persistent digital identifier of this coordinate space.
%
%   fullName                  : (1,1) string
%                               Enter a descriptive full name for this coordinate space.
%
%   homepage                  : (1,1) string
%                               Enter the internationalized resource identifier (IRI) to the homepage of this brain atlas.
%
%   nativeUnit                : (1,1) <a href="matlab:help openminds.controlledterms.UnitOfMeasurement" style="font-weight:bold">UnitOfMeasurement</a>
%                               Add the native unit that is used for this coordinate space.
%
%   ontologyIdentifier        : (1,1) string
%                               Enter the identifier (IRI) of the related ontological term matching this coordinate space.
%
%   releaseDate               : (1,1) string
%                               Enter the date of first publication of this coordinate space.
%
%   shortName                 : (1,1) string
%                               Enter a descriptive short name for this coordinate space.
%
%   versionIdentifier         : (1,1) string
%                               Enter the version identifier of this coordinate space.

%   This class was auto-generated by the openMINDS pipeline

    properties
        % Add the axes orientation denoted in standard anatomical terms of direction (stated as XYZ).
        anatomicalAxesOrientation (1,:) openminds.controlledterms.AnatomicalAxesOrientation ...
            {mustBeSpecifiedLength(anatomicalAxesOrientation, 0, 1)}

        % Enter the origin of the coordinate system (central point where axes intersect; 2D: [x, y] or 3D:[x, y, z]).
        axesOrigin (1,:) openminds.core.QuantitativeValue ...
            {mustBeSpecifiedLength(axesOrigin, 2, 3)}

        % Add one or several images used as visual representation of this coordinate space.
        defaultImage (1,:) openminds.sands.Image ...
            {mustBeListOfUniqueItems(defaultImage)}

        % Add the globally unique and persistent digital identifier of this coordinate space.
        digitalIdentifier (1,:) openminds.core.DigitalIdentifier ...
            {mustBeSpecifiedLength(digitalIdentifier, 0, 1)}

        % Enter a descriptive full name for this coordinate space.
        fullName (1,1) string

        % Enter the internationalized resource identifier (IRI) to the homepage of this brain atlas.
        homepage (1,1) string

        % Add the native unit that is used for this coordinate space.
        nativeUnit (1,:) openminds.controlledterms.UnitOfMeasurement ...
            {mustBeSpecifiedLength(nativeUnit, 0, 1)}

        % Enter the identifier (IRI) of the related ontological term matching this coordinate space.
        ontologyIdentifier (1,1) string

        % Enter the date of first publication of this coordinate space.
        releaseDate (1,1) string

        % Enter a descriptive short name for this coordinate space.
        shortName (1,1) string

        % Enter the version identifier of this coordinate space.
        versionIdentifier (1,1) string
    end

    properties (Access = protected)
        Required = ["anatomicalAxesOrientation", "axesOrigin", "fullName", "nativeUnit", "releaseDate", "shortName", "versionIdentifier"]
    end

    properties (Constant, Hidden)
        X_TYPE = "https://openminds.ebrains.eu/sands/CoordinateSpace"
    end

    properties (Constant, Hidden)
        LINKED_PROPERTIES = struct(...
            'anatomicalAxesOrientation', "openminds.controlledterms.AnatomicalAxesOrientation", ...
            'axesOrigin', "openminds.core.QuantitativeValue", ...
            'defaultImage', "openminds.sands.Image", ...
            'digitalIdentifier', "openminds.core.DigitalIdentifier", ...
            'nativeUnit', "openminds.controlledterms.UnitOfMeasurement" ...
        )
        EMBEDDED_PROPERTIES = struct(...
        )
    end

    methods
        function obj = CoordinateSpace(varargin)
            obj@openminds.abstract.Schema(varargin{:})
        end
    end

    methods (Access = protected)
        function str = getDisplayLabel(obj)
            str = obj.fullName;
        end
    end

end