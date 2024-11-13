classdef SubjectState < openminds.abstract.Schema
%SubjectState - Structured information on a temporary state of a subject.
%
%   PROPERTIES:
%
%   additionalRemarks      : (1,1) string
%                            Enter any additional remarks concerning the specimen (set) in this state.
%
%   age                    : (1,1) <a href="matlab:help openminds.core.miscellaneous.QuantitativeValue" style="font-weight:bold">QuantitativeValue</a>, <a href="matlab:help openminds.core.miscellaneous.QuantitativeValueRange" style="font-weight:bold">QuantitativeValueRange</a>
%                            Enter the age of the specimen (set) in this state.
%
%   ageCategory            : (1,1) <a href="matlab:help openminds.controlledterms.AgeCategory" style="font-weight:bold">AgeCategory</a>
%                            Add the age category of the subject in this state.
%
%   attribute              : (1,:) <a href="matlab:help openminds.controlledterms.SubjectAttribute" style="font-weight:bold">SubjectAttribute</a>
%                            Add all attributes that can be ascribed to this subject state.
%
%   descendedFrom          : (1,1) <a href="matlab:help openminds.core.research.SubjectState" style="font-weight:bold">SubjectState</a>
%                            Add the previous subject state.
%
%   handedness             : (1,1) <a href="matlab:help openminds.controlledterms.Handedness" style="font-weight:bold">Handedness</a>
%                            Add the preferred handedness of the subject in this state.
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
        % Enter any additional remarks concerning the specimen (set) in this state.
        additionalRemarks (1,1) string

        % Enter the age of the specimen (set) in this state.
        age (1,:) openminds.internal.mixedtype.subjectstate.Age ...
            {mustBeSpecifiedLength(age, 0, 1)}

        % Add the age category of the subject in this state.
        ageCategory (1,:) openminds.controlledterms.AgeCategory ...
            {mustBeSpecifiedLength(ageCategory, 0, 1)}

        % Add all attributes that can be ascribed to this subject state.
        attribute (1,:) openminds.controlledterms.SubjectAttribute ...
            {mustBeListOfUniqueItems(attribute)}

        % Add the previous subject state.
        descendedFrom (1,:) openminds.core.research.SubjectState ...
            {mustBeSpecifiedLength(descendedFrom, 0, 1)}

        % Add the preferred handedness of the subject in this state.
        handedness (1,:) openminds.controlledterms.Handedness ...
            {mustBeSpecifiedLength(handedness, 0, 1)}

        % Enter the identifier (or label) of this specimen (set) state that is used within the corresponding data files to identify this specimen (set) state.
        internalIdentifier (1,1) string

        % Enter a lookup label for this specimen (set) state that may help you to find this instance more easily.
        lookupLabel (1,1) string

        % Add all (human) diseases and/or conditions that the specimen (set) in this state has and/or is a model for.
        pathology (1,:) openminds.internal.mixedtype.subjectstate.Pathology ...
            {mustBeListOfUniqueItems(pathology)}

        % If there is a temporal relation between the states of a specimen (set), enter the relative time that has passed between this and the preceding specimen (set) state referenced under 'descendedFrom'.
        relativeTimeIndication (1,:) openminds.internal.mixedtype.subjectstate.RelativeTimeIndication ...
            {mustBeSpecifiedLength(relativeTimeIndication, 0, 1)}

        % Enter the weight of the specimen (set) in this state.
        weight (1,:) openminds.internal.mixedtype.subjectstate.Weight ...
            {mustBeSpecifiedLength(weight, 0, 1)}
    end

    properties (Access = protected)
        Required = ["ageCategory"]
    end

    properties (Constant, Hidden)
        X_TYPE = "https://openminds.om-i.org/types/SubjectState"
    end

    properties (Constant, Hidden)
        LINKED_PROPERTIES = struct(...
            'ageCategory', "openminds.controlledterms.AgeCategory", ...
            'attribute', "openminds.controlledterms.SubjectAttribute", ...
            'descendedFrom', "openminds.core.research.SubjectState", ...
            'handedness', "openminds.controlledterms.Handedness", ...
            'pathology', ["openminds.controlledterms.Disease", "openminds.controlledterms.DiseaseModel"] ...
        )
        EMBEDDED_PROPERTIES = struct(...
            'age', ["openminds.core.miscellaneous.QuantitativeValue", "openminds.core.miscellaneous.QuantitativeValueRange"], ...
            'relativeTimeIndication', ["openminds.core.miscellaneous.QuantitativeValue", "openminds.core.miscellaneous.QuantitativeValueRange"], ...
            'weight', ["openminds.core.miscellaneous.QuantitativeValue", "openminds.core.miscellaneous.QuantitativeValueRange"] ...
        )
    end

    methods
        function obj = SubjectState(varargin)
            obj@openminds.abstract.Schema(varargin{:})
        end
    end

    methods (Access = protected)
        function str = getDisplayLabel(obj)
            str = sprintf('%s', obj.lookupLabel);
        end
    end
end