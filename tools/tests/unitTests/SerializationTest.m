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

        function testExpandedJsonLdFileRoundTrip(testCase)
            contact = openminds.core.ContactInformation( ...
                "email", "contact@example.org");
            filePath = "expanded-contact.jsonld";
            metadataStore = openminds.internal.FileMetadataStore( ...
                filePath, ...
                "PropertyNameSyntax", "expanded");

            metadataStore.save(contact);
            loadedInstances = metadataStore.load();

            testCase.verifyEqual(loadedInstances{1}.email, contact.email);
        end

        function testJsonLdCompactionPreservesLiteralValues(testCase)
            contact = openminds.core.ContactInformation( ...
                "email", "https://openminds.om-i.org/props/contact@example.org");
            filePath = string(tempname) + ".jsonld";
            metadataStore = openminds.internal.FileMetadataStore(filePath);

            metadataStore.save(contact);
            loadedInstances = metadataStore.load();

            testCase.verifyEqual(loadedInstances{1}.email, contact.email);
        end
    end
end
