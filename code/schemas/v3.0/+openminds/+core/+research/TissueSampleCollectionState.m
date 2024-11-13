classdef TissueSampleCollectionState < openminds.abstract.Schema
%TissueSampleCollectionState - No description available.
%
%   PROPERTIES:
%
%   additionalRemarks      : (1,1) string
%                            Enter any additional remarks concering the specimen (set) in this state.
%
%   age                    : (1,1) <a href="matlab:help openminds.core.miscellaneous.QuantitativeValue" style="font-weight:bold">QuantitativeValue</a>, <a href="matlab:help openminds.core.miscellaneous.QuantitativeValueRange" style="font-weight:bold">QuantitativeValueRange</a>
%                            Enter the age of the specimen (set) in this state.
%
%   attribute              : (1,:) <a href="matlab:help openminds.controlledterms.TissueSampleAttribute" style="font-weight:bold">TissueSampleAttribute</a>
%                            Add all attributes that can be ascribed to this tissue sample collection state.
%
%   descendedFrom          : (1,:) <a href="matlab:help openminds.core.research.SubjectGroupState" style="font-weight:bold">SubjectGroupState</a>, <a href="matlab:help openminds.core.research.SubjectState" style="font-weight:bold">SubjectState</a>, <a href="matlab:help openminds.core.research.TissueSampleCollectionState" style="font-weight:bold">TissueSampleCollectionState</a>, <a href="matlab:help openminds.core.research.TissueSampleState" style="font-weight:bold">TissueSampleState</a>
%                            Add all specimen states used to produce or obtain this tissue sample collection state.
%
%   internalIdentifier     : (1,1) string
%                            Enter the identifier (or label) of this specimen (set) state that is used within the corresponding data files to identify this specimen (set) state.
%
%   lookupLabel            : (1,1) string
%                            Enter a lookup label for this specimen (set) state that may help you to find this instance more easily.
%
%   pathology              : (1,:) <a href="matlab:help openminds.controlledterms.Disease" style="font-weight:bold">Disease</a>, <a href="matlab:help openminds.controlledterms.DiseaseModel" style="font-weight:bold">DiseaseModel</a>
%                            Add all (human) diseases and/or conditions that the specimen (set) in this state has and/or is a model for.
%
%   relativeTimeIndication : (1,1) <a href="matlab:help openminds.core.miscellaneous.QuantitativeValue" style="font-weight:bold">QuantitativeValue</a>, <a href="matlab:help openminds.core.miscellaneous.QuantitativeValueRange" style="font-weight:bold">QuantitativeValueRange</a>
%                            If there is a temporal relation between the states of a specimen (set), enter the relative time that has passed between this and the preceding specimen (set) state referenced under 'descendedFrom'.
%
%   weight                 : (1,1) <a href="matlab:help openminds.core.miscellaneous.QuantitativeValue" style="font-weight:bold">QuantitativeValue</a>, <a href="matlab:help openminds.core.miscellaneous.QuantitativeValueRange" style="font-weight:bold">QuantitativeValueRange</a>
%                            Enter the weight of the specimen (set) in this state.

%   This class was auto-generated by the openMINDS pipeline

    properties
        % Enter any additional remarks concering the specimen (set) in this state.
        additionalRemarks (1,1) string

        % Enter the age of the specimen (set) in this state.
        age (1,:) openminds.internal.mixedtype.tissuesamplecollectionstate.Age ...
            {mustBeSpecifiedLength(age, 0, 1)}

        % Add all attributes that can be ascribed to this tissue sample collection state.
        attribute (1,:) openminds.controlledterms.TissueSampleAttribute ...
            {mustBeListOfUniqueItems(attribute)}

        % Add all specimen states used to produce or obtain this tissue sample collection state.
        descendedFrom (1,:) openminds.internal.mixedtype.tissuesamplecollectionstate.DescendedFrom ...
            {mustBeListOfUniqueItems(descendedFrom)}

        % Enter the identifier (or label) of this specimen (set) state that is used within the corresponding data files to identify this specimen (set) state.
        internalIdentifier (1,1) string

        % Enter a lookup label for this specimen (set) state that may help you to find this instance more easily.
        lookupLabel (1,1) string

        % Add all (human) diseases and/or conditions that the specimen (set) in this state has and/or is a model for.
        pathology (1,:) openminds.internal.mixedtype.tissuesamplecollectionstate.Pathology ...
            {mustBeListOfUniqueItems(pathology)}

        % If there is a temporal relation between the states of a specimen (set), enter the relative time that has passed between this and the preceding specimen (set) state referenced under 'descendedFrom'.
        relativeTimeIndication (1,:) openminds.internal.mixedtype.tissuesamplecollectionstate.RelativeTimeIndication ...
            {mustBeSpecifiedLength(relativeTimeIndication, 0, 1)}

        % Enter the weight of the specimen (set) in this state.
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
            'attribute', "openminds.controlledterms.TissueSampleAttribute", ...
            'descendedFrom', ["openminds.core.research.SubjectGroupState", "openminds.core.research.SubjectState", "openminds.core.research.TissueSampleCollectionState", "openminds.core.research.TissueSampleState"], ...
            'pathology', ["openminds.controlledterms.Disease", "openminds.controlledterms.DiseaseModel"] ...
        )
        EMBEDDED_PROPERTIES = struct(...
            'age', ["openminds.core.miscellaneous.QuantitativeValue", "openminds.core.miscellaneous.QuantitativeValueRange"], ...
            'relativeTimeIndication', ["openminds.core.miscellaneous.QuantitativeValue", "openminds.core.miscellaneous.QuantitativeValueRange"], ...
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