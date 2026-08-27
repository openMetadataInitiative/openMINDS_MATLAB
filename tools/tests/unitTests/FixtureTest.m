classdef FixtureTest < matlab.unittest.TestCase
% FixtureTest - Verify openMINDS reads and writes stable JSON-LD documents
%
%   These tests compare against golden JSON-LD files checked into
%   tools/tests/fixtures. Unlike the round-trip test, which only checks
%   that the library agrees with itself, these pin the actual document
%   format, so a change in serialized output has to be reviewed rather
%   than silently accepted.
%
%   The fixture content is defined once in
%   ommtest.helper.buildFixtureCollection and the golden files are
%   generated from it by ommtest.helper.regenerateFixtures. Refreshing
%   fixtures after a model version bump is one command plus a diff review.
%
%   See also ommtest.helper.buildFixtureCollection, ommtest.helper.regenerateFixtures

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
        function testGoldenFixtureExists(testCase)
            testCase.assertTrue(isfile(testCase.goldenFixturePath()), ...
                sprintf(['Golden fixture is missing: %s\n', ...
                'Generate it with ommtest.helper.regenerateFixtures.'], ...
                testCase.goldenFixturePath()))
        end

        function testSerializedOutputMatchesGoldenFixture(testCase)
        % The document the library produces today must match the document
        % that was reviewed and committed.

            testCase.assumeTrue(isfile(testCase.goldenFixturePath()))

            collection = ommtest.helper.buildFixtureCollection();
            producedPath = fullfile(testCase.TemporaryFolder, "produced.jsonld");
            collection.save(producedPath);

            produced = string(fileread(producedPath));
            golden = string(fileread(testCase.goldenFixturePath()));

            testCase.verifyEqual(produced, golden, ...
                ['Serialized output no longer matches the golden fixture. ', ...
                'If the change is intended, regenerate the fixture with ', ...
                'ommtest.helper.regenerateFixtures and review the diff.'])
        end

        function testGoldenFixtureLoadsWithValuesIntact(testCase)
        % Loading the golden document must reproduce the original values,
        % including a linked instance and a controlled instance reference.

            testCase.assumeTrue(isfile(testCase.goldenFixturePath()))

            collection = openminds.Collection(testCase.goldenFixturePath());

            person = collection.list(openminds.enum.Types("Person"));
            testCase.assertNumElements(person, 1, ...
                'Expected exactly one Person in the fixture collection.')
            testCase.verifyEqual(person.givenName, "Ada")
            testCase.verifyEqual(person.familyName, "Lovelace")
            testCase.verifyEqual(person.alternateName, ["A. Lovelace", "Ada L."])

            contactInformation = person.contactInformation;
            testCase.assertNumElements(contactInformation, 1, ...
                'The linked ContactInformation was not resolved on load.')
            testCase.verifyEqual(contactInformation.email, "ada@example.org")

            subject = collection.list(openminds.enum.Types("Subject"));
            testCase.assertNumElements(subject, 1, ...
                'Expected exactly one Subject in the fixture collection.')
            testCase.verifyEqual(subject.lookupLabel, "fixtureSubject")
            testCase.verifyEqual(string(subject.species.id), ...
                "https://openminds.om-i.org/instances/species/homoSapiens")
        end

        function testLegacyNamespaceDocumentIsRejectedClearly(testCase)
        % A document written with the pre-v4 EBRAINS namespace cannot be
        % loaded while a v4 model is active.
        %
        %   This pins current behaviour: the failure is a clear, identified
        %   error rather than silent data loss. Supporting cross-namespace
        %   loading would be an improvement, and this test must then be
        %   changed to assert that the document loads.

            legacyPath = fullfile(ommtest.helper.fixturePath(), ...
                "collection_ebrains_legacy.jsonld");
            testCase.assumeTrue(isfile(legacyPath))
            testCase.assumeEqual(ommtest.helper.fixtureNamespaceTag(), "omi", ...
                'This test only applies while a v4 or later model is active.')

            testCase.verifyError(@() openminds.Collection(legacyPath), ...
                'OPENMINDS_MATLAB:Types:InvalidAtType', ...
                ['Loading a legacy namespace document should fail with a ', ...
                'clear error identifying the namespace mismatch.'])
        end
    end

    methods (Access = private)
        function fixtureFilePath = goldenFixturePath(~)
            fileName = "collection_" + ommtest.helper.fixtureNamespaceTag() + ".jsonld";
            fixtureFilePath = fullfile(ommtest.helper.fixturePath(), fileName);
        end
    end
end
