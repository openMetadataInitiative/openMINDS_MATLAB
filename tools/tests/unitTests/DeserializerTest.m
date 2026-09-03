classdef DeserializerTest < matlab.unittest.TestCase
% DeserializerTest - Unit tests for reading openMINDS instances from JSON-LD
%
%   See also openminds.internal.serializer.JsonLdDeserializer

    properties (Constant, Access = private)
        TypeIRI = "https://openminds.om-i.org/types/"
    end

    methods (Test)
        function testCollectionDocumentIsRead(testCase)
            document = DeserializerTest.collectionDocument( ...
                DeserializerTest.personNode("_:person-1", "Ada"));

            instances = testCase.deserialize(document);

            testCase.assertNumElements(instances, 1)
            testCase.verifyEqual(instances{1}.givenName, "Ada")
        end

        function testLinksBetweenNodesAreWired(testCase)
        % Nodes are built one at a time, so a linked property first holds
        % a stub. Deserialization must swap the stub for the instance.

            document = DeserializerTest.collectionDocument( ...
                sprintf(['{"@id": "_:contact-1", "@type": "%sContactInformation", ', ...
                    '"email": "ada@example.org"}'], DeserializerTest.TypeIRI), ...
                sprintf(['{"@id": "_:person-1", "@type": "%sPerson", ', ...
                    '"givenName": "Ada", "contactInformation": [{"@id": "_:contact-1"}]}'], ...
                    DeserializerTest.TypeIRI));

            instances = testCase.deserialize(document);
            person = DeserializerTest.findByClass(instances, 'openminds.core.actors.Person');

            testCase.assertNotEmpty(person)
            testCase.verifyEqual(person.contactInformation.email, "ada@example.org")
        end

        function testLinksAreWiredAcrossDocuments(testCase)
        % Instances loaded from separate files form one graph, which is
        % what a folder of one file per instance relies on.

            firstDocument = DeserializerTest.collectionDocument( ...
                sprintf(['{"@id": "_:contact-2", "@type": "%sContactInformation", ', ...
                    '"email": "grace@example.org"}'], DeserializerTest.TypeIRI));
            secondDocument = DeserializerTest.collectionDocument( ...
                sprintf(['{"@id": "_:person-2", "@type": "%sPerson", ', ...
                    '"givenName": "Grace", "contactInformation": [{"@id": "_:contact-2"}]}'], ...
                    DeserializerTest.TypeIRI));

            instances = testCase.deserialize([firstDocument, secondDocument]);
            person = DeserializerTest.findByClass(instances, 'openminds.core.actors.Person');

            testCase.assertNotEmpty(person)
            testCase.verifyEqual(person.contactInformation.email, "grace@example.org")
        end

        function testCircularDocumentTerminates(testCase)
        % Two nodes referring to each other must not be wired forever.

            document = DeserializerTest.collectionDocument( ...
                sprintf(['{"@id": "_:type-a", "@type": "%sContentType", ', ...
                    '"name": "a/type", "isBasedOn": [{"@id": "_:type-b"}]}'], ...
                    DeserializerTest.TypeIRI), ...
                sprintf(['{"@id": "_:type-b", "@type": "%sContentType", ', ...
                    '"name": "b/type", "isBasedOn": [{"@id": "_:type-a"}]}'], ...
                    DeserializerTest.TypeIRI));

            instances = testCase.deserialize(document);

            testCase.assertNumElements(instances, 2)
            first = DeserializerTest.findById(instances, "_:type-a");
            testCase.verifyEqual(first.isBasedOn.name, "b/type")
        end

        function testNodeWithoutTypeIsReported(testCase)
        % A node with no @type cannot be turned into an instance. Skipping
        % it silently hides how much of a document was lost.

            document = DeserializerTest.collectionDocument( ...
                '{"@id": "_:untyped-1", "name": "no type here"}', ...
                DeserializerTest.personNode("_:person-3", "Ada"));

            instances = testCase.verifyWarning( ...
                @() testCase.deserialize(document), ...
                'openMINDS:Deserializer:UnreadableNodes');

            testCase.verifyNumElements(instances, 1, ...
                'The readable node should still be returned.')
        end

        function testUnreadableNodesCanBeAnError(testCase)
        % A caller that cannot work with a partial result can ask for the
        % read to fail instead.

            document = DeserializerTest.collectionDocument( ...
                '{"@id": "_:untyped-2", "name": "no type here"}');

            deserializer = openminds.internal.serializer.JsonLdDeserializer( ...
                "UnreadableNodePolicy", "error");

            testCase.verifyError(@() deserializer.deserialize(document), ...
                'openMINDS:Deserializer:UnreadableNodes')
        end
    end

    methods (Access = private)
        function instances = deserialize(~, documents)
            deserializer = openminds.internal.serializer.JsonLdDeserializer();
            instances = deserializer.deserialize(documents);
        end
    end

    methods (Static, Access = private)
        function document = collectionDocument(varargin)
        % Wrap node documents in a collection document with an @graph.

            document = sprintf( ...
                '{"@context": {"@vocab": "https://openminds.om-i.org/props/"}, "@graph": [%s]}', ...
                strjoin(varargin, ', '));
            document = string(document);
        end

        function node = personNode(identifier, givenName)
            node = sprintf('{"@id": "%s", "@type": "%sPerson", "givenName": "%s"}', ...
                identifier, DeserializerTest.TypeIRI, givenName);
        end

        function instance = findByClass(instances, className)
            instance = [];
            for i = 1:numel(instances)
                if isa(instances{i}, className)
                    instance = instances{i};
                    return
                end
            end
        end

        function instance = findById(instances, identifier)
            instance = [];
            for i = 1:numel(instances)
                if string(instances{i}.id) == identifier
                    instance = instances{i};
                    return
                end
            end
        end
    end
end
