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
            person = personWithOneAffiliation();
            %org = organizationWithOneId();
            
            collection = openminds.Collection(person);
            
            testCase.verifyEqual(length(collection), 5); 
            % Person, ContactInformation, Organization, ORCID, RORID

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
            person = personWithOneAffiliation();
            
            collection.add(person);
            
            % Verify that the linked nodes are also added to the collection
            testCase.verifyGreaterThan(length(collection), 1);
            testCase.verifyTrue(collection.isKey(person.id));
            
            % Get the affiliation from the person
            affiliation = person.affiliation;

            % Get the organization from the affiliation
            org = affiliation.memberOf;
            testCase.verifyTrue(collection.isKey(org.id));
        end
        
        function testAddNodeWithEmbeddedType(testCase)
            % Test adding a node with embedded types
            collection = openminds.Collection();
            person = personWithOneAffiliation();
            
            collection.add(person);
            
            % Get the affiliation from the person
            affiliation = person.affiliation;

            % Affiliation is embedded, verify that it's key is not in the
            % collection
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
            testCase.verifyEqual(retrievedOrg.fullName, org.fullName);
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
            
            newAffiliation = openminds.core.Affiliation(...
                'memberOf', openminds.core.Organization('fullName', 'University of Somewhere'), ...
                'startDate', datetime("yesterday"));
            person.affiliation(end+1) = newAffiliation;
            
            % Update links
            collection.updateLinks();
            
            % Verify that linked types are added
            testCase.verifyGreaterThan(length(collection), initialLength);
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
            testCase.verifyGreaterThan(length(files), 0);
            
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
            
            % Save the collection to a file
            filePath = 'collection.jsonld';
            collection.save(filePath);

            % Create a new collection from that file
            fileStore = openminds.internal.FileMetadataStore(filePath);
            newCollection = openminds.Collection.fromStore(fileStore);
            instances = newCollection.getAll();
            
            % Verify that instances are loaded
            testCase.verifyGreaterThan(length(instances), 0);
        end
        
        function testSaveInstances(testCase)
            % Test the saveInstances static method
            person = personWithOneAffiliation();
            org = organizationWithOneId();
            
            % Save instances to a file
            filePath = 'instances.jsonld';
            metadataStore = openminds.internal.FileMetadataStore(filePath, "RecursionDepth", 999);
            metadataStore.save({person, org})
            
            testCase.verifyTrue(isfile(filePath));

            instances = metadataStore.load();
            
            % Verify that instances are loaded
            testCase.verifyGreaterThan(length(instances), 0);
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
        function person = personWithOneAffiliation()
            % Create a person with one affiliation
            ror = openminds.core.RORID('identifier','https://ror.org/02jx3x895');
            org = openminds.core.Organization('digitalIdentifier',ror,...
                'fullName','University College London');
            
            af = openminds.core.Affiliation('memberOf', org);
            
            orcid = openminds.core.ORCID('identifier',...
                'https://orcid.org/0000-0000-0000-0000');
            
            contact = openminds.core.ContactInformation('email',...
                'johndsmith@somewhere.org');
            
            person = openminds.core.Person('familyName','Smith','givenName','John D.',...
                'alternateName', "js", 'affiliation',af,'digitalIdentifier',orcid,...
                'contactInformation',contact);
        end
        
        function org = organizationWithOneId()
            % Create an organization with one digital ID
            ror = openminds.core.RORID('identifier','https://ror.org/01xtthb56');
            
            org = openminds.core.Organization('digitalIdentifier', ror,...
                'fullName','University of Oslo');
        end
    end
end
