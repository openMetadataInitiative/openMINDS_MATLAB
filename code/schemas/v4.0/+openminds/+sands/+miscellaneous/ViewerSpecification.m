classdef ViewerSpecification < openminds.abstract.Schema
%ViewerSpecification - No description available.
%
%   PROPERTIES:
%
%   additionalRemarks     : (1,1) string
%                           Enter any additional remarks concerning this viewer specification.
%
%   anchorPoint           : (1,:) <a href="matlab:help openminds.core.miscellaneous.QuantitativeValue" style="font-weight:bold">QuantitativeValue</a>
%                           Enter the coordinates of the anchor point that a viewer should use. Either state the anchor point of the annotation again or state another coordinate point.
%
%   cameraPosition        : (1,1) <a href="matlab:help openminds.sands.miscellaneous.CoordinatePoint" style="font-weight:bold">CoordinatePoint</a>
%                           Enter the camera position that a viewer should use.
%
%   preferredDisplayColor : (1,1) <a href="matlab:help openminds.controlledterms.Colormap" style="font-weight:bold">Colormap</a>, <a href="matlab:help openminds.sands.miscellaneous.SingleColor" style="font-weight:bold">SingleColor</a>
%                           Add the preferred color that a viewer should display.

%   This class was auto-generated by the openMINDS pipeline

    properties
        % Enter any additional remarks concerning this viewer specification.
        additionalRemarks (1,1) string

        % Enter the coordinates of the anchor point that a viewer should use. Either state the anchor point of the annotation again or state another coordinate point.
        anchorPoint (1,:) openminds.core.miscellaneous.QuantitativeValue ...
            {mustBeSpecifiedLength(anchorPoint, 2, 3)}

        % Enter the camera position that a viewer should use.
        cameraPosition (1,:) openminds.sands.miscellaneous.CoordinatePoint ...
            {mustBeSpecifiedLength(cameraPosition, 0, 1)}

        % Add the preferred color that a viewer should display.
        preferredDisplayColor (1,:) openminds.internal.mixedtype.viewerspecification.PreferredDisplayColor ...
            {mustBeSpecifiedLength(preferredDisplayColor, 0, 1)}
    end

    properties (Access = protected)
        Required = ["anchorPoint"]
    end

    properties (Constant, Hidden)
        X_TYPE = "https://openminds.om-i.org/types/ViewerSpecification"
    end

    properties (Constant, Hidden)
        LINKED_PROPERTIES = struct(...
            'preferredDisplayColor', ["openminds.controlledterms.Colormap", "openminds.sands.miscellaneous.SingleColor"] ...
        )
        EMBEDDED_PROPERTIES = struct(...
            'anchorPoint', "openminds.core.miscellaneous.QuantitativeValue", ...
            'cameraPosition', "openminds.sands.miscellaneous.CoordinatePoint" ...
        )
    end

    methods
        function obj = ViewerSpecification(varargin)
            obj@openminds.abstract.Schema(varargin{:})
        end
    end

    methods (Access = protected)
        function str = getDisplayLabel(obj)
            str = obj.createLabelForMissingLabelDefinition();
        end
    end
end