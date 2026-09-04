classdef ResolverTest < matlab.unittest.TestCase
%ResolverTest Unit tests for the openMINDS link resolver system
%
%   Tests the resolver registry, instance resolution, link resolution,
%   and various resolver implementations.

    methods (TestMethodSetup)
        function setUp(~)
            % Reset the resolver registry to known state for each test
            registry = openminds.internal.resolver.LinkResolverRegistry.instance();
            registry.reset()
        end
    end

    methods (Test)
        function testRegistryInitialization(testCase)
            % Test that the registry initializes with InstanceResolver
            registry = openminds.internal.resolver.LinkResolverRegistry.instance();
            
            testCase.verifyNotEmpty(registry.LinkResolvers);
            testCase.verifyTrue(isa(registry.LinkResolvers{1}, ...
                'openminds.internal.resolver.InstanceResolver'));
        end
        
        function testRegisterNewResolver(testCase)
            % Test registering a new resolver in the registry
            % Create a mock resolver
            mockResolver = ommtest.helper.mock.MockLinkResolver();
            
            % Register it
            openminds.registerLinkResolver(mockResolver);
            
            % Verify it's in the registry
            registry = openminds.internal.resolver.LinkResolverRegistry.instance();
            testCase.verifyTrue(any( cellfun(@(r) r == mockResolver, registry.LinkResolvers) ));
        end
        
        function testGetResolverForValidIRI(testCase)
            % Test getting a resolver for a valid IRI
            mockResolver = ommtest.helper.mock.MockLinkResolver();
            openminds.registerLinkResolver(mockResolver);
            
            % Test that the correct resolver is returned
            resolver = openminds.internal.getLinkResolver('https://mock.io/person_123');
            testCase.verifyEqual(resolver, mockResolver);
        end
        
        function testGetResolverForUnknownIRI(testCase)
            % Test error when no resolver can handle an IRI
            testCase.verifyError(...
                @() openminds.internal.getLinkResolver('https://unknown.example/123'), ...
                'openMINDS_MATLAB:LinkResolverRegistry:NotFound');
        end
        
        function testMockResolverCanResolve(testCase)
            % Test MockResolver's canResolve method
            resolver = ommtest.helper.mock.MockLinkResolver();
            
            % Should resolve mock.io IRIs
            testCase.verifyTrue(resolver.canResolve("https://mock.io/person_123"));
            testCase.verifyTrue(resolver.canResolve("https://mock.io/dataset_456"));
            
            % Should not resolve other IRIs
            testCase.verifyFalse(resolver.canResolve("https://external.example/123"));
        end
        
        function testResolvePersonReference(testCase)
            % Test resolving a Person reference node
            mockResolver = ommtest.helper.mock.MockLinkResolver();
            openminds.registerLinkResolver(mockResolver);
            
            % Create a Person reference (just ID, no data)
            personRef = openminds.core.Person('id', 'https://mock.io/person_123', 'IsReference', true);
            
            % Verify it starts as empty
            testCase.verifyEqual(personRef.givenName, "");
            testCase.verifyEqual(personRef.familyName, "");
            
            % Resolve it
            personRef.resolve();
            
            % Verify it now has mock data
            testCase.verifyEqual(personRef.givenName, "Mock");
            testCase.verifyEqual(personRef.familyName, "Person");
        end
        
        function testResolveDatasetWithAuthor(testCase)
            % Test resolving a Dataset that has an author reference
            mockResolver = ommtest.helper.mock.MockLinkResolver();
            openminds.registerLinkResolver(mockResolver);
            
            % Create author reference
            authorRef = openminds.core.Person('id', 'https://mock.io/author_456', 'IsReference', true);
            
            % Create dataset with author reference
            dataset = ResolverTest.createDatasetWithAuthors( ...
                authorRef, "Test Dataset");
            
            % Verify author starts empty
            authors = ResolverTest.getDatasetAuthors(dataset);
            testCase.verifyEqual(authors.givenName, "");
            
            % Resolve the dataset (should resolve linked authors)
            dataset.resolve( ...
                'NumLinksToResolve', ResolverTest.datasetAuthorResolveDepth());
            
            % Verify author is now resolved
            authors = ResolverTest.getDatasetAuthors(dataset);
            testCase.verifyEqual(authors.givenName, "Mock");
            testCase.verifyEqual(authors.familyName, "Person");
        end
        
        function testInstanceResolverCanResolve(testCase)
            % Test InstanceResolver's canResolve method
            resolver = openminds.internal.resolver.InstanceResolver();
            
            % Should resolve openMINDS instance IRIs
            baseURI = openminds.constant.BaseURI("v4");
            validIRI = baseURI + "/instances/person/123";
            testCase.verifyTrue(resolver.canResolve(validIRI));
            
            % Should not resolve other IRIs
            testCase.verifyFalse(resolver.canResolve("https://external.example/123"));
        end
        
        function testNoDuplicateResolvers(testCase)
            % Test that duplicate resolvers are not added
            resolver = ommtest.helper.mock.MockLinkResolver();
            
            registry = openminds.internal.resolver.LinkResolverRegistry.instance();
            initialCount = length(registry.LinkResolvers);
            
            % Register same resolver twice
            openminds.registerLinkResolver(resolver);
            openminds.registerLinkResolver(resolver);
            
            % Should only have one additional resolver
            testCase.verifyEqual(length(registry.LinkResolvers), initialCount + 1);
        end
        
        function testResolverWithSameIRIPrefixRejected(testCase)
            % Test that resolvers with duplicate IRI prefixes are rejected
            resolver1 = ommtest.helper.mock.MockLinkResolver();
            resolver2 = ommtest.helper.mock.MockLinkResolver();
            
            registry = openminds.internal.resolver.LinkResolverRegistry.instance();
            initialCount = length(registry.LinkResolvers);
            
            % Register both resolvers (should reject second one)
            openminds.registerLinkResolver(resolver1);
            openminds.registerLinkResolver(resolver2);
            
            % Should only have one additional resolver
            testCase.verifyEqual(length(registry.LinkResolvers), initialCount + 1);
        end
        
        function testHasLinkResolverCheck(testCase)
            % Test the hasLinkResolver method
            registry = openminds.internal.resolver.LinkResolverRegistry.instance();
            
            % Should have InstanceResolver by default
            testCase.verifyTrue(registry.hasLinkResolver(...
                'openminds.internal.resolver.InstanceResolver'));
            
            % Should not have unregistered resolver
            testCase.verifyFalse(registry.hasLinkResolver(...
                'openminds.internal.resolver.NonExistentResolver'));
        end
        
        function testResolveWithNumLinksToResolve(testCase)
            % Test resolving with recursive link resolution
            mockResolver = ommtest.helper.mock.MockLinkResolver();
            openminds.registerLinkResolver(mockResolver);
            
            % Create a dataset with an author reference
            authorRef = openminds.core.Person('id', 'https://mock.io/author_789', 'IsReference', true);
            dataset = ResolverTest.createDatasetWithAuthors( ...
                authorRef, "Test Dataset");
            
            % Test that resolve method exists and can be called
            testCase.verifyTrue(ismethod(dataset, 'resolve'));
            
            % Resolve with link depth of 1
            dataset.resolve( ...
                'NumLinksToResolve', ResolverTest.datasetAuthorResolveDepth());
            
            % Verify the author was resolved
            authors = ResolverTest.getDatasetAuthors(dataset);
            testCase.verifyEqual(authors.givenName, "Mock");
        end
        
        function testResolveArrayContinuesPastResolvedElement(testCase)
        % Every element of an array must be considered. An element that is
        % already resolved must not stop the loop, or references later in
        % the array are silently left unresolved.

            mockResolver = ommtest.helper.mock.MockLinkResolver();
            openminds.registerLinkResolver(mockResolver);

            resolvedPerson = openminds.core.Person();
            resolvedPerson.givenName = "Already";

            referencePerson = openminds.core.Person('id', 'https://mock.io/person_after', 'IsReference', true);

            instances = [resolvedPerson, referencePerson];
            instances.resolve();

            testCase.verifyEqual(instances(1).givenName, "Already", ...
                'The resolved element should be left alone.')
            testCase.verifyEqual(instances(2).givenName, "Mock", ...
                'The reference after a resolved element should still be resolved.')
        end

        function testResolveDepthIsPerArrayElement(testCase)
        % The link depth is a budget for each element of the array, not a
        % budget shared across the whole array. Resolving the links of one
        % element must not exhaust the depth available to the next.

            mockResolver = ommtest.helper.mock.MockLinkResolver();
            openminds.registerLinkResolver(mockResolver);

            firstDataset = ResolverTest.createDatasetWithAuthors( ...
                openminds.core.Person('id', 'https://mock.io/author_first', 'IsReference', true), ...
                "First Dataset");
            secondDataset = ResolverTest.createDatasetWithAuthors( ...
                openminds.core.Person('id', 'https://mock.io/author_second', 'IsReference', true), ...
                "Second Dataset");

            datasets = [firstDataset, secondDataset];
            datasets.resolve( ...
                'NumLinksToResolve', ResolverTest.datasetAuthorResolveDepth());

            firstAuthor = ResolverTest.getDatasetAuthors(datasets(1));
            secondAuthor = ResolverTest.getDatasetAuthors(datasets(2));

            testCase.verifyEqual(firstAuthor.givenName, "Mock")
            testCase.verifyEqual(secondAuthor.givenName, "Mock", ...
                'The second element should get the same depth budget as the first.')
        end

        function testResolveIsQuiet(testCase)
        % Resolving an instance that is already resolved is a no-op and must
        % not write to the command window.

            resolvedPerson = openminds.core.Person();
            resolvedPerson.givenName = "Already";

            output = evalc('resolvedPerson.resolve();');
            testCase.verifyEmpty(strtrim(output), ...
                'resolve should not print to the command window.')
        end

        function testResolverReplacementIsWiredIntoParent(testCase)
        % A resolver that cannot populate a reference in place returns a
        % new instance. The traversal must put that instance on the parent
        % property, or the resolved value is discarded.

            replacingResolver = ommtest.helper.mock.ReplacingMockLinkResolver();
            openminds.registerLinkResolver(replacingResolver);

            reference = openminds.core.Person( ...
                'id', 'https://replacing.mock/unknown_type_1', 'IsReference', true);
            dataset = ResolverTest.createDatasetWithAuthors(reference, "Replacing Dataset");

            dataset.resolve( ...
                'NumLinksToResolve', ResolverTest.datasetAuthorResolveDepth());

            testCase.assertNotEmpty(replacingResolver.ResolvedIdentifiers, ...
                'The resolver was never asked to resolve the reference.')

            author = ResolverTest.getDatasetAuthors(dataset);
            testCase.verifyEqual(author.givenName, "Replaced", ...
                'The instance returned by the resolver was not stored on the parent.')
        end

        function testUnknownTypeReferenceResolvesByReplacement(testCase)
        % A reference whose type is not known until it is probed cannot be
        % populated in place, so resolving it must return a new instance of
        % the discovered type.

            replacingResolver = ommtest.helper.mock.ReplacingMockLinkResolver();
            openminds.registerLinkResolver(replacingResolver);

            reference = openminds.internal.MixedTypeReference( ...
                "https://replacing.mock/unknown_type_2");

            resolved = reference.resolve();

            testCase.verifyClass(resolved, 'openminds.core.actors.Person')
            testCase.verifyEqual(resolved.givenName, "Replaced")
        end

        function testTraversalTerminatesOnCircularGraph(testCase)
        % A walk of the graph must stop when it returns to a node it has
        % already visited. Nothing here is a reference, so nothing is
        % resolved: what is exercised is the walk itself.

            firstType = openminds.core.data.ContentType();
            firstType.name = "first/type";
            secondType = openminds.core.data.ContentType();
            secondType.name = "second/type";

            firstType.isBasedOn = secondType;
            secondType.isBasedOn = firstType;

            % 500 is MATLAB's default recursion limit. A walk that follows
            % links without cycle detection cannot complete this graph at
            % that depth, so finishing at all shows the cycle was detected.
            firstType.resolve('NumLinksToResolve', 500);

            testCase.verifyEqual(firstType.name, "first/type", ...
                'The graph should be unchanged by walking it.')
            testCase.verifyEqual(secondType.name, "second/type")
        end

        function testReferenceCycleResolvesAndTerminates(testCase)
        % A cycle can exist only as references: resolving one node yields
        % a link to a second whose resolution links back to the first.
        % Both must be populated, and the traversal must stop when it
        % returns to a node it has already resolved. 500 is MATLAB's
        % default recursion limit, so a traversal without cycle detection
        % cannot complete this.

            openminds.registerLinkResolver(ommtest.helper.mock.CyclicMockLinkResolver());

            first = openminds.core.data.ContentType('id', ...
                ommtest.helper.mock.CyclicMockLinkResolver.IRIPrefix + "a", ...
                'IsReference', true);

            first = first.resolve('NumLinksToResolve', 500);

            testCase.verifyEqual(first.name, "a")
            second = first.isBasedOn;
            testCase.verifyEqual(second.name, "b", ...
                'The node the first one links to must be resolved as well.')
            testCase.verifyEqual(string(second.isBasedOn.id), string(first.id), ...
                'The second node must link back to the first.')
        end

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

            leaf = ResolverTest.contentTypeReference("leaf");
            shared = ResolverTest.contentType("shared");
            shared.isBasedOn = leaf;
            detour = ResolverTest.contentType("detour");
            detour.isBasedOn = shared;
            root = ResolverTest.contentType("root");
            root.isBasedOn = [detour, shared]; % detour first, so shared is first reached with no budget left

            root.resolve('NumLinksToResolve', 2);

            testCase.verifyEqual(leaf.name, "resolved", ...
                'leaf is two links from root along root -> shared -> leaf and must be resolved.')
        end

        function testReferencesSharingAnIdentifierAreUnified(testCase)
        % Two reference objects can carry the same identifier, for example
        % when two nodes of a document point at the same external instance.
        % Resolving fetches the identifier once and points every reference
        % to it at that one object, so all links agree.

            openminds.registerLinkResolver(ommtest.helper.mock.ContentTypeMockResolver());

            left = ResolverTest.contentType("left");
            left.isBasedOn = ResolverTest.contentTypeReference("shared");
            right = ResolverTest.contentType("right");
            right.isBasedOn = ResolverTest.contentTypeReference("shared");
            root = ResolverTest.contentType("root");
            root.isBasedOn = [left, right];

            root.resolve('NumLinksToResolve', 2);

            testCase.verifyEqual(left.isBasedOn.name, "resolved")
            testCase.verifyEqual(right.isBasedOn.name, "resolved", ...
                'The second reference to the identifier must be resolved too.')
            testCase.verifySameHandle(right.isBasedOn, left.isBasedOn, ...
                'Both references must point at the one object resolved for the identifier.')
        end

        function testResolvedReplacementKeepsTheReferenceIdentifier(testCase)
        % A resolver may replace a reference with an instance of the type
        % it discovered. The replacement stands for the same node, so it
        % carries the identifier the reference carried; every link to it
        % is written with that identifier.

            openminds.registerLinkResolver(ommtest.helper.mock.ReplacingMockLinkResolver());

            referenceId = "https://replacing.mock/author-1";
            author = openminds.core.Person('id', referenceId, 'IsReference', true);
            dataset = ResolverTest.createDatasetWithAuthors(author, "Dataset");

            dataset = dataset.resolve( ...
                'NumLinksToResolve', ResolverTest.datasetAuthorResolveDepth());
            resolvedAuthor = ResolverTest.getDatasetAuthors(dataset);

            testCase.verifyEqual(string(resolvedAuthor.id), referenceId)
        end

        function testResolverThatDropsTheIdentifierIsRejected(testCase)
        % A replacement without the reference's identifier would change
        % the target of every link to it when the graph is written out
        % again. That is a bug in the resolver, reported where it happens
        % rather than hidden by patching the identifier.

            openminds.registerLinkResolver(ommtest.helper.mock.IdentityDroppingMockLinkResolver());

            author = openminds.core.Person('id', "https://dropping.mock/author-1", 'IsReference', true);
            dataset = ResolverTest.createDatasetWithAuthors(author, "Dataset");

            testCase.verifyError( ...
                @() dataset.resolve('NumLinksToResolve', ResolverTest.datasetAuthorResolveDepth()), ...
                'openMINDS:LinkResolver:IdentityChanged')
        end

        function testResolverSelectionDoesNotDependOnEarlierLookups(testCase)
        % Which resolver handles an identifier is a function of the
        % identifier and the registration order alone. A resolver for a
        % broad prefix registered after one for a narrower prefix inside
        % it must give the same answer for the narrow prefix before and
        % after an unrelated lookup.

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

        function testResolvingAnEmptyArrayKeepsItsClass(testCase)
        % Resolving returns the instances it was given, so an empty array
        % of a type comes back as an empty array of that type.

            people = openminds.core.Person.empty(1, 0);

            resolved = people.resolve();

            testCase.verifyClass(resolved, 'openminds.core.actors.Person')
            testCase.verifyEmpty(resolved)
        end

        function testResolveMultipleLinkedInstances(testCase)
            % Test resolving a node with multiple linked instances
            mockResolver = ommtest.helper.mock.MockLinkResolver();
            openminds.registerLinkResolver(mockResolver);
            
            % Create multiple author references
            author1 = openminds.core.Person('id', 'https://mock.io/author1', 'IsReference', true);
            author2 = openminds.core.Person('id', 'https://mock.io/author2', 'IsReference', true);
            
            % Create dataset with multiple authors
            dataset = ResolverTest.createDatasetWithAuthors( ...
                [author1, author2], "Multi-Author Dataset");
            
            % Resolve with link depth
            dataset.resolve( ...
                'NumLinksToResolve', ResolverTest.datasetAuthorResolveDepth());
            
            % Verify both authors were resolved
            authors = ResolverTest.getDatasetAuthors(dataset);
            testCase.verifyEqual(authors(1).givenName, "Mock");
            testCase.verifyEqual(authors(2).givenName, "Mock");
        end
    end

    methods (Static, Access = private)
        function instance = contentType(name)
        % A resolved ContentType, a type that links to its own type.
            instance = openminds.core.data.ContentType();
            instance.name = name;
        end

        function reference = contentTypeReference(name)
        % A ContentType reference that ContentTypeMockResolver can resolve.
            reference = openminds.core.data.ContentType('id', ...
                ommtest.helper.mock.ContentTypeMockResolver.IRIPrefix + name, ...
                'IsReference', true);
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
end
