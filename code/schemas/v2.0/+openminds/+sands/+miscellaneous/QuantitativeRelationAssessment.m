classdef QuantitativeRelationAssessment < openminds.abstract.Schema
%QuantitativeRelationAssessment - No description available.
%
%   PROPERTIES:
%
%   criteria            : (1,1) <a href="matlab:help openminds.core.research.ProtocolExecution" style="font-weight:bold">ProtocolExecution</a>
%                         Add the protocol execution defining the criteria that were applied to determine this relation.
%
%   inRelationTo        : (1,1) <a href="matlab:help openminds.sands.atlas.ParcellationEntity" style="font-weight:bold">ParcellationEntity</a>
%                         Add the anatomical entity to which the relation is described.
%
%   quantitativeOverlap : (1,1) <a href="matlab:help openminds.core.miscellaneous.QuantitativeValue" style="font-weight:bold">QuantitativeValue</a>, <a href="matlab:help openminds.core.miscellaneous.QuantitativeValueRange" style="font-weight:bold">QuantitativeValueRange</a>
%                         Add the quantitative overlap between the two anatomical entities preferably expressed in percentage.

%   This class was auto-generated by the openMINDS pipeline

    properties
        % Add the protocol execution defining the criteria that were applied to determine this relation.
        criteria (1,:) openminds.core.research.ProtocolExecution ...
            {mustBeSpecifiedLength(criteria, 0, 1)}

        % Add the anatomical entity to which the relation is described.
        inRelationTo (1,:) openminds.sands.atlas.ParcellationEntity ...
            {mustBeSpecifiedLength(inRelationTo, 0, 1)}

        % Add the quantitative overlap between the two anatomical entities preferably expressed in percentage.
        quantitativeOverlap (1,:) openminds.internal.mixedtype.quantitativerelationassessment.QuantitativeOverlap ...
            {mustBeSpecifiedLength(quantitativeOverlap, 0, 1)}
    end

    properties (Access = protected)
        Required = ["inRelationTo", "quantitativeOverlap"]
    end

    properties (Constant, Hidden)
        X_TYPE = "https://openminds.ebrains.eu/sands/QuantitativeRelationAssessment"
    end

    properties (Constant, Hidden)
        LINKED_PROPERTIES = struct(...
            'criteria', "openminds.core.research.ProtocolExecution", ...
            'inRelationTo', "openminds.sands.atlas.ParcellationEntity" ...
        )
        EMBEDDED_PROPERTIES = struct(...
            'quantitativeOverlap', ["openminds.core.miscellaneous.QuantitativeValue", "openminds.core.miscellaneous.QuantitativeValueRange"] ...
        )
    end

    methods
        function obj = QuantitativeRelationAssessment(varargin)
            obj@openminds.abstract.Schema(varargin{:})
        end
    end

    methods (Access = protected)
        function str = getDisplayLabel(obj)
            str = obj.createLabelForMissingLabelDefinition();
        end
    end
end
