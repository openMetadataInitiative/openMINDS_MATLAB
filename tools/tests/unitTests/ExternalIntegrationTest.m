classdef ExternalIntegrationTest < matlab.unittest.TestCase
% ExternalIntegrationTest - An external backend built only on the extension points
%
%   Exercises the contract that lets a library integrate a database or
%   format without changing openMINDS_MATLAB: a mock graph database with
%   its own serializer (openminds.abstract.BaseSerializer), deserializer
%   (openminds.abstract.BaseDeserializer), store
%   (openminds.interface.MetadataStore) and resolver
%   (openminds.interface.LinkResolver). If a change here breaks these
%   tests, it breaks every external integration, openminds-kg-sync
%   included.

    properties (Access = private)
        Database ommtest.helper.mock.MockGraphDatabase
        Store ommtest.helper.mock.MockGraphMetadataStore
    end

    methods (TestMethodSetup)
        function createDatabase(testCase)
            testCase.Database = ommtest.helper.mock.MockGraphDatabase();
            testCase.Store = ommtest.helper.mock.MockGraphMetadataStore(testCase.Database);
        end

        function resetResolverRegistry(testCase)
            registry = openminds.internal.resolver.LinkResolverRegistry.getSingleton();
            registry.reset()
            testCase.addTeardown(@() registry.reset())
        end
    end

    methods (Test)
        function testSaveThroughCustomSerializer(testCase)
        % Every node of the collection becomes one record in the database.

            collection = ommtest.helper.buildFixtureCollection();
            testCase.Store.save(collection);

            testCase.verifyEqual(double(testCase.Database.count()), 7)
        end

        function testLoadRebuildsTheConnectedGraph(testCase)
        % Loading through the custom deserializer must reproduce values,
        % wire links between records, and preserve embedded values.

            testCase.Store.save(ommtest.helper.buildFixtureCollection());

            reloaded = openminds.Collection('MetadataStore', testCase.Store);
            testCase.assertEqual(double(reloaded.length()), 7)

            person = reloaded.list(openminds.enum.Types("Person"));
            testCase.verifyEqual(person.givenName, "Ada")
            testCase.verifyEqual(person.contactInformation.email, "ada@example.org", ...
                'The linked contact record was not wired to the person.')

            subject = reloaded.list(openminds.enum.Types("Subject"));
            testCase.verifyEqual(string(subject.species.id), ...
                "https://openminds.om-i.org/instances/species/homoSapiens")

            state = subject.studiedState;
            specimenAge = state.age;
            quantity = specimenAge.age;
            testCase.verifyEqual(quantity.value, 42, ...
                'The embedded quantitative value did not survive the round trip.')
        end

        function testRoundTripIsCanonicallyEquivalent(testCase)
        % The graph reloaded from the database serializes to exactly the
        % same canonical JSON-LD document as the original graph.

            original = ommtest.helper.buildFixtureCollection();
            testCase.Store.save(original);
            reloaded = openminds.Collection('MetadataStore', testCase.Store);

            serializer = openminds.internal.serializer.JsonLdSerializer('OutputMode', 'single');
            testCase.verifyEqual( ...
                serializer.serialize(reloaded.getAll()), ...
                serializer.serialize(original.getAll()))
        end

        function testUnknownTypeReferenceResolvesByReplacement(testCase)
        % A reference whose type is only known to the database resolves to
        % an instance of the recorded type through the registered resolver.

            identifier = openminds.core.digitalidentifier.GenericIdentifier( ...
                'id', "https://graph.example/instances/generic-001");
            identifier.identifier = "external-thing";
            identifier.type = "mock";
            testCase.Store.save(identifier);

            openminds.registerLinkResolver( ...
                ommtest.helper.mock.MockGraphResolver(testCase.Database));

            dataset = openminds.core.Dataset();
            dataset.fullName = "D";
            dataset.digitalIdentifier = openminds.internal.MixedTypeReference( ...
                "https://graph.example/instances/generic-001");

            dataset.resolve('NumLinksToResolve', 1);

            resolved = dataset.digitalIdentifier;
            testCase.verifyClass(resolved, 'openminds.core.digitalidentifier.GenericIdentifier')
            testCase.verifyEqual(resolved.identifier, "external-thing")
        end

        function testTypedReferenceResolvesInPlace(testCase)
        % A reference whose type is already known is populated in place.

            document = struct( ...
                'at_id', "https://graph.example/instances/person-002", ...
                'at_type', "https://openminds.om-i.org/types/Person", ...
                'givenName', "Grace");
            testCase.Database.put(struct( ...
                'Identifier', "https://graph.example/instances/person-002", ...
                'TypeIRI', "https://openminds.om-i.org/types/Person", ...
                'Document', string(jsonencode(document))));

            openminds.registerLinkResolver( ...
                ommtest.helper.mock.MockGraphResolver(testCase.Database));

            personStub = openminds.core.Person( ...
                'id', "https://graph.example/instances/person-002", 'IsReference', true);
            personStub.resolve();

            testCase.verifyEqual(personStub.givenName, "Grace")
        end
    end
end
