classdef testLinkedCategory < matlab.unittest.TestCase
    
    % Todo: 
    %  [ ] Test hetereogeneous linked types.
    %  [ ] Test multiple nested linked categories.
    %  [ ] Test assigning of properties to linked categories

    
    
    properties
        % DatasetWithOnePersonAuthor - A dataset instance with a single
        % author which is of type Person
        DatasetWithOnePersonAuthor

        % DatasetWithTwoPersonAuthor - A dataset instance with a two
        % authors which is of type Person
        DatasetWithTwoPersonAuthor
    end


    methods(TestClassSetup)
        % Shared setup for the entire test class

        function initializeInstances(testCase)

            % Create a dataset with one author of type Person
            ds = openminds.core.Dataset();
            ds.author = personWithOneAffiliation;

            testCase.DatasetWithOnePersonAuthor = ds;

            % Create a dataset and add two persons as authors.
            ds = openminds.core.Dataset();
            person1 = personWithOneAffiliation;
            person2 = personWithTwoAffiliations;
            ds.author = [person1, person2];

            testCase.DatasetWithTwoPersonAuthor = ds;
        end
    end
    
    methods(TestMethodSetup)
        % Setup for each test
    end
    
    methods(Test)
        % Test methods
        
        function testRetrieveScalarHomogeneousType(testCase) %#ok<*MANU>
            
            % Get dataset for testing
            ds = testCase.DatasetWithOnePersonAuthor;

            author = ds.author;
            expectedAuthorType = 'openminds.internal.mixedtype.dataset.Author';
            
            testCase.assertClass(author, expectedAuthorType)
        end

        function testRetrieveNestedScalarHomogeneousType(testCase)
            % Get dataset for testing
            ds = testCase.DatasetWithOnePersonAuthor;

            organization = ds.author.affiliation.memberOf;
        end

        function testRetrievePropertyOfNestedScalarHomogeneousType(testCase)
            % Get dataset for testing
            ds = testCase.DatasetWithOnePersonAuthor;

            organizationName = ds.author.affiliation.memberOf.fullName;
        end

        function testRetrieveNonScalarHomogeneousType(testCase)
        % Test the retrieval of a linked type property which is a linked
        % category non-scalar instance array.

            ds = testCase.DatasetWithTwoPersonAuthor;

            % Check type of author property
            author = ds.author;
            expectedAuthorType = 'openminds.internal.mixedtype.dataset.Author';
            testCase.assertClass(author, expectedAuthorType)
        end

        function testRetrieveNonScalarHomogeneousTypeParenOne(testCase)
            % Check type of author when using parenthesis indexing on
            % single element

            % Todo: What should be expected here ?
            ds = testCase.DatasetWithTwoPersonAuthor;
            author = ds.author;

            expectedParenIndexedType = 'openminds.core.actors.Person';
            testCase.assertClass(author(1), expectedParenIndexedType)
        end

        function testRetrieveNonScalarHomogeneousTypeParenAll(testCase)
            % Check type of author when using parenthesis indexing on
            % all elements of array

            ds = testCase.DatasetWithTwoPersonAuthor;
            author = ds.author;
            
            expectedParenIndexedType = 'openminds.core.actors.Person';
            testCase.assertClass(author(:), expectedParenIndexedType)
        end

        function testNonScalarHomogeneousTypeLength(testCase)
            ds = testCase.DatasetWithTwoPersonAuthor;
            author = ds.author;
            
            % Test length of array
            testCase.assertLength(author, 2)

            % Test length of array using parenthesis indexing
            testCase.assertLength(author(:), 2)
        end

        function testRetreivePropertyOfScalarLinkedCategoryType(testCase)
            
            % Get dataset for testing
            ds = testCase.DatasetWithOnePersonAuthor;
            author = ds.author;
            
            try
                authorName = author.givenName;
                testCase.assertClass(authorName, "string")
            catch
                error('openMINDS:LinkedCategorySubsrefFailed', ...
                    'Failed to retrieve property from author')
            end
        end

    end
    
end