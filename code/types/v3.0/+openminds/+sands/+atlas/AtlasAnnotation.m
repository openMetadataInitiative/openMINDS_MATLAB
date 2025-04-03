classdef AtlasAnnotation < openminds.abstract.Schema
%AtlasAnnotation - No description available.
%
%   PROPERTIES:
%
%   anchorPoint            : (1,:) <a href="matlab:help openminds.core.miscellaneous.QuantitativeValue" style="font-weight:bold">QuantitativeValue</a>
%                            Enter the coordinates of the anchor point for this annotation (e.g., its centroid in two dimensional space as [x, y] or in three dimensional space as [x, y, z]).
%
%   criteria               : (1,1) <a href="matlab:help openminds.core.research.ProtocolExecution" style="font-weight:bold">ProtocolExecution</a>
%                            Add the protocol execution defining the criteria that were applied to produce this annotation.
%
%   criteriaQualityType    : (1,1) <a href="matlab:help openminds.controlledterms.CriteriaQualityType" style="font-weight:bold">CriteriaQualityType</a>
%                            Add the quality type of the stated criteria used to define this annotation.
%
%   criteriaType           : (1,1) <a href="matlab:help openminds.controlledterms.AnnotationCriteriaType" style="font-weight:bold">AnnotationCriteriaType</a>
%                            Add the criteria type for this annotation.
%
%   inspiredBy             : (1,:) <a href="matlab:help openminds.core.data.File" style="font-weight:bold">File</a>
%                            Add all (source) files that inspired the definition of this annotation.
%
%   internalIdentifier     : (1,1) string
%                            Enter the identifier (or label) of this annotation that is used within the corresponding data files to identify this annotation.
%
%   laterality             : (1,:) <a href="matlab:help openminds.controlledterms.Laterality" style="font-weight:bold">Laterality</a>
%                            Add one or both sides of the body, bilateral organ or bilateral organ part that this annotation is defined in.
%
%   preferredVisualization : (1,1) <a href="matlab:help openminds.sands.miscellaneous.ViewerSpecification" style="font-weight:bold">ViewerSpecification</a>
%                            Add the preferred viewer specification to visualize this annotation.
%
%   specification          : (1,1) <a href="matlab:help openminds.core.data.File" style="font-weight:bold">File</a>
%                            Add the non-parametric specification of this annotation.
%
%   type                   : (1,1) <a href="matlab:help openminds.controlledterms.AnnotationType" style="font-weight:bold">AnnotationType</a>
%                            Add the geometry type of this annotation.

%   This class was auto-generated by the openMINDS pipeline

    properties
        % Enter the coordinates of the anchor point for this annotation (e.g., its centroid in two dimensional space as [x, y] or in three dimensional space as [x, y, z]).
        anchorPoint (1,:) openminds.core.miscellaneous.QuantitativeValue ...
            {mustBeSpecifiedLength(anchorPoint, 2, 3)}

        % Add the protocol execution defining the criteria that were applied to produce this annotation.
        criteria (1,:) openminds.core.research.ProtocolExecution ...
            {mustBeSpecifiedLength(criteria, 0, 1)}

        % Add the quality type of the stated criteria used to define this annotation.
        criteriaQualityType (1,:) openminds.controlledterms.CriteriaQualityType ...
            {mustBeSpecifiedLength(criteriaQualityType, 0, 1)}

        % Add the criteria type for this annotation.
        criteriaType (1,:) openminds.controlledterms.AnnotationCriteriaType ...
            {mustBeSpecifiedLength(criteriaType, 0, 1)}

        % Add all (source) files that inspired the definition of this annotation.
        inspiredBy (1,:) openminds.core.data.File ...
            {mustBeListOfUniqueItems(inspiredBy)}

        % Enter the identifier (or label) of this annotation that is used within the corresponding data files to identify this annotation.
        internalIdentifier (1,1) string

        % Add one or both sides of the body, bilateral organ or bilateral organ part that this annotation is defined in.
        laterality (1,:) openminds.controlledterms.Laterality ...
            {mustBeSpecifiedLength(laterality, 1, 2)}

        % Add the preferred viewer specification to visualize this annotation.
        preferredVisualization (1,:) openminds.sands.miscellaneous.ViewerSpecification ...
            {mustBeSpecifiedLength(preferredVisualization, 0, 1)}

        % Add the non-parametric specification of this annotation.
        specification (1,:) openminds.core.data.File ...
            {mustBeSpecifiedLength(specification, 0, 1)}

        % Add the geometry type of this annotation.
        type (1,:) openminds.controlledterms.AnnotationType ...
            {mustBeSpecifiedLength(type, 0, 1)}
    end

    properties (Access = protected)
        Required = ["criteriaQualityType", "criteriaType", "type"]
    end

    properties (Constant, Hidden)
        X_TYPE = "https://openminds.ebrains.eu/sands/AtlasAnnotation"
    end

    properties (Constant, Hidden)
        LINKED_PROPERTIES = struct(...
            'criteria', "openminds.core.research.ProtocolExecution", ...
            'criteriaQualityType', "openminds.controlledterms.CriteriaQualityType", ...
            'criteriaType', "openminds.controlledterms.AnnotationCriteriaType", ...
            'inspiredBy', "openminds.core.data.File", ...
            'laterality', "openminds.controlledterms.Laterality", ...
            'specification', "openminds.core.data.File", ...
            'type', "openminds.controlledterms.AnnotationType" ...
        )
        EMBEDDED_PROPERTIES = struct(...
            'anchorPoint', "openminds.core.miscellaneous.QuantitativeValue", ...
            'preferredVisualization', "openminds.sands.miscellaneous.ViewerSpecification" ...
        )
    end

    methods
        function obj = AtlasAnnotation(varargin)
            obj@openminds.abstract.Schema(varargin{:})
        end
    end

    methods (Access = protected)
        function str = getDisplayLabel(obj)
            str = obj.createLabelForMissingLabelDefinition();
        end
    end
end
