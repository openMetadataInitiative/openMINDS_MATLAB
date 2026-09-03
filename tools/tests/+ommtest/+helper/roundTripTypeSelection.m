function typeNames = roundTripTypeSelection()
%roundTripTypeSelection Types to exercise in the JSON-LD round-trip test
%
%   typeNames = ommtest.helper.roundTripTypeSelection() returns a cell
%   array of openMINDS type names to run the round-trip test against.
%
%   Round tripping every type takes several minutes, which is too slow for
%   a per-commit test run. By default this returns an evenly spaced sample
%   of the model, which gives fast regression signal on every commit. Set
%   the environment variable OPENMINDS_TEST_ALL_TYPES to "1" to return
%   every type instead, for scheduled runs and for the schema rebuild
%   pipeline.
%
%   The sample is a fixed stride through the type list rather than a
%   curated set, so it needs no maintenance as the model changes and it
%   still spans the breadth of the model.
%
%   Output Arguments:
%     typeNames - Cell array of type names, for use as a TestParameter.

    allTypeNames = string(cellstr(enumeration('openminds.enum.Types')));
    allTypeNames(allTypeNames == "None") = [];
    allTypeNames = sort(allTypeNames);

    if isFullSweepRequested()
        typeNames = cellstr(allTypeNames);
        return
    end

    numSampled = 30;
    stride = max(1, floor(numel(allTypeNames) / numSampled));
    typeNames = cellstr(allTypeNames(1:stride:end));
end

function tf = isFullSweepRequested()
    tf = strcmp(getenv('OPENMINDS_TEST_ALL_TYPES'), '1');
end
