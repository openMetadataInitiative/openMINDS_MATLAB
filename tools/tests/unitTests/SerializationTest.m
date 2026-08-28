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
