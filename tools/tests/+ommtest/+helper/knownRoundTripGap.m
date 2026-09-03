function reason = knownRoundTripGap(typeName)
%knownRoundTripGap Reason a type is not expected to survive a JSON-LD round trip
%
%   reason = ommtest.helper.knownRoundTripGap(typeName) returns a string
%   explaining why the given openMINDS type currently fails to round trip
%   through JSON-LD, or an empty string if the type is expected to succeed.
%
%   Every entry here is a defect in the library, not in the test. This list
%   is expected to shrink. When a fix lands, the corresponding entry must
%   be removed so the round-trip test starts guarding the fixed behaviour.
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

    if isControlledTermType(typeName)
        reason = "Controlled terms defined by the user lose every property " + ...
            "on reload. ControlledTermBase/initializeControlledTerm discards " + ...
            "the decoded struct and passes only the identifier to " + ...
            "deserializeFromName, which finds no matching controlled instance " + ...
            "and returns an empty object.";
        return
    end

    if ismember(typeName, residualGapTypes())
        reason = "Multi-valued properties linking to controlled instances " + ...
            "lose all but the first entry on reload.";
    end
end

function tf = isControlledTermType(typeName)
    className = openminds.enum.Types(typeName).ClassName;
    tf = any(ismember(superclasses(className), {'openminds.abstract.ControlledTerm'}));
end

function typeNames = residualGapTypes()
% Types that fail for reasons other than the controlled term defect.
%
%   Unlike the controlled term case there is no clean structural predicate
%   for these, so they are listed explicitly. Determined by sweeping every
%   type through save and load; see the round-trip test for the procedure.

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
