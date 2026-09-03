classdef RoundTripTest < matlab.unittest.TestCase
% RoundTripTest - Verify openMINDS instances survive a JSON-LD round trip
%
%   Each type is populated with synthesized values, saved to JSON-LD,
%   loaded back, and saved again. The two documents must be equivalent.
%
%   Serialization stability, serialize(load(serialize(x))) == serialize(x),
%   is used as the round-trip property. It detects data loss without
%   requiring deep object comparison, and it fails loudly when a property
%   is silently dropped on either leg of the trip.
%
%   The type list is generated from openminds.enum.Types, so types added
%   to or removed from the model are covered without editing this file.
%   By default an evenly spaced sample of types runs; set the environment
%   variable OPENMINDS_TEST_ALL_TYPES to "1" for the full sweep.
%
%   Types with known library defects are listed in
%   ommtest.helper.knownRoundTripGap and are reported as incomplete rather
%   than failed, so this suite stays a usable regression gate while those
%   defects are outstanding. The synthesizer is still exercised for those
%   types, so a regression in the helper is caught regardless.
%
%   See also ommtest.helper.synthesizeInstance, ommtest.helper.knownRoundTripGap

    properties (TestParameter)
        % Automatically generate a test case for each metadata type
        MetadataType = ommtest.helper.roundTripTypeSelection();
    end

    properties (Access = private)
        TemporaryFolder (1,1) string
    end

    methods (TestClassSetup)
        function warmInstanceLibrary(~)
        % Build the controlled instance library once, with warnings off.
        %
        %   Loading the library emits warnings for instance folders that
        %   are not mapped to a type. They have no identifier, so they
        %   cannot be filtered selectively, and they would otherwise be
        %   repeated across the parameterized tests. The library is a
        %   session singleton, so warming it here keeps warnings enabled
        %   while the tests themselves run.

            warnState = warning('off', 'all');
            cleanupObj = onCleanup(@() warning(warnState));
            openminds.internal.InstanceLibrary.getSingleton();
        end
    end

    methods (TestMethodSetup)
        function createTemporaryFolder(testCase)
            import matlab.unittest.fixtures.TemporaryFolderFixture
            fixture = testCase.applyFixture(TemporaryFolderFixture);
            testCase.TemporaryFolder = string(fixture.Folder);
        end
    end

    methods (Test)
        function testJsonLdRoundTrip(testCase, MetadataType)
            className = string(openminds.enum.Types(MetadataType).ClassName);
            [instance, report] = ommtest.helper.synthesizeInstance(className);

            % Guard the test helper itself. A synthesizer that silently
            % stopped populating properties would make the round-trip
            % assertion below pass against empty instances. A handful of
            % types consist solely of properties constrained by a regular
            % expression, which the synthesizer does not attempt, so those
            % are skipped rather than treated as a regression.
            if testCase.hasOnlyPatternConstrainedProperties(report)
                testCase.assumeFail(sprintf( ...
                    ['Every property of "%s" is constrained by a regular ', ...
                     'expression, which the synthesizer does not generate ', ...
                     'values for.'], MetadataType));
            end

            testCase.verifyNotEmpty(report.Populated, ...
                sprintf('No property of "%s" could be populated. Skipped: %s', ...
                MetadataType, testCase.describeSkipped(report)));

            gapReason = ommtest.helper.knownRoundTripGap(MetadataType);
            testCase.assumeEqual(gapReason, "", ...
                sprintf('Known round-trip gap for "%s": %s', MetadataType, gapReason));

            firstDocument = testCase.saveToJsonLd(instance, "first.jsonld");

            reloaded = openminds.Collection(testCase.filePath("first.jsonld"));
            secondDocument = testCase.saveCollection(reloaded, "second.jsonld");

            testCase.verifyEqual( ...
                testCase.normalizeDocument(secondDocument), ...
                testCase.normalizeDocument(firstDocument), ...
                sprintf(['Round trip changed the serialized document for "%s". ', ...
                'A property was dropped or altered by save or load.'], MetadataType));
        end
    end

    methods (Access = private)
        function jsonText = saveToJsonLd(testCase, instance, fileName)
            collection = openminds.Collection(instance);
            jsonText = testCase.saveCollection(collection, fileName);
        end

        function jsonText = saveCollection(testCase, collection, fileName)
            targetPath = testCase.filePath(fileName);
            collection.save(targetPath);
            testCase.assertTrue(isfile(targetPath), ...
                sprintf('Saving the collection did not produce %s', targetPath))
            jsonText = string(fileread(targetPath));
        end

        function targetPath = filePath(testCase, fileName)
            targetPath = fullfile(testCase.TemporaryFolder, fileName);
        end
    end

    methods (Static, Access = private)
        function tf = hasOnlyPatternConstrainedProperties(report)
        % True when nothing was populated and every skip was a pattern.

            tf = isempty(report.Populated) ...
                && ~isempty(report.Skipped) ...
                && all(string({report.Skipped.Category}) == "PatternConstrained");
        end

        function description = describeSkipped(report)
        % Names of the properties the synthesizer could not populate.

            if isempty(report.Skipped)
                description = "<none>";
            else
                description = strjoin(string({report.Skipped.Property}), ", ");
            end
        end

        function lines = normalizeDocument(jsonText)
        % Compare document content independent of node order.
        %
        %   Nodes in a JSON-LD @graph are unordered, and the collection
        %   does not guarantee a stable order across a save and load
        %   cycle, so compare the set of lines rather than the raw text.

            lines = sort(string(splitlines(jsonText)));
            lines(strlength(strtrim(lines)) == 0) = [];
        end
    end
end
