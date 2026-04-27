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
            testCase.verifyTrue(isa(registry.LinkResolvers(1), ...
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
            testCase.verifyTrue(any(registry.LinkResolvers == mockResolver));
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
            personRef = openminds.core.Person('id', 'https://mock.io/person_123');
            
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
            authorRef = openminds.core.Person('id', 'https://mock.io/author_456');
            
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
        
        function testResolverRegistryPromotesUsedResolver(testCase)
            % Test that frequently used resolvers are moved to front
            mockResolver = ommtest.helper.mock.MockLinkResolver();
            openminds.registerLinkResolver(mockResolver);
            
            registry = openminds.internal.resolver.LinkResolverRegistry.instance();
            
            % MockResolver should be at the end initially (after InstanceResolver)
            testCase.verifyGreaterThan(length(registry.LinkResolvers), 1);
            
            % Use the mock resolver
            openminds.internal.getLinkResolver('https://mock.io/test_123');
            
            % Verify mock resolver is now promoted to first position
            testCase.verifyEqual(registry.LinkResolvers(1), mockResolver);
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
            authorRef = openminds.core.Person('id', 'https://mock.io/author_789');
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
        
        function testResolveMultipleLinkedInstances(testCase)
            % Test resolving a node with multiple linked instances
            mockResolver = ommtest.helper.mock.MockLinkResolver();
            openminds.registerLinkResolver(mockResolver);
            
            % Create multiple author references
            author1 = openminds.core.Person('id', 'https://mock.io/author1');
            author2 = openminds.core.Person('id', 'https://mock.io/author2');
            
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
