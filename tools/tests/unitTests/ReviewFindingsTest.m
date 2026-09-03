classdef ReviewFindingsTest < matlab.unittest.TestCase
% ReviewFindingsTest - Invariants the traversal and deserialization stack must hold
%
%   Each test states a property the library should satisfy. A failing test
%   here marks a defect in the library found during review, not a defect in
%   the test. This class is a review artifact: once a behaviour is fixed,
%   its test belongs in the suite that covers that behaviour.

    properties (Constant, Access = private)
        TypeIRI = "https://openminds.om-i.org/types/"
    end

    methods (TestMethodSetup)
        function resetRegistry(~)
            registry = openminds.internal.resolver.LinkResolverRegistry.instance();
            registry.reset()
        end
    end

    methods (Test) % Reference resolution

        function testNodeWithinLinkBudgetIsResolvedRegardlessOfPathOrder(testCase)
        % Link depth is a budget along a path. A node inside the budget
        % along one path must be resolved even when a longer path reached
        % it first with no budget left.
        %
        %   root -> detour -> shared -> leaf
        %   root -> shared
        %
        % With a budget of 2, root -> shared -> leaf is inside it.

            openminds.registerLinkResolver(ommtest.helper.mock.ContentTypeMockResolver());

            leaf = ReviewFindingsTest.contentTypeReference("leaf");
            shared = ReviewFindingsTest.contentType("shared");
            shared.isBasedOn = leaf;
            detour = ReviewFindingsTest.contentType("detour");
            detour.isBasedOn = shared;
            root = ReviewFindingsTest.contentType("root");
            root.isBasedOn = [detour, shared]; % detour first, so shared is first reached with no budget left

            root.resolve('NumLinksToResolve', 2);

            testCase.verifyEqual(leaf.name, "resolved", ...
                'leaf is two links from root along root -> shared -> leaf and must be resolved.')
        end

        function testDistinctStubsSharingAnIdentifierAreAllResolved(testCase)
        % Two reference objects can carry the same identifier, for example
        % when two nodes of a document point at the same external instance.
        % Each is a distinct object a caller may hold, so each must be
        % populated.

            openminds.registerLinkResolver(ommtest.helper.mock.ContentTypeMockResolver());

            firstStub = ReviewFindingsTest.contentTypeReference("shared");
            secondStub = ReviewFindingsTest.contentTypeReference("shared");
            left = ReviewFindingsTest.contentType("left");
            left.isBasedOn = firstStub;
            right = ReviewFindingsTest.contentType("right");
            right.isBasedOn = secondStub;
            root = ReviewFindingsTest.contentType("root");
            root.isBasedOn = [left, right];

            root.resolve('NumLinksToResolve', 2);

            testCase.verifyEqual(firstStub.name, "resolved")
            testCase.verifyEqual(secondStub.name, "resolved", ...
                'The second stub is a distinct object with the same identifier and must also be resolved.')
        end

        function testResolvedReplacementKeepsTheReferenceIdentifier(testCase)
        % A resolver may replace a reference with an instance of the type
        % it discovered. The replacement stands for the same node, so it
        % must carry the identifier the reference carried. Otherwise every
        % link to it changes target when the graph is written out again.

            openminds.registerLinkResolver(ommtest.helper.mock.ReplacingMockLinkResolver());

            referenceId = "https://replacing.mock/author-1";
            author = openminds.core.Person('id', referenceId);
            dataset = ReviewFindingsTest.createDatasetWithAuthors(author, "Dataset");

            dataset = dataset.resolve( ...
                'NumLinksToResolve', ReviewFindingsTest.datasetAuthorResolveDepth());
            resolvedAuthor = ReviewFindingsTest.getDatasetAuthors(dataset);

            testCase.verifyEqual(string(resolvedAuthor.id), referenceId, ...
                'The replacement stands for the reference and must keep its identifier.')
        end

        function testResolvingAnEmptyArrayKeepsItsClass(testCase)
        % Resolving returns the instances it was given, so an empty array
        % of a type comes back as an empty array of that type.

            people = openminds.core.Person.empty(1, 0);

            resolved = people.resolve();

            testCase.verifyClass(resolved, 'openminds.core.actors.Person')
            testCase.verifyEmpty(resolved)
        end
    end

    methods (Test) % Resolver registry

        function testResolverSelectionDoesNotDependOnEarlierLookups(testCase)
        % Which resolver handles an identifier is a function of the
        % identifier alone. A resolver for a broad prefix registered next
        % to one for a narrower prefix inside it must not change the answer
        % for the narrow prefix after an unrelated lookup.

            openminds.registerLinkResolver(ommtest.helper.mock.NarrowPrefixMockResolver());
            openminds.registerLinkResolver(ommtest.helper.mock.BroadPrefixMockResolver());

            narrowIri = "https://overlap.mock/narrow/x";
            first = openminds.internal.getLinkResolver(narrowIri);
            openminds.internal.getLinkResolver("https://overlap.mock/other"); % only the broad resolver handles this
            second = openminds.internal.getLinkResolver(narrowIri);

            testCase.verifyClass(first, 'ommtest.helper.mock.NarrowPrefixMockResolver')
            testCase.verifyClass(second, class(first), ...
                'The same identifier must select the same resolver every time.')
        end
    end

    methods (Test) % Deserialization

        function testReferenceToBareHostIriDoesNotBreakDeserialization(testCase)
        % A linked property may point outside the document. An identifier
        % with a host and no path is a valid IRI and must stay an
        % unresolved reference rather than break reading the document.

            document = ReviewFindingsTest.collectionDocument(sprintf( ...
                ['{"@id": "_:person-1", "@type": "%sPerson", "givenName": "Ada", ', ...
                 '"contactInformation": [{"@id": "https://example.org"}]}'], ...
                ReviewFindingsTest.TypeIRI));

            instances = ReviewFindingsTest.deserialize(document);

            testCase.assertNumElements(instances, 1)
            testCase.verifyTrue(instances{1}.contactInformation.isUnresolved(), ...
                'A reference the document does not define stays unresolved.')
        end

        function testVocabularyIriInsideAValueIsPreserved(testCase)
        % Expanded property names carry a vocabulary IRI that is removed
        % on reading. A value that contains that IRI is data and must come
        % back unchanged.

            value = "https://openminds.om-i.org/props/givenName";
            document = ReviewFindingsTest.collectionDocument(sprintf( ...
                '{"@id": "_:person-1", "@type": "%sPerson", "givenName": "%s"}', ...
                ReviewFindingsTest.TypeIRI, value));

            instances = ReviewFindingsTest.deserialize(document);

            testCase.assertNumElements(instances, 1)
            testCase.verifyEqual(instances{1}.givenName, value)
        end

        function testInstancesReadFromADocumentHaveDistinctIdentifiers(testCase)
        % Two nodes with one identifier cannot both be the target of a
        % link, so a document containing them is malformed. Reading it
        % must not hand back two instances with the same identifier as if
        % nothing were wrong.

            document = ReviewFindingsTest.collectionDocument( ...
                ReviewFindingsTest.personNode("_:duplicate", "First"), ...
                ReviewFindingsTest.personNode("_:duplicate", "Second"));

            instances = ReviewFindingsTest.deserialize(document);

            identifiers = cellfun(@(instance) string(instance.id), instances);
            testCase.verifyEqual(numel(unique(identifiers)), numel(identifiers), ...
                'Instances read from one document must have distinct identifiers.')
        end
    end

    methods (Static, Access = private) % Graph construction

        function instance = contentType(name)
            instance = openminds.core.data.ContentType();
            instance.name = name;
        end

        function reference = contentTypeReference(name)
            reference = openminds.core.data.ContentType('id', ...
                ommtest.helper.mock.ContentTypeMockResolver.IRIPrefix + name);
        end

        function dataset = createDatasetWithAuthors(authors, fullName)
            if ommtest.oneoffs.currentSchemaMajorVersion() >= 5
                contribution = openminds.core.Contribution( ...
                    "contributor", authors, ...
                    "type", openminds.controlledterms.ContributionType( ...
                        [], "name", "authoring"));

                dataset = openminds.core.Dataset( ...
                    "contribution", contribution, ...
                    "description", fullName, ...
                    "fullName", fullName, ...
                    "shortName", fullName);
            else
                dataset = openminds.core.Dataset( ...
                    "fullName", fullName, ...
                    "author", authors);
            end
        end

        function authors = getDatasetAuthors(dataset)
            if ommtest.oneoffs.currentSchemaMajorVersion() >= 5
                authors = [dataset.contribution.contributor];
            else
                authors = dataset.author;
            end
        end

        function depth = datasetAuthorResolveDepth()
            if ommtest.oneoffs.currentSchemaMajorVersion() >= 5
                depth = 2;
            else
                depth = 1;
            end
        end
    end

    methods (Static, Access = private) % Documents

        function instances = deserialize(documents)
            deserializer = openminds.internal.serializer.JsonLdDeserializer();
            instances = deserializer.deserialize(documents);
        end

        function document = collectionDocument(varargin)
            document = sprintf( ...
                '{"@context": {"@vocab": "https://openminds.om-i.org/props/"}, "@graph": [%s]}', ...
                strjoin(varargin, ', '));
            document = string(document);
        end

        function node = personNode(identifier, givenName)
            node = sprintf('{"@id": "%s", "@type": "%sPerson", "givenName": "%s"}', ...
                identifier, ReviewFindingsTest.TypeIRI, givenName);
        end
    end
end
