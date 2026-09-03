function reason = knownRoundTripGap(typeName)
%knownRoundTripGap Reason a type is not expected to survive a JSON-LD round trip
%
%   reason = ommtest.helper.knownRoundTripGap(typeName) returns a string
%   explaining why the given openMINDS type currently fails to round trip
%   through JSON-LD, or an empty string if the type is expected to succeed.
%
%   Every entry here is a defect, not a property of the test. This list is
%   expected to shrink. When a fix lands, the corresponding entry must be
%   removed so the round-trip test starts guarding the fixed behaviour.
%
%   Input Arguments:
%     typeName - Short name of an openMINDS type, e.g. "Person".
%
%   Output Arguments:
%     reason - Explanation of the gap, or "" if the type should round trip.
%
%   See also ommtest.helper.synthesizeInstance

    arguments
        typeName (1,1) string
    end

    reason = "";

    if ismember(typeName, ["ParcellationTerminologyVersion", "QuantitativeRelationAssessment"])
        reason = "Serializing a property that holds an unresolved " + ...
            "MixedTypeReference fails, because the meta type registry does " + ...
            "not recognise it as a metadata type.";

    elseif typeName == "ChemicalSubstance"
        reason = "A controlled instance whose name contains characters that " + ...
            "are not valid in a MATLAB identifier cannot be looked up from a " + ...
            "bare reference, so it reloads as an empty term with a new " + ...
            "blank node identifier.";

    elseif typeName == "TermSuggestion"
        reason = "addExistingTerminology is typed as an openMINDS type but " + ...
            "is not registered in LINKED_PROPERTIES, so it serializes inline " + ...
            "without a type or an identifier and cannot be read back. The " + ...
            "generated controlled term classes do not declare that constant " + ...
            "at all, so fixing it means changing the generator.";
    end
end
