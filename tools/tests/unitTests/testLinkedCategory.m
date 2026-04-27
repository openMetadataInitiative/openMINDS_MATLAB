classdef testLinkedCategory < matlab.unittest.TestCase
    
    % Todo:
    %  HETEROGENEOUS
    %
    %  [ ] Test hetereogeneous linked types.
    %  [ ] Test multiple nested linked categories.
    %  [ ] Test assigning of properties to linked categories
    %   
    %  HOMOGENEOUS
    
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
            if ommtest.oneoffs.currentSchemaMajorVersion() >= 5
                [person, affiliation] = personWithOneAffiliation();
                ds = testLinkedCategory.createDatasetWithContributors(person, affiliation);
            else
                ds = openminds.core.Dataset();
                ds.author = personWithOneAffiliation;
            end

            testCase.DatasetWithOnePersonAuthor = ds;

            % Create a dataset and add two persons as authors.
            if ommtest.oneoffs.currentSchemaMajorVersion() >= 5
                [person1, affiliation1] = personWithOneAffiliation();
                [person2, affiliations2] = personWithTwoAffiliations();
                ds = testLinkedCategory.createDatasetWithContributors( ...
                    [person1, person2], [affiliation1, affiliations2]);
            else
                ds = openminds.core.Dataset();
                person1 = personWithOneAffiliation;
                person2 = personWithTwoAffiliations;
                ds.author = [person1, person2];
            end

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

            author = testLinkedCategory.getAuthors(ds);
            expectedAuthorType = 'openminds.core.actors.Person';
            
            testCase.assertClass(author, expectedAuthorType)
        end

        function testRetrieveNestedScalarHomogeneousType(testCase)
            % Get dataset for testing
            ds = testCase.DatasetWithOnePersonAuthor;
            organization = testLinkedCategory.getOrganizations(ds);
            if ~isempty(organization)
                testCase.assertClass(organization, 'openminds.core.actors.Organization')
            end
        end

        function testRetrievePropertyOfNestedScalarHomogeneousType(testCase)
            % Get dataset for testing
            ds = testCase.DatasetWithOnePersonAuthor;

            organization = testLinkedCategory.getOrganizations(ds);
            organizationName = ommtest.oneoffs.organizationName(organization);
            testCase.assertClass(organizationName, "string")
            
            % Alternative: This does not work.
            % thisAuthor = ds.author;
            % thisOrganizationName = thisAuthor.affiliation.memberOf.fullName;
        end

        function testRetrievePropertyOfNestedNonScalarHomogeneousType(testCase)
            % Get dataset for testing
            ds = testCase.DatasetWithTwoPersonAuthor;

            affiliationList = testLinkedCategory.getAffiliations(ds);
            organizationList = testLinkedCategory.getOrganizations(ds);
            organizationName = arrayfun( ...
                @ommtest.oneoffs.organizationName, organizationList);
            
            testCase.assertClass(organizationName, 'string')
            
            testCase.assertLength(affiliationList, 3)
        end

        function testRetrieveNonScalarHomogeneousType(testCase)
        % Test the retrieval of a linked type property which is a linked
        % category non-scalar instance array.

            ds = testCase.DatasetWithTwoPersonAuthor;

            % Check type of author property
            author = testLinkedCategory.getAuthors(ds);
            expectedAuthorType = 'openminds.core.actors.Person';
            testCase.assertClass(author, expectedAuthorType)
        end

        function testRetrieveNonScalarHomogeneousTypeParenOne(testCase)
            % Check type of author when using parenthesis indexing on
            % single element

            % Todo: What should be expected here ?
            ds = testCase.DatasetWithTwoPersonAuthor;
            author = testLinkedCategory.getAuthors(ds);

            expectedParenIndexedType = 'openminds.core.actors.Person';
            testCase.assertClass(author(1), expectedParenIndexedType)
        end

        function testRetrieveNonScalarHomogeneousTypeParenAll(testCase)
            % Check type of author when using parenthesis indexing on
            % all elements of array

            ds = testCase.DatasetWithTwoPersonAuthor;
            author = testLinkedCategory.getAuthors(ds);
            
            expectedParenIndexedType = 'openminds.core.actors.Person';
            testCase.assertClass(author(:), expectedParenIndexedType)
        end

        function testNonScalarHomogeneousTypeLength(testCase)
            ds = testCase.DatasetWithTwoPersonAuthor;
            author = testLinkedCategory.getAuthors(ds);
            
            % Test length of array
            testCase.assertLength(author, 2)

            % Test length of array using parenthesis indexing
            testCase.assertLength(author(:), 2)
        end

        function testRetreivePropertyOfScalarLinkedCategoryType(testCase)
            
            % Get dataset for testing
            ds = testCase.DatasetWithOnePersonAuthor;
            author = testLinkedCategory.getAuthors(ds);
            
            try
                authorName = author.givenName;
                testCase.assertClass(authorName, "string")
            catch
                error('openMINDS:LinkedCategorySubsrefFailed', ...
                    'Failed to retrieve property from author')
            end
        end
    end

    methods (Static, Access = private)
        function ds = createDatasetWithContributors(persons, affiliations)
            contribution = openminds.core.Contribution( ...
                "contributor", persons, ...
                "type", openminds.controlledterms.ContributionType( ...
                    [], "name", "authoring"));

            ds = openminds.core.Dataset( ...
                "contribution", contribution, ...
                "contributorAffiliation", affiliations, ...
                "description", "Test dataset", ...
                "fullName", "Test dataset", ...
                "shortName", "test-dataset");
        end

        function authors = getAuthors(ds)
            if ommtest.oneoffs.currentSchemaMajorVersion() >= 5
                authors = [ds.contribution.contributor];
            else
                authors = ds.author;
            end
        end

        function affiliations = getAffiliations(ds)
            if ommtest.oneoffs.currentSchemaMajorVersion() >= 5
                affiliations = ds.contributorAffiliation;
            else
                affiliations = [ds.author.affiliation];
            end
        end

        function organizations = getOrganizations(ds)
            affiliations = testLinkedCategory.getAffiliations(ds);

            if ommtest.oneoffs.currentSchemaMajorVersion() >= 5
                organizations = [affiliations.organization];
            else
                organizations = [affiliations.memberOf];
            end
        end
    end
end
