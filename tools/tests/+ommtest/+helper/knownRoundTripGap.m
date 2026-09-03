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

    if ismember(typeName, multiValuedControlledInstanceGap())
        reason = "Multi-valued properties linking to controlled instances " + ...
            "lose all but the first entry on reload.";

    elseif typeName == "TermSuggestion"
        reason = "addExistingTerminology is typed as an openMINDS type but " + ...
            "is not registered in LINKED_PROPERTIES, so it serializes inline " + ...
            "without a type or an identifier and cannot be read back. The " + ...
            "generated controlled term classes do not declare that constant " + ...
            "at all, so fixing it means changing the generator.";
    end
end

function typeNames = multiValuedControlledInstanceGap()
% Types holding a multi-valued property that links to controlled instances.
%
%   There is no clean structural predicate for these, because many types
%   with such a property round trip correctly, so they are listed
%   explicitly. Determined by sweeping every type through save and load.

    typeNames = [ ...
        "Accessibility", "AtlasAnnotation", "ChemicalSubstance", ...
        "ContentType", "CustomAnnotation", "DataAnalysis", "DataCopy", ...
        "DatasetVersion", "Dependency", "File", "FileBundle", ...
        "FilePathPattern", "GenericComputation", "LocalFile", ...
        "ModelValidation", "Optimization", "ParcellationTerminologyVersion", ...
        "QuantitativeRelationAssessment", "Setup", "Simulation", ...
        "SoftwareVersion", "SubjectGroup", "SubjectGroupState", ...
        "SubjectState", "TissueSample", "TissueSampleCollection", ...
        "TissueSampleCollectionState", "TissueSampleState", ...
        "ValidationTest", "Visualization"];
end
