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

    methods (Test) % Properties the active model does not have

        function testPropertiesUnknownToTheModelAreReported(testCase)
        % A document written for another model version can carry
        % properties the active model does not have. They cannot be kept,
        % but losing them silently would hide that the document was not
        % read in full, so they are reported once, by node, and the
        % known properties are still read.

            document = DeserializerTest.collectionDocument(sprintf( ...
                ['{"@id": "_:person-1", "@type": "%sPerson", "givenName": "Ada", ', ...
                 '"interlexIdentifier": "http://uri.interlex.org/base/ilx_0000000"}'], ...
                DeserializerTest.TypeIRI));

            instances = testCase.verifyWarning(@() testCase.deserialize(document), ...
                'openMINDS:Deserializer:DroppedProperties');

            testCase.assertNumElements(instances, 1)
            testCase.verifyEqual(instances{1}.givenName, "Ada", ...
                'The properties the model does have are still read.')
        end

        function testDocumentWithinTheModelIsReadWithoutReport(testCase)
        % The report fires only when something is lost. A document that
        % uses only properties the active model has produces none.

            document = DeserializerTest.collectionDocument( ...
                DeserializerTest.personNode("_:person-1", "Ada"));

            testCase.verifyWarningFree(@() testCase.deserialize(document));
        end
    end

    methods (Test) % References outside the document

        function testReferenceToBareHostIriIsLeftUnresolved(testCase)
        % A linked property may point outside the document. An identifier
        % with a host and no path is a valid IRI and stays an unresolved
        % reference rather than breaking the read.

            document = DeserializerTest.collectionDocument(sprintf( ...
                ['{"@id": "_:person-1", "@type": "%sPerson", "givenName": "Ada", ', ...
                 '"contactInformation": [{"@id": "https://example.org"}]}'], ...
                DeserializerTest.TypeIRI));

            instances = testCase.deserialize(document);

            testCase.assertNumElements(instances, 1)
            testCase.verifyTrue(instances{1}.contactInformation.isReference(), ...
                'A reference the document does not define stays unresolved.')
        end
    end

    methods (Test) % Embedded lists

        function testEmbeddedListWithUnlikeElementsIsRead(testCase)
        % A list of embedded values whose elements carry different
        % properties decodes to a cell of structs. The node must still be
        % read, with every element.

            typeIRI = "https://openminds.om-i.org/instances/contributionType/acquisition";
            document = DeserializerTest.collectionDocument(sprintf( ...
                ['{"@id": "_:dataset-1", "@type": "%sDatasetVersion", "shortName": "unlike", ', ...
                 '"contribution": [', ...
                 '{"@type": "%sContribution", "type": [{"@id": "%s"}]}, ', ...
                 '{"@type": "%sContribution"}]}'], ...
                DeserializerTest.TypeIRI, DeserializerTest.TypeIRI, typeIRI, DeserializerTest.TypeIRI));

            instances = testCase.verifyWarningFree(@() testCase.deserialize(document));

            testCase.assertNumElements(instances, 1)
            testCase.assertNumElements(instances{1}.contribution, 2)
            testCase.verifyNotEmpty(instances{1}.contribution(1).type)
            testCase.verifyEmpty(instances{1}.contribution(2).type)
        end
    end

    methods (Test) % Properties the schema names differently

        function testRenamedPropertyIsReadBack(testCase)
        % A document carries a renamed property under its schema name,
        % which is not a valid identifier and so does not survive
        % decoding as it is. It must still land in the property the type
        % declares, whichever property name syntax wrote it, and without
        % being reported as a property the model lacks.

            [instance, propertyName, schemaName] = instanceWithRenamedProperty();
            testCase.assumeNotEmpty(instance, ...
                'This model version has no property the schema names differently.')
            expectedDocument = string(instance.serialize());

            for syntax = ["compact", "expanded"]
                serializer = openminds.internal.serializer.JsonLdSerializer( ...
                    "PropertyNameSyntax", syntax);
                document = string(serializer.serialize(instance));
                % In expanded syntax the key carries the vocabulary IRI
                % before the schema name, so only the end of it is known.
                testCase.assertSubstring(document, sprintf('%s":', schemaName), ...
                    "The document written with the " + syntax + " syntax must " + ...
                    "carry the schema name for this test to mean anything.")

                instances = testCase.verifyWarningFree( ...
                    @() testCase.deserialize(document), "Syntax: " + syntax);

                testCase.assertNumElements(instances, 1)
                testCase.verifyNotEmpty(instances{1}.(propertyName), ...
                    "The property is read from the " + syntax + " document.")
                testCase.verifyEqual(string(instances{1}.serialize()), expectedDocument, ...
                    "The instance read from the " + syntax + " document " + ...
                    "writes the same document as the original.")
            end
        end

        function testRenamedPropertyIsReadFromDecodedStruct(testCase)
        % Code that decodes a document itself builds the instance from
        % the decoded struct, without the deserializer. The renamed
        % property arrives under the spelling jsondecode gives the schema
        % name and must still land in the property the type declares.

            [instance, propertyName, schemaName] = instanceWithRenamedProperty();
            testCase.assumeNotEmpty(instance, ...
                'This model version has no property the schema names differently.')
            expectedDocument = string(instance.serialize());

            decoded = openminds.internal.utility.json.decode(expectedDocument);
            testCase.assertTrue(isfield(decoded, matlab.lang.makeValidName(schemaName)), ...
                "The decoded struct must carry the decoded schema name for this test to mean anything.")

            copy = feval(class(instance), decoded);

            testCase.verifyNotEmpty(copy.(propertyName))
            testCase.verifyEqual(string(copy.serialize()), expectedDocument)
        end
    end

    methods (Test) % Malformed documents

        function testDuplicateIdentifiersAreReported(testCase)
        % Two nodes with one identifier cannot both be the target of a
        % link. The first is kept and the second reported as unreadable,
        % so a partial read is visible.

            document = DeserializerTest.collectionDocument( ...
                DeserializerTest.personNode("_:duplicate", "First"), ...
                DeserializerTest.personNode("_:duplicate", "Second"));

            instances = testCase.verifyWarning(@() testCase.deserialize(document), ...
                'openMINDS:Deserializer:UnreadableNodes');

            testCase.assertNumElements(instances, 1)
            testCase.verifyEqual(instances{1}.givenName, "First", ...
                'The first node with the identifier is the one kept.')
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
