classdef CollectionTest < matlab.unittest.TestCase
% CollectionTest - Unit tests for the openminds metadata collection class
    
    methods (TestMethodSetup)
        function createTempDir(testCase)
            import matlab.unittest.fixtures.WorkingFolderFixture
            testCase.applyFixture(WorkingFolderFixture)
        end
    end
    
    methods (Test)
        function testCreateEmptyCollection(testCase)
            % Test creating an empty collection
            collection = openminds.Collection();
            testCase.verifyEqual(length(collection), 0);
            testCase.verifyEqual(collection.Name, "");
            testCase.verifyEqual(collection.Description, "");
        end
        
        function testCreateCollectionWithNameAndDescription(testCase)
            % Test creating a collection with name and description
            collection = openminds.Collection('Name', "Test Collection", ...
                'Description', "A test collection");
            testCase.verifyEqual(collection.Name, "Test Collection");
            testCase.verifyEqual(collection.Description, "A test collection");
        end
        
        function testCreateCollectionWithInstances(testCase)
            % Test creating a collection with instances
            [person, affiliation] = personWithOneAffiliation();

            if ommtest.oneoffs.currentSchemaMajorVersion() >= 5
                collection = openminds.Collection(person, affiliation);
                expectedNumNodes = 6;
                % Person, ContactInformation, ORCID, Affiliation, Organization, RORID
            else
                collection = openminds.Collection(person);
                expectedNumNodes = 5;
                % Person, ContactInformation, Organization, ORCID, RORID
            end

            testCase.verifyEqual(length(collection), expectedNumNodes);

            testCase.verifyTrue(collection.isKey(person.id));
        end
        
        function testAddNodeWithoutLinks(testCase)
            % Test adding a node without links
            collection = openminds.Collection();
            person = openminds.core.Person(...
                'familyName', "Doe", ...
                'givenName', "Jane");
            
            collection.add(person);
            
            testCase.verifyEqual(length(collection), 1); % Person
            testCase.verifyTrue(collection.isKey(person.id));
        end
        
        function testAddNodeWithLinkedType(testCase)
            % Test adding a node with linked types
            collection = openminds.Collection();
            [person, affiliation] = personWithOneAffiliation();

            if ommtest.oneoffs.currentSchemaMajorVersion() >= 5
                collection.add(affiliation);
                org = affiliation.organization;
            else
                collection.add(person);
                org = person.affiliation.memberOf;
            end
            
            % Verify that the linked nodes are also added to the collection
            testCase.verifyGreaterThan(length(collection), 1);
            testCase.verifyTrue(collection.isKey(person.id));

            testCase.verifyTrue(collection.isKey(org.id));
        end
        
        function testAddNodeWithEmbeddedType(testCase)
            % Test adding a node with embedded types
            collection = openminds.Collection();

            if ommtest.oneoffs.currentSchemaMajorVersion() >= 5
                [dataset, affiliation] = CollectionTest.datasetWithOneContributorAffiliation();
                collection.add(dataset);
            else
                person = personWithOneAffiliation();
                collection.add(person);
                affiliation = person.affiliation;
            end

            % Affiliation is embedded in the containing schema, so the
            % affiliation node itself should not be stored in the collection.
            testCase.verifyFalse(collection.isKey(affiliation.id));
        end
        
        function testLength(testCase)
            % Test the length method
            collection = openminds.Collection();
            testCase.verifyEqual(length(collection), 0);
            
            org = organizationWithOneId();
            collection.add(org);
            testCase.verifyEqual(length(collection), 2); % Organization and RORID
            
            person = personWithOneAffiliation();
            collection.add(person);
            testCase.verifyGreaterThan(length(collection), 2);
        end
        
        function testIsKey(testCase)
            % Test the isKey method
            collection = openminds.Collection();
            org = organizationWithOneId();
            
            testCase.verifyFalse(collection.isKey(org.id));
            
            collection.add(org);
            testCase.verifyTrue(collection.isKey(org.id));
            testCase.verifyFalse(collection.isKey("nonexistent-id"));
        end
        
        function testContains(testCase)
            % Test the contains method
            collection = openminds.Collection();
            org = organizationWithOneId();
            
            testCase.verifyFalse(collection.contains(org));
            
            collection.add(org);
            testCase.verifyTrue(collection.contains(org));
        end
        
        function testRemoveNode(testCase)
            % Test removing a node
            collection = openminds.Collection();
            person = personWithOneAffiliation();
            
            collection.add(person);
            initialLength = length(collection);
            
            % Remove the person
            collection.remove(person);
            
            % Verify that the person is removed
            testCase.verifyEqual(length(collection), initialLength - 1);
            testCase.verifyFalse(collection.isKey(person.id));
            
            % Verify that linked nodes still remain
            contactInfo = person.contactInformation;
            testCase.verifyTrue(collection.isKey(contactInfo.id));
        end
        
        function testRemoveNodeById(testCase)
            % Test removing a node by ID
            collection = openminds.Collection();
            person = personWithOneAffiliation();
            
            collection.add(person);
            initialLength = length(collection);
            
            % Remove the person by ID
            collection.remove(person.id);
            
            % Verify that the person is removed
            testCase.verifyEqual(length(collection), initialLength - 1);
            testCase.verifyFalse(collection.isKey(person.id));
        end
        
        function testGet(testCase)
            % Test getting a node
            collection = openminds.Collection();
            org = organizationWithOneId();
            
            collection.add(org);
            
            % Get the organization
            retrievedOrg = collection.get(org.id);
            
            % Verify that the retrieved organization is the same as the original
            testCase.verifyEqual(retrievedOrg.id, org.id);
            testCase.verifyEqual( ...
                ommtest.oneoffs.organizationName(retrievedOrg), ...
                ommtest.oneoffs.organizationName(org));
        end
        
        function testHasType(testCase)
            % Test the hasType method
            collection = openminds.Collection();
            
            % Verify that the collection does not have any types
            testCase.verifyFalse(collection.hasType("Person"));
            
            % Add a person
            person = personWithOneAffiliation();
            collection.add(person);
            
            % Verify that the collection has the Person type
            testCase.verifyTrue(collection.hasType(openminds.enum.Types.Person));
        end
        
        function testList(testCase)
            % Test the list method
            collection = openminds.Collection();
            
            % Add two persons
            person1 = personWithOneAffiliation();
            person1.familyName = "Smith";
            collection.add(person1);
            
            person2 = personWithOneAffiliation();
            person2.familyName = "Johnson";
            collection.add(person2);
            
            % List all persons
            persons = collection.list("Person");
            testCase.verifyEqual(length(persons), 2);
            
            % List persons with a specific family name
            smiths = collection.list("Person", "familyName", "Smith");
            testCase.verifyEqual(length(smiths), 1);
            testCase.verifyEqual(smiths.familyName, "Smith");
        end
        
        function testUpdateLinks(testCase)
            % Test the updateLinks method
            collection = openminds.Collection();
            person = personWithOneAffiliation();
            
            % Add only the person without linked types
            collection.add(person);
            initialLength = length(collection);
            
            newContact = openminds.core.ContactInformation( ...
                "email", "john.smith@somewhere-else.org");
            person.contactInformation = newContact;
            
            % Update links
            collection.updateLinks();
            
            % Verify that linked types are added
            testCase.verifyGreaterThan(length(collection), initialLength);
            testCase.verifyTrue(collection.isKey(newContact.id));
        end
        
        function testSaveAndLoad(testCase)
            % Test saving and loading a collection
            collection = openminds.Collection();
            person = personWithOneAffiliation();
            org = organizationWithOneId();
            
            collection.add(person, org);
            
            % Save the collection to a file
            filePath = 'collection.jsonld';
            collection.save(filePath);
            
            % Verify that the file exists
            testCase.verifyTrue(isfile(filePath));
            
            % Create a new collection and load the file
            newCollection = openminds.Collection();
            newCollection.load(filePath);
            
            % Verify that the new collection has the same instances
            testCase.verifyEqual(length(newCollection), length(collection));
            testCase.verifyTrue(newCollection.isKey(person.id));
            testCase.verifyTrue(newCollection.isKey(org.id));
        end
        
        function testSaveWithMetadataStoreOption(testCase)
        % A store passed to save by name-value must be the store used.
        % This went through obj.MetadataStore instead, which is empty
        % unless the collection was constructed with one.

            personInstance = openminds.core.Person('givenName', "Store");
            collection = openminds.Collection(personInstance);

            filePath = fullfile(pwd, "via-option.jsonld"); % WorkingFolderFixture cwd
            fileStore = openminds.internal.FileMetadataStore(filePath);

            collection.save("", "MetadataStore", fileStore);

            testCase.verifyTrue(isfile(filePath), ...
                'The store passed by name-value should have been used to save.')
        end

        function testSaveToMultipleFiles(testCase)
            % Test saving a collection to multiple files
            collection = openminds.Collection();
            person = personWithOneAffiliation();
            org = organizationWithOneId();
            
            collection.add(person, org);
            
            % Save the collection to multiple files
            folderPath = 'collection';
            mkdir(folderPath);
            collection.save(folderPath);
            
            % Verify that files are created
            files = dir(fullfile(folderPath, '**', '*.jsonld'));
            testCase.verifyEqual(length(files), length(collection));
            
            % Create a new collection and load the files
            newCollection = openminds.Collection();
            newCollection.load(folderPath);
            
            % Verify that the new collection has the same instances
            testCase.verifyEqual(length(newCollection), length(collection));
            testCase.verifyTrue(newCollection.isKey(person.id));
            testCase.verifyTrue(newCollection.isKey(org.id));
        end
        
        function testLoadInstances(testCase)
            % Test the loadInstances static method
            collection = openminds.Collection();
            person = personWithOneAffiliation();
            org = organizationWithOneId();
            
            collection.add(person, org);
            expectedNumDocuments = length(collection);
            
            % Save the collection to a file
            filePath = 'collection.jsonld';
            collection.save(filePath);

            % Create a new collection from that file
            fileStore = openminds.internal.FileMetadataStore(filePath);
            newCollection = openminds.Collection.fromStore(fileStore);
            instances = newCollection.getAll();
            
            % Verify that instances are loaded
            testCase.verifyEqual(length(instances), expectedNumDocuments);
        end
        
        function testCreateCollectionFromMultipleFiles(testCase)
            % A collection constructed from several files loads each of
            % them, rather than only the first.
            firstContact = openminds.core.ContactInformation( ...
                "email", "first@example.org");
            secondContact = openminds.core.ContactInformation( ...
                "email", "second@example.org");

            firstFilePath = "first-contact.jsonld";
            secondFilePath = "second-contact.jsonld";
            openminds.internal.FileMetadataStore(firstFilePath).save(firstContact);
            openminds.internal.FileMetadataStore(secondFilePath).save(secondContact);

            collection = openminds.Collection(firstFilePath, secondFilePath);

            testCase.verifyEqual(length(collection), 2);
            testCase.verifyTrue(collection.isKey(firstContact.id));
            testCase.verifyTrue(collection.isKey(secondContact.id));
        end

        function testFolderStoreSavesScalarInstance(testCase)
            % A single instance serializes to one document rather than a
            % cell, which the folder store must still handle.
            contact = openminds.core.ContactInformation( ...
                "email", "scalar@example.org");
            metadataStore = openminds.internal.FolderMetadataStore( ...
                "scalar-folder-store");

            outputPaths = metadataStore.save(contact);

            testCase.verifyEqual(numel(outputPaths), 1);
            testCase.verifyTrue(isfile(outputPaths{1}));
        end

        function testFolderStoreOmitsBlankNodePrefixFromFilename(testCase)
            % A blank node identifier is prefixed with "_:". Both
            % characters would otherwise be sanitized into separators,
            % leaving the type and the identifier three underscores apart.
            contact = openminds.core.ContactInformation( ...
                "email", "prefix@example.org");
            metadataStore = openminds.internal.FolderMetadataStore( ...
                "blank-node-folder-store");

            outputPaths = metadataStore.save(contact);

            [~, fileName] = fileparts(outputPaths{1});
            expectedName = "ContactInformation_" + extractAfter(contact.id, "_:");
            testCase.verifyEqual(string(fileName), expectedName);

            % The identifier lives in the document, so the instance still
            % round-trips regardless of what the file is called.
            reloaded = metadataStore.load();
            testCase.verifyEqual(reloaded{1}.id, contact.id);
        end

        function testFolderStoreSavesEveryLinkedNode(testCase)
            % Saving an instance to a folder also saves everything it
            % links to, each as a file of its own, so the references in
            % the saved documents can be followed when the folder is
            % loaded again.
            identifier = openminds.core.ORCID( ...
                "identifier", "https://orcid.org/0000-0000-0000-0000");
            contact = openminds.core.ContactInformation( ...
                "email", "linked@example.org");
            person = openminds.core.Person( ...
                "digitalIdentifier", identifier, ...
                "contactInformation", contact);

            folderPath = "linked-folder-store";
            metadataStore = openminds.internal.FolderMetadataStore(folderPath);

            outputPaths = metadataStore.save(person);

            files = dir(fullfile(folderPath, "*.jsonld"));
            testCase.verifyEqual(numel(outputPaths), 3);
            testCase.verifyEqual(numel(files), 3);
            testCase.verifyTrue(any(contains(string(outputPaths), "Person_")));
            testCase.verifyTrue(any(contains(string(outputPaths), "ORCID_")));
            testCase.verifyTrue(any(contains(string(outputPaths), "ContactInformation_")));

            reloaded = metadataStore.load();
            isPerson = cellfun(@(x) isa(x, 'openminds.core.Person'), reloaded);
            reloadedPerson = reloaded{isPerson};
            testCase.verifyEqual(reloadedPerson.contactInformation.email, contact.email, ...
                'The saved link was not followed on load.');
        end

        function testFolderStoreRejectsRecursingSerializer(testCase)
            % The store names each file after the instance its document
            % came from, so a serializer that emits extra documents by
            % recursing into links on its own cannot be paired with
            % instances and is refused. Controlled instances are kept
            % out of the collection here so the serializer finds a link
            % the store did not flatten.
            original = openminds.getpref('AddControlledInstanceToCollection');
            testCase.addTeardown(@() openminds.setpref( ...
                'AddControlledInstanceToCollection', original));
            openminds.setpref('AddControlledInstanceToCollection', false);

            subject = openminds.core.Subject();
            subject.species = ommtest.helper.controlledInstance( ...
                "openminds.controlledterms.Species", "Homo sapiens");

            metadataStore = openminds.internal.FolderMetadataStore( ...
                "recursing-serializer-folder-store", "Serializer", ...
                ommtest.helper.mock.MockTextSerializer("RecursionDepth", 1));

            testCase.verifyError(@() metadataStore.save(subject), ...
                'openminds:FolderMetadataStore:DocumentCountMismatch');
        end

        function testFolderStoreFilenamesDoNotDependOnJsonLd(testCase)
            % The filename for a document is derived from the instance
            % that produced it, not by decoding the document, so a
            % serializer that is not JsonLdSerializer - such as one
            % written against an external format - still gets sensible,
            % type-based filenames, and the linked node is still saved.
            identifier = openminds.core.ORCID( ...
                "identifier", "https://orcid.org/0000-0000-0000-0000");
            person = openminds.core.Person("digitalIdentifier", identifier);

            metadataStore = openminds.internal.FolderMetadataStore( ...
                "non-jsonld-folder-store", "Serializer", ...
                ommtest.helper.mock.MockTextSerializer("RecursionDepth", 0));

            outputPaths = metadataStore.save(person);

            testCase.verifyEqual(numel(outputPaths), 2);
            testCase.verifyTrue(all(isfile(string(outputPaths))));
            testCase.verifyTrue(all(endsWith(string(outputPaths), ".mocktext")));
            testCase.verifyTrue(any(contains(string(outputPaths), "Person_")));
            testCase.verifyTrue(any(contains(string(outputPaths), "ORCID_")));
        end

        function testFolderStoreSavesColumnOfInstances(testCase)
            % Collection.getAll returns a column cell, so the instances a
            % store is given are often column-shaped. Each, with its
            % links, is saved whatever the shape.
            firstPerson = openminds.core.Person("givenName", "A", ...
                "digitalIdentifier", openminds.core.ORCID( ...
                "identifier", "https://orcid.org/0000-0000-0000-0001"));
            secondPerson = openminds.core.Person("givenName", "B", ...
                "digitalIdentifier", openminds.core.ORCID( ...
                "identifier", "https://orcid.org/0000-0000-0000-0002"));

            metadataStore = openminds.internal.FolderMetadataStore( ...
                "column-folder-store");

            outputPaths = metadataStore.save({firstPerson; secondPerson});

            testCase.verifyEqual(numel(outputPaths), 4);
            testCase.verifyEqual(nnz(contains(string(outputPaths), "Person_")), 2);
            testCase.verifyEqual(nnz(contains(string(outputPaths), "ORCID_")), 2);
        end

        function testFolderStoreWritesUnresolvedLinkAsReference(testCase)
            % A link to a node that is not present, held as an untyped
            % reference, is written as a reference in the linking document
            % and gets no file of its own.
            referenceIRI = "https://graph.example/instances/doi-001";
            dataset = openminds.core.Dataset("fullName", "D");
            dataset.digitalIdentifier = openminds.internal.MixedTypeReference(referenceIRI);

            metadataStore = openminds.internal.FolderMetadataStore( ...
                "unresolved-link-folder-store");

            outputPaths = metadataStore.save(dataset);

            testCase.verifyEqual(numel(outputPaths), 1);
            testCase.verifyTrue(contains(string(outputPaths{1}), "Dataset_"));
            testCase.verifyTrue(contains(fileread(outputPaths{1}), referenceIRI));
        end

        function testUnresolvedLinkIsNotANode(testCase)
            % An untyped reference to a node that is not present is a
            % placeholder, not a node: it is not counted, and saving the
            % collection to a single file writes it as a reference in the
            % linking document rather than failing on it.
            referenceIRI = "https://graph.example/instances/doi-001";
            dataset = openminds.core.Dataset("fullName", "D");
            dataset.digitalIdentifier = openminds.internal.MixedTypeReference(referenceIRI);

            collection = openminds.Collection(dataset);
            testCase.verifyEqual(length(collection), 1);

            filePath = "unresolved-link-collection.jsonld";
            collection.save(filePath);

            document = fileread(filePath);
            testCase.verifyTrue(contains(document, referenceIRI));
            testCase.verifyFalse(contains(document, "MixedTypeReference"));
        end

        function testTypedReferenceSurvivesRoundTrip(testCase)
            % A reference whose type is known is still a reference, not a
            % node with no properties. It gets no file of its own, so
            % loading the folder again gives back a reference rather than
            % an empty node that the reference silently turned into.
            referenceIRI = "https://graph.example/instances/contact-001";
            person = openminds.core.Person("givenName", "A");
            person.contactInformation = openminds.core.ContactInformation( ...
                "id", referenceIRI);
            testCase.assumeTrue(person.contactInformation.isReference());

            metadataStore = openminds.internal.FolderMetadataStore( ...
                "typed-reference-folder-store");

            outputPaths = metadataStore.save(person);
            testCase.verifyEqual(numel(outputPaths), 1);
            testCase.verifyTrue(contains(string(outputPaths{1}), "Person_"));

            reloaded = metadataStore.load();
            testCase.assertEqual(numel(reloaded), 1);
            reloadedLink = reloaded{1}.contactInformation;
            testCase.verifyTrue(reloadedLink.isReference());
            testCase.verifyEqual(string(reloadedLink.id), referenceIRI);
        end

        function testSaveEmptyCollection(testCase)
            % A collection with no nodes still saves, giving an empty
            % collection document.
            collection = openminds.Collection();
            filePath = "empty-collection.jsonld";

            outputPaths = collection.save(filePath);

            testCase.verifyTrue(isfile(filePath));
            testCase.verifyEqual(string(outputPaths{1}), filePath);
        end

        function testFileStoreRoundTripsSupplementaryCharacters(testCase)
            % A character outside the Basic Multilingual Plane is encoded
            % as four bytes in UTF-8 and must survive a write and a read
            % through the store.
            brainEmoji = char([55358 56800]); % U+1F9E0 as a surrogate pair
            givenName = "Mät " + brainEmoji;
            person = openminds.core.Person("givenName", givenName);
            metadataStore = openminds.internal.FileMetadataStore( ...
                "supplementary-characters.jsonld");

            metadataStore.save(person);
            reloaded = metadataStore.load();

            testCase.verifyEqual(reloaded{1}.givenName, givenName);
        end

        function testSaveInstances(testCase)
            % Tests saving instances with MetadataStore
            person = personWithOneAffiliation();
            org = organizationWithOneId();
            collection = openminds.Collection(person, org);
            expectedNumDocuments = length(collection);
            
            % Save instances to a file
            filePath = 'instances.jsonld';
            metadataStore = openminds.internal.FileMetadataStore(filePath, "RecursionDepth", 999);
            metadataStore.save({person, org});
            
            testCase.verifyTrue(isfile(filePath));

            instances = metadataStore.load();
            
            % Verify that instances are loaded
            testCase.verifyEqual(length(instances), expectedNumDocuments);
        end
        
        % % function testGetBlankNodeIdentifier(testCase)
        % %     % Test the getBlankNodeIdentifier method
        % %     collection = openminds.Collection();
        % % 
        % %     % Get a blank node identifier using reflection
        % %     identifier = collection.getBlankNodeIdentifier();
        % % 
        % %     % Verify that the identifier is a string and starts with "_:"
        % %     testCase.verifyTrue(isstring(identifier) || ischar(identifier));
        % %     testCase.verifyTrue(startsWith(char(identifier), '_:'));
        % % end
    end
    
    methods (Static, Access = private)
        function [dataset, affiliation] = datasetWithOneContributorAffiliation()
            [person, affiliation] = personWithOneAffiliation();
            contribution = openminds.core.Contribution( ...
                "contributor", person, ...
                "type", openminds.controlledterms.ContributionType( ...
                    [], "name", "authoring"));

            dataset = openminds.core.Dataset( ...
                "contribution", contribution, ...
                "contributorAffiliation", affiliation, ...
                "description", "Test dataset", ...
                "fullName", "Test dataset", ...
                "shortName", "test-dataset");
        end
    end
end
