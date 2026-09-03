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
