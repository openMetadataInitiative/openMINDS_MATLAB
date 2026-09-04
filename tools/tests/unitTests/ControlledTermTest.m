classdef ControlledTermTest < matlab.unittest.TestCase

    methods (Test)
        function testKnownInstanceCreatesLightweightReference(testCase)
            term = testCase.verifyWarningFree( ...
                @() openminds.controlledterms.ContributionType("authoring"));

            testCase.verifyEqual(term.name, "authoring")
            testCase.verifyEqual(term.id, ...
                openminds.constant.BaseIRI + "/instances/contributionType/authoring")
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
        % getControlledTermBasePath - Base class generated for a model version
            filePath = fullfile( ...
                openminds.internal.constants.Paths.GeneratedFolder, ...
                modelVersion, "base", "+openminds", "+base", "ControlledTerm.m");
        end
    end
end
