classdef ControlledTermTest < matlab.unittest.TestCase

    methods (Test)
        function testKnownInstanceCreatesLightweightReference(testCase)
            term = testCase.verifyWarningFree( ...
                @() openminds.controlledterms.ContributionType("authoring"));

            testCase.verifyEqual(term.name, "authoring")
            testCase.verifyEqual(term.id, ...
                openminds.constant.BaseIRI + "/instances/contributionType/authoring")
        end

        function testInstanceIriFromAnotherSchemaVersionResolves(testCase)
        % An instance IRI carries a version specific namespace, but names
        % the same instance in every version that has it. Before, only the
        % active namespace was recognized as an IRI here, so the other one
        % fell through to isfile - which reports true for a URL when the
        % network is up - and then into the unimplemented load method.

            legacyIRI = "https://openminds.ebrains.eu/instances/contributionType/authoring";

            term = testCase.verifyWarningFree( ...
                @() openminds.controlledterms.ContributionType(legacyIRI));

            testCase.verifyEqual(term.name, "authoring")
        end

        function testInstanceIriFromAnotherSchemaVersionIsNormalized(testCase)
        % A term found in the library takes the library's identifier for
        % the active schema version. The IRI the caller gave only located
        % it, so the same instance does not end up with two identities
        % depending on which version's IRI was used to name it.

            legacyIRI = "https://openminds.ebrains.eu/instances/contributionType/authoring";

            term = openminds.controlledterms.ContributionType(legacyIRI);

            testCase.verifyEqual(term.id, ...
                openminds.constant.BaseIRI + "/instances/contributionType/authoring")
        end

        function testInstanceIriWithNonCanonicalCaseIsCanonicalized(testCase)
        % The library is matched case insensitively, so an IRI differing
        % only in case names the same instance and must resolve to the
        % same identifier as the canonical spelling.

            term = openminds.controlledterms.ContributionType( ...
                openminds.constant.BaseIRI + "/instances/contributionType/Authoring");

            testCase.verifyEqual(term.name, "authoring")
            testCase.verifyEqual(term.id, ...
                openminds.constant.BaseIRI + "/instances/contributionType/authoring")
        end

        function testBareReferenceFromAnotherSchemaVersionIsNormalized(testCase)
        % The route a deserializer takes: a reference carrying nothing but
        % an identifier. It resolves through the library like a name, so
        % it takes the library's identifier too.

            reference = struct('at_id', ...
                "https://openminds.ebrains.eu/instances/laterality/left");

            term = openminds.controlledterms.Laterality(reference);

            testCase.verifyEqual(term.name, "left")
            testCase.verifyEqual(term.id, ...
                openminds.constant.BaseIRI + "/instances/laterality/left")
        end

        function testTermIsReadFromAJsonLdDocument(testCase)
        % A controlled term document describes one term, so it reads into
        % a single instance. Previously this reached an unimplemented load
        % method and failed with MATLAB:noSuchMethodOrField.

            import matlab.unittest.fixtures.TemporaryFolderFixture
            folder = testCase.applyFixture(TemporaryFolderFixture).Folder;
            filePath = fullfile(folder, "aTerm.jsonld");
            document = [ ...
                '{"@id": "_:aTerm",' ...
                ' "@type": "https://openminds.om-i.org/types/Species",' ...
                ' "name": "A term read from a document",' ...
                ' "definition": "Its values come from the file, not the library."}'];
            fid = fopen(filePath, "wt");
            fwrite(fid, document);
            fclose(fid);

            term = openminds.controlledterms.Species(filePath);

            testCase.verifyEqual(term.name, "A term read from a document")
            testCase.verifyEqual(term.definition, ...
                "Its values come from the file, not the library.")
            testCase.verifyEqual(string(term.id), "_:aTerm")
        end

        function testDocumentOfAnotherTypeIsRejected(testCase)
            import matlab.unittest.fixtures.TemporaryFolderFixture
            folder = testCase.applyFixture(TemporaryFolderFixture).Folder;
            filePath = fullfile(folder, "aTerm.jsonld");
            fid = fopen(filePath, "wt");
            fwrite(fid, [ ...
                '{"@id": "_:aTerm",' ...
                ' "@type": "https://openminds.om-i.org/types/Laterality",' ...
                ' "name": "left"}']);
            fclose(fid);

            testCase.verifyError( ...
                @() openminds.controlledterms.Species(filePath), ...
                'openMINDS:ControlledTerm:TypeMismatch')
        end

        function testANameIsNotTakenForAFile(testCase)
        % The file system must not decide what a name means. Without an
        % extension being required, a file called "male" in the working
        % directory would change what BiologicalSex("male") returns,
        % silently and only on that machine.

            import matlab.unittest.fixtures.TemporaryFolderFixture
            import matlab.unittest.fixtures.CurrentFolderFixture
            folder = testCase.applyFixture(TemporaryFolderFixture).Folder;
            fid = fopen(fullfile(folder, "male"), "wt");
            fwrite(fid, 'not a document');
            fclose(fid);
            testCase.applyFixture(CurrentFolderFixture(folder));

            term = openminds.controlledterms.BiologicalSex("male");

            testCase.verifyEqual(term.name, "male")
        end

        function testUrlIsNotTakenForAFile(testCase)
        % isfile resolves a URL over the network, so a URL is ruled out
        % before the file system is consulted. An IRI that is not an
        % openMINDS one is kept as the identifier, as it was before.

            url = "https://example.org/not/an/instance";

            term = testCase.verifyWarningFree( ...
                @() openminds.controlledterms.Species(url));

            testCase.verifyEqual(string(term.id), url)
        end

        function testUserDefinedTermSurvivesDeserialization(testCase)
        % A controlled term defined by a user is not in the controlled
        % instance library, so there is nothing to look it up by. Its
        % values have to be taken from the document it was read from.

            structure = struct( ...
                'at_id', "_:a-user-defined-term", ...
                'at_type', "https://openminds.om-i.org/types/Species", ...
                'name', "Novel species", ...
                'definition', "A species that is not in the library.", ...
                'synonym', {{'first synonym', 'second synonym'}});

            term = openminds.controlledterms.Species(structure);

            testCase.verifyEqual(term.name, "Novel species")
            testCase.verifyEqual(term.definition, "A species that is not in the library.")
            testCase.verifyEqual(term.synonym, ["first synonym", "second synonym"])
            testCase.verifyEqual(string(term.id), "_:a-user-defined-term")
        end

        function testStructArrayProducesOneTermPerElement(testCase)
        % A multi-valued property deserializes to a struct array of
        % references. Each element must become its own term, or every
        % entry after the first is lost.

            references = struct('at_id', { ...
                "https://openminds.om-i.org/instances/laterality/left", ...
                "https://openminds.om-i.org/instances/laterality/right"});

            terms = openminds.controlledterms.Laterality(references);

            testCase.assertNumElements(terms, 2)
            testCase.verifyEqual(string(terms(1).id), ...
                "https://openminds.om-i.org/instances/laterality/left")
            testCase.verifyEqual(string(terms(2).id), ...
                "https://openminds.om-i.org/instances/laterality/right")
        end

        function testMultiValuedControlledPropertyKeepsEveryEntry(testCase)
        % The same case reached through a property rather than the
        % constructor, which is how deserialization gets there.

            references = struct('at_id', { ...
                "https://openminds.om-i.org/instances/laterality/left", ...
                "https://openminds.om-i.org/instances/laterality/right"});

            annotation = openminds.sands.AtlasAnnotation();
            annotation.laterality = references;

            testCase.verifyNumElements(annotation.laterality, 2)
        end

        function testReferenceToKnownTermIsLookedUp(testCase)
        % A document carrying only an identifier describes nothing, so the
        % term is populated from the controlled instance library instead.

            structure = struct( ...
                'at_id', "https://openminds.om-i.org/instances/species/homoSapiens");

            term = openminds.controlledterms.Species(structure);

            testCase.verifyEqual(term.name, "Homo sapiens")
            testCase.verifyNotEmpty(term.definition)
        end

        function testOlderControlledTermPropertiesAreAccepted(testCase)
            % v4.0 is a model version whose controlled terms carry the older
            % property set. Its base class is generated with that version.
            sourceText = fileread(testCase.getControlledTermBasePath("v4.0"));

            testCase.verifyTrue(contains(sourceText, "interlexIdentifier"))
            testCase.verifyTrue(contains(sourceText, "knowledgeSpaceLink"))
            testCase.verifyFalse(contains(sourceText, "otherCrossReference"))
        end

        function testNewerControlledTermPropertiesAreAccepted(testCase)
            term = openminds.controlledterms.ContributionType( ...
                [], ...
                "name", "authoring", ...
                "preferredCrossReference", "https://example.org/preferred", ...
                "otherCrossReference", "https://example.org/cross-reference", ...
                "otherOntologyIdentifier", "https://example.org/ontology");

            testCase.verifyEqual(term.preferredCrossReference, "https://example.org/preferred")
            testCase.verifyEqual(term.otherCrossReference, "https://example.org/cross-reference")
            testCase.verifyEqual(term.otherOntologyIdentifier, "https://example.org/ontology")
        end

        function testLatestControlledTermBaseDoesNotExposeOlderProperties(testCase)
            term = openminds.controlledterms.ContributionType();
            propertyNames = string(properties(term));

            testCase.verifyFalse(ismember("interlexIdentifier", propertyNames))
            testCase.verifyFalse(ismember("knowledgeSpaceLink", propertyNames))
        end

        function testControlledTermBaseDoesNotExposeTermSuggestionProperties(testCase)
            term = openminds.controlledterms.ContributionType();
            propertyNames = string(properties(term));

            testCase.verifyFalse(ismember("addExistingTerminology", propertyNames))
            testCase.verifyFalse(ismember("suggestNewTerminology", propertyNames))
        end
    end

    methods (Access = private)
        function filePath = getControlledTermBasePath(~, modelVersion)
        % getControlledTermBasePath - Abstract class generated for a version
            filePath = fullfile( ...
                openminds.internal.constants.Paths.GeneratedFolder, ...
                modelVersion, "types", "+openminds", "+controlledterms", ...
                "ControlledTerm.m");
        end
    end
end
