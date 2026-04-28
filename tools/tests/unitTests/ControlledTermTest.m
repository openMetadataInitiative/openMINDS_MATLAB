classdef ControlledTermTest < matlab.unittest.TestCase

    methods (Test)
        function testKnownInstanceCreatesLightweightReference(testCase)
            term = testCase.verifyWarningFree( ...
                @() openminds.controlledterms.ContributionType("authoring"));

            testCase.verifyEqual(term.name, "authoring")
            testCase.verifyEqual(term.id, ...
                openminds.constant.BaseURI + "/instances/contributionType/authoring")
        end

        function testOlderControlledTermPropertiesAreAccepted(testCase)
            sourceText = fileread(testCase.getControlledTermBasePath("v2"));

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

        function testTermSuggestionPropertiesAreAccepted(testCase)
            terminology = openminds.controlledterms.Terminology([], "name", "example");
            term = openminds.controlledterms.TermSuggestion( ...
                [], ...
                "name", "candidate", ...
                "addExistingTerminology", terminology, ...
                "suggestNewTerminology", "new terminology");

            testCase.verifyEqual(term.addExistingTerminology, terminology)
            testCase.verifyEqual(term.suggestNewTerminology, "new terminology")
        end

        function testLatestControlledTermBaseDoesNotExposeOlderProperties(testCase)
            term = openminds.controlledterms.ContributionType();
            propertyNames = string(properties(term));

            testCase.verifyFalse(ismember("interlexIdentifier", propertyNames))
            testCase.verifyFalse(ismember("knowledgeSpaceLink", propertyNames))
        end
    end

    methods (Access = private)
        function filePath = getControlledTermBasePath(~, version)
            rootPath = openminds.internal.rootpath();
            filePath = fullfile(rootPath, "internal", "+openminds", ...
                "+abstract", "private", "controlledTerms", version, ...
                "ControlledTerm.m");
        end
    end
end
