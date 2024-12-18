classdef AtlasAnnotation < openminds.abstract.Schema
%AtlasAnnotation - No description available.
%
%   PROPERTIES:
%
%   bestViewPoint       : (1,1) <a href="matlab:help openminds.sands.miscellaneous.CoordinatePoint" style="font-weight:bold">CoordinatePoint</a>
%                         Add the coordinate point identifying the best view of this atlas annotation in space.
%
%   criteria            : (1,1) <a href="matlab:help openminds.core.research.ProtocolExecution" style="font-weight:bold">ProtocolExecution</a>
%                         Add the protocol execution defining the criteria that were applied to produce this atlas annotation.
%
%   criteriaQualityType : (1,1) <a href="matlab:help openminds.controlledterms.CriteriaQualityType" style="font-weight:bold">CriteriaQualityType</a>
%                         Add the quality type of the stated criteria used to define this atlas annotation.
%
%   displayColor        : (1,1) string
%                         Enter the preferred display color (HEX) for this atlas annotation.
%
%   inspiredBy          : (1,:) <a href="matlab:help openminds.core.data.File" style="font-weight:bold">File</a>
%                         Add one or several (source) files that inspired the definition of this atlas annotation.
%
%   internalIdentifier  : (1,1) string
%                         Enter the identifier used for this annotation within the file it is stored in.
%
%   laterality          : (1,:) <a href="matlab:help openminds.controlledterms.Laterality" style="font-weight:bold">Laterality</a>
%                         Add one or both sides of the body, bilateral organ or bilateral organ part that this atlas annotation is defined in.
%
%   lookupLabel         : (1,1) string
%                         Enter a lookup label for this atlas annotation that may help you to more easily find it again.
%
%   name                : (1,1) string
%                         Enter a descriptive name for this atlas annotation.
%
%   versionIdentifier   : (1,1) string
%                         Enter the version identifier of this atlas annotation.
%
%   versionInnovation   : (1,1) string
%                         Enter a short description of the novelties/peculiarities of this atlas annotation.
%
%   visualizedIn        : (1,1) <a href="matlab:help openminds.core.data.File" style="font-weight:bold">File</a>
%                         Add the (source) image file in which this atlas annotation is visualized in.

%   This class was auto-generated by the openMINDS pipeline

    properties
        % Add the coordinate point identifying the best view of this atlas annotation in space.
        bestViewPoint (1,:) openminds.sands.miscellaneous.CoordinatePoint ...
            {mustBeSpecifiedLength(bestViewPoint, 0, 1)}

        % Add the protocol execution defining the criteria that were applied to produce this atlas annotation.
        criteria (1,:) openminds.core.research.ProtocolExecution ...
            {mustBeSpecifiedLength(criteria, 0, 1)}

        % Add the quality type of the stated criteria used to define this atlas annotation.
        criteriaQualityType (1,:) openminds.controlledterms.CriteriaQualityType ...
            {mustBeSpecifiedLength(criteriaQualityType, 0, 1)}

        % Enter the preferred display color (HEX) for this atlas annotation.
        displayColor (1,1) string ...
            {mustMatchPattern(displayColor, '^#[0-9A-Fa-f]{6}$')}

        % Add one or several (source) files that inspired the definition of this atlas annotation.
        inspiredBy (1,:) openminds.core.data.File ...
            {mustBeListOfUniqueItems(inspiredBy)}

        % Enter the identifier used for this annotation within the file it is stored in.
        internalIdentifier (1,1) string

        % Add one or both sides of the body, bilateral organ or bilateral organ part that this atlas annotation is defined in.
        laterality (1,:) openminds.controlledterms.Laterality ...
            {mustBeSpecifiedLength(laterality, 1, 2)}

        % Enter a lookup label for this atlas annotation that may help you to more easily find it again.
        lookupLabel (1,1) string

        % Enter a descriptive name for this atlas annotation.
        name (1,1) string

        % Enter the version identifier of this atlas annotation.
        versionIdentifier (1,1) string

        % Enter a short description of the novelties/peculiarities of this atlas annotation.
        versionInnovation (1,1) string

        % Add the (source) image file in which this atlas annotation is visualized in.
        visualizedIn (1,:) openminds.core.data.File ...
            {mustBeSpecifiedLength(visualizedIn, 0, 1)}
    end

    properties (Access = protected)
        Required = ["criteriaQualityType", "internalIdentifier", "versionIdentifier", "versionInnovation"]
    end

    properties (Constant, Hidden)
        X_TYPE = "https://openminds.ebrains.eu/sands/AtlasAnnotation"
    end

    properties (Constant, Hidden)
        LINKED_PROPERTIES = struct(...
            'criteria', "openminds.core.research.ProtocolExecution", ...
            'criteriaQualityType', "openminds.controlledterms.CriteriaQualityType", ...
            'inspiredBy', "openminds.core.data.File", ...
            'laterality', "openminds.controlledterms.Laterality", ...
            'visualizedIn', "openminds.core.data.File" ...
        )
        EMBEDDED_PROPERTIES = struct(...
            'bestViewPoint', "openminds.sands.miscellaneous.CoordinatePoint" ...
        )
    end

    methods
        function obj = AtlasAnnotation(varargin)
            obj@openminds.abstract.Schema(varargin{:})
        end
    end

    methods (Access = protected)
        function str = getDisplayLabel(obj)
            str = obj.lookupLabel;
        end
    end
end
