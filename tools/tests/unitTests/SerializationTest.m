classdef SerializationTest < matlab.unittest.TestCase
    


    properties

    end


    methods (Test)

        function testScalarInstanceToCollectionDocument(testCase)
            scalarInstanceWithoutLinks = openminds.core.ContactInformation(...
                "email", "test@mail.somewhere");

            serializer = openminds.internal.serializer.JsonLdSerializer(...
                'OutputMode', 'single');
            
            jsonLdDoc = scalarInstanceWithoutLinks.serialize("Serializer", serializer);
            
            % Todo: improve this...
            testCase.verifyTrue(contains(jsonLdDoc, '"@context"'))
            testCase.verifyTrue(contains(jsonLdDoc, '"@graph"'))
        end


        function testVocabularyIriInValueSurvivesDecoding(testCase)
            % The vocabulary prefix is stripped from property names when a
            % document is decoded. A string value that happens to hold a
            % vocabulary IRI must come back unchanged.
            vocabularyIRI = openminds.internal.serializer.jsonld.getVocabularyIRIs();
            literalValue = vocabularyIRI(1) + "notAnEmail";

            instance = openminds.core.ContactInformation("email", literalValue);
            jsonLdDoc = instance.serialize();

            structInstance = openminds.internal.serializer.jsonld2struct( ...
                string(jsonLdDoc));

            testCase.verifyEqual(string(structInstance.email), literalValue);
        end


        function testDatePropertySerializesAsIsoDate(testCase)
            % A property the schema declares as a date is written as
            % "yyyy-MM-dd", the form the reference implementation reads.
            datasetVersion = openminds.core.DatasetVersion( ...
                "releaseDate", datetime(2024, 3, 5));

            jsonLdDoc = string(datasetVersion.serialize());

            testCase.verifyMatches(jsonLdDoc, '"releaseDate":\s*"2024-03-05"');
        end

        function testDateTimePropertySerializesWithOffset(testCase)
            % A date-time with a time zone carries its UTC offset, written
            % as "+00:00" rather than "Z" to match the reference
            % implementation. One without a time zone has no offset.
            withZone = openminds.core.ProtocolExecution( ...
                "startTime", datetime(2023, 2, 7, 16, 0, 0, "TimeZone", "UTC"));
            withoutZone = openminds.core.ProtocolExecution( ...
                "startTime", datetime(2023, 2, 7, 16, 0, 0));

            testCase.verifyMatches(string(withZone.serialize()), ...
                '"startTime":\s*"2023-02-07T16:00:00\+00:00"');
            testCase.verifyMatches(string(withoutZone.serialize()), ...
                '"startTime":\s*"2023-02-07T16:00:00"');
        end

        function testIsoDateTimeWithOffsetDeserializes(testCase)
            % The reference implementation writes date-times with an
            % offset. Both the "+00:00" and the "Z" spelling must load.
            expected = datetime(2023, 2, 7, 16, 0, 0, "TimeZone", "UTC");
            deserializer = openminds.internal.serializer.JsonLdDeserializer();

            for offsetText = ["+00:00", "Z"]
                jsonLdDoc = sprintf(['{"@context":{"@vocab":"https://openminds.om-i.org/props/"},' ...
                    '"@id":"_:1","@type":"https://openminds.om-i.org/types/ProtocolExecution",' ...
                    '"startTime":"2023-02-07T16:00:00%s"}'], offsetText);

                instances = deserializer.deserialize(jsonLdDoc);

                testCase.verifyEqual(instances{1}.startTime, expected, ...
                    "Offset spelling: " + offsetText);
            end
        end

        function testLegacyDateFormatStillDeserializes(testCase)
            % Files written by earlier releases hold dates in the datetime
            % display format. They must keep loading.
            jsonLdDoc = ['{"@context":{"@vocab":"https://openminds.om-i.org/props/"},' ...
                '"@id":"_:1","@type":"https://openminds.om-i.org/types/DatasetVersion",' ...
                '"releaseDate":"05-Mar-2024"}'];
            deserializer = openminds.internal.serializer.JsonLdDeserializer();

            instances = deserializer.deserialize(jsonLdDoc);

            testCase.verifyEqual(instances{1}.releaseDate, datetime(2024, 3, 5));
        end


        function testMultiValuedPrimitiveWithOneValueIsAList(testCase)
            % A property that can hold several values is written as a
            % list even when it holds one, as the reference implementation
            % does. A property that holds at most one value stays a scalar.
            contact = openminds.core.ContactInformation("email", "one@example.org");
            person = openminds.core.Person("givenName", "Solo");

            testCase.verifyMatches(string(contact.serialize()), ...
                '"email":\s*\[\s*"one@example.org"\s*\]');
            testCase.verifyMatches(string(person.serialize()), ...
                '"givenName":\s*"Solo"');
        end


        function testScalarInstanceToDocument(testCase)
            scalarInstanceWithoutLinks = openminds.core.ContactInformation(...
                "email", "test@mail.somewhere");

            serializer = openminds.internal.serializer.JsonLdSerializer(...
                'OutputMode', 'multiple');
            
            jsonLdDoc = scalarInstanceWithoutLinks.serialize("Serializer", serializer);
    
            % Todo: improve this...
            testCase.verifyTrue(contains(jsonLdDoc, '"@context"'))
            testCase.verifyFalse(contains(jsonLdDoc, '"@graph"'))
        end

        function testScalarInstanceToDocumentExpandedPropertySyntax(testCase)
            scalarInstanceWithoutLinks = openminds.core.ContactInformation(...
                "email", "test@mail.somewhere");

            serializer = openminds.internal.serializer.JsonLdSerializer(...
                "PropertyNameSyntax", "expanded", ...
                'OutputMode', 'multiple');
            
            jsonLdDoc = scalarInstanceWithoutLinks.serialize("Serializer", serializer);
    
            % Todo: improve this...
            testCase.verifyFalse(contains(jsonLdDoc, '"@context"'))
            testCase.verifyFalse(contains(jsonLdDoc, '"@graph"'))
        end

        function testScalarInstanceToCollectionDocumentExpandedPropertySyntax(testCase)
            scalarInstanceWithoutLinks = openminds.core.ContactInformation(...
                "email", "VOCAB_URI_test@mail.somewhere");

            serializer = openminds.internal.serializer.JsonLdSerializer(...
                "PropertyNameSyntax", "expanded", ...
                'OutputMode', 'single');
            
            jsonLdDoc = scalarInstanceWithoutLinks.serialize("Serializer", serializer);
    
            % Todo: improve this...
            testCase.verifyFalse(contains(jsonLdDoc, '"@context"'))
            testCase.verifyTrue(contains(jsonLdDoc, '"@graph"'))
        end



        function testInstanceArray(testCase)
            instances = [...
                openminds.core.ContactInformation("email", "test1@mail.somewhere"), ...
                openminds.core.ContactInformation("email", "test2@mail.somewhere") ];

            str = instances.serialize();

            testCase.verifyClass(str, 'cell')
            testCase.verifyLength(str, 2)
            testCase.verifyClass(str{1}, 'char')
        end

        function testInstanceWithLinkedArray(testCase)
            ids = [...
                openminds.core.ORCID("identifier", "https://orcid.org/0000-0000-0000-0000"), ...
                openminds.core.ORCID("identifier", "https://orcid.org/0000-0000-0000-0001")];

            p = openminds.core.Person(...
                "digitalIdentifier", ids);

            str = p.serialize();

            testCase.verifyClass(str, 'cell')
            testCase.verifyLength(str, 3)
            testCase.verifyClass(str{1}, 'char')
        end

        function testCircularGraphSerializesAsReference(testCase)
        % A cycle must close with a reference rather than being followed
        % forever. Two content types referring to each other are the
        % smallest case.

            firstType = openminds.core.data.ContentType();
            firstType.name = "first/type";
            secondType = openminds.core.data.ContentType();
            secondType.name = "second/type";

            firstType.isBasedOn = secondType;
            secondType.isBasedOn = firstType;

            serializer = openminds.internal.serializer.JsonLdSerializer( ...
                'RecursionDepth', 5);
            documents = serializer.serialize(firstType);

            % Each node becomes its own document holding a reference to
            % the other, rather than one being inlined into the other
            % without end.
            testCase.assertNumElements(documents, 2)
            combined = strjoin(documents, newline);
            testCase.verifySubstring(combined, 'first/type')
            testCase.verifySubstring(combined, 'second/type')
            testCase.verifyEqual(count(combined, '"@type"'), 2, ...
                'Each node should appear exactly once, as its own document.')
        end

        function testPropertyHoldingSeveralTypesSerializes(testCase)
        % A property that accepts several types may hold instances of more
        % than one of them at once. Those instances cannot be concatenated
        % into one array, so anything that gathers them has to keep them
        % apart.
        %
        % The round-trip suite does not cover this, because the synthesizer
        % populates such a property with instances of a single allowed
        % type.

            dataset = openminds.core.Dataset();
            dataset.fullName = "Mixed keyword dataset";
            dataset.keyword = { ...
                openminds.controlledterms.AccessChannel("hybridAccess"), ...
                openminds.controlledterms.DataType("associativeArray")};

            documents = openminds.internal.serializer.JsonLdSerializer.serializeToJsonLd( ...
                dataset, 'PrettyPrint', false);

            combined = strjoin(string(documents), newline);
            testCase.verifySubstring(combined, 'instances/accessChannel/hybridAccess')
            testCase.verifySubstring(combined, 'instances/dataType/associativeArray')
        end

        function testEmbeddedScalarIsNotWrappedInAList(testCase)
        % openMINDS documents write an embedded value that can occur only
        % once as a single object. A linked value is written as a list even
        % when there is one of them. Both shapes are pinned here because
        % they are easy to change by accident.

            quantitativeValue = openminds.core.QuantitativeValue();
            quantitativeValue.value = 42;

            specimenAge = openminds.core.SpecimenAge();
            specimenAge.age = quantitativeValue;

            subjectState = openminds.core.SubjectState();
            subjectState.age = specimenAge;

            jsonText = openminds.internal.serializer.JsonLdSerializer.serializeToJsonLd( ...
                subjectState, 'PrettyPrint', false);

            testCase.verifySubstring(jsonText, '"age":{')
            testCase.verifyEmpty(strfind(jsonText, '"age":['), ...
                'An embedded scalar should not be written as a list.')
        end
    end
end
