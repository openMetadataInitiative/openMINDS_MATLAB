classdef TissueSampleCollectionState < openminds.abstract.Schema
%TissueSampleCollectionState - No description available.
%
%   PROPERTIES:
%
%   additionalRemarks : (1,1) string
%                       Enter additional remarks about the specimen (set) in this state.
%
%   age               : (1,1) <a href="matlab:help openminds.core.miscellaneous.QuantitativeValue" style="font-weight:bold">QuantitativeValue</a>, <a href="matlab:help openminds.core.miscellaneous.QuantitativeValueRange" style="font-weight:bold">QuantitativeValueRange</a>
%                       Add the age of the specimen (set) in this state.
%
%   lookupLabel       : (1,1) string
%                       Enter a lookup label for this specimen (set) state that may help you to more easily find it again.
%
%   pathology         : (1,:) <a href="matlab:help openminds.controlledterms.Disease" style="font-weight:bold">Disease</a>, <a href="matlab:help openminds.controlledterms.DiseaseModel" style="font-weight:bold">DiseaseModel</a>
%                       Add the pathology of the specimen (set) in this state.
%
%   weight            : (1,1) <a href="matlab:help openminds.core.miscellaneous.QuantitativeValue" style="font-weight:bold">QuantitativeValue</a>, <a href="matlab:help openminds.core.miscellaneous.QuantitativeValueRange" style="font-weight:bold">QuantitativeValueRange</a>
%                       Add the weight of the specimen (set) in this state.

%   This class was auto-generated by the openMINDS pipeline

    properties
        % Enter additional remarks about the specimen (set) in this state.
        additionalRemarks (1,1) string

        % Add the age of the specimen (set) in this state.
        age (1,:) openminds.internal.mixedtype.tissuesamplecollectionstate.Age ...
            {mustBeSpecifiedLength(age, 0, 1)}

        % Enter a lookup label for this specimen (set) state that may help you to more easily find it again.
        lookupLabel (1,1) string

        % Add the pathology of the specimen (set) in this state.
        pathology (1,:) openminds.internal.mixedtype.tissuesamplecollectionstate.Pathology ...
            {mustBeListOfUniqueItems(pathology)}

        % Add the weight of the specimen (set) in this state.
        weight (1,:) openminds.internal.mixedtype.tissuesamplecollectionstate.Weight ...
            {mustBeSpecifiedLength(weight, 0, 1)}
    end

    properties (Access = protected)
        Required = []
    end

    properties (Constant, Hidden)
        X_TYPE = "https://openminds.ebrains.eu/core/TissueSampleCollectionState"
    end

    properties (Constant, Hidden)
        LINKED_PROPERTIES = struct(...
            'pathology', ["openminds.controlledterms.Disease", "openminds.controlledterms.DiseaseModel"] ...
        )
        EMBEDDED_PROPERTIES = struct(...
            'age', ["openminds.core.miscellaneous.QuantitativeValue", "openminds.core.miscellaneous.QuantitativeValueRange"], ...
            'weight', ["openminds.core.miscellaneous.QuantitativeValue", "openminds.core.miscellaneous.QuantitativeValueRange"] ...
        )
    end

    methods
        function obj = TissueSampleCollectionState(varargin)
            obj@openminds.abstract.Schema(varargin{:})
        end
    end

    methods (Access = protected)
        function str = getDisplayLabel(obj)
            str = sprintf('%s', obj.lookupLabel);
        end
    end
end
