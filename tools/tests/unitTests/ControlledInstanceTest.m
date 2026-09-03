classdef ControlledInstanceTest < matlab.unittest.TestCase

    properties (TestParameter)
        instanceSpecification = { {'adult', "AgeCategory", "controlledTerms"} }
        versionNumber = {3, "latest"}
    end

    methods (TestClassSetup)
        function setupClass(testCase)
            testCase.applyFixture(matlab.unittest.fixtures.WorkingFolderFixture)
        end
    end

    methods (Test)
        function testGetControlledInstanceLocal(testCase, instanceSpecification, versionNumber)
            jsonStr = openminds.internal.getControlledInstance(...
                instanceSpecification{:}, versionNumber, "FileSource", "local");
            
            expectedIdUriPrefix = sprintf("%s/instances", openminds.constant.BaseURI(versionNumber));
            testCase.assertTrue(contains(jsonStr.at_id, expectedIdUriPrefix));
        end

        function testApostrophesInDefinitionsAreNotDoubled(testCase)
        % Apostrophes inside JSON values survive decoding unchanged, so a
        % definition written as 'associative array' reads back with single
        % apostrophes. The offline and online readers must agree here, so
        % an instance decodes the same way wherever its file came from.

            term = openminds.controlledterms.DataType("associativeArray");

            testCase.verifyTrue(contains(term.definition, "'associative array'"), ...
                'The definition should contain the apostrophes as written in the file.')
            testCase.verifyFalse(contains(term.definition, "''"), ...
                'Apostrophes inside values must not be doubled by the reader.')
        end

        function testResolvedInstanceCarriesFileContent(testCase)
        % Resolving a controlled instance IRI populates the instance from
        % the library file, keeping the identifier and enriching values.

            IRI = "https://openminds.om-i.org/instances/dataType/associativeArray";
            instance = openminds.instanceFromIRI(IRI);

            testCase.verifyEqual(string(instance.id), IRI)
            testCase.verifyEqual(instance.name, "associative array")
            testCase.verifyFalse(contains(instance.definition, "''"))
        end

        function testFromNameCarriesFileIdentifier(testCase)
        % A controlled instance built by name through the mixin gets its
        % identifier from the library file rather than a generated one.

            instanceNames = openminds.core.data.ContentType.listInstances();
            testCase.assumeNotEmpty(instanceNames, ...
                'No controlled ContentType instances available locally.')

            instance = openminds.core.data.ContentType.fromName(instanceNames(1));

            testCase.verifyTrue(startsWith(string(instance.id), ...
                "https://openminds.om-i.org/instances/contentTypes/"), ...
                'The identifier should come from the library file.')
            testCase.verifyNotEqual(string(instance.name), "")
        end

        function testGetControlledInstanceRemote(testCase, instanceSpecification, versionNumber)
            jsonStr = openminds.internal.getControlledInstance(...
                instanceSpecification{:}, versionNumber, "FileSource", "github");
            
            expectedIdUriPrefix = sprintf("%s/instances", openminds.constant.BaseURI(versionNumber));
            testCase.assertTrue(contains(jsonStr.at_id, expectedIdUriPrefix));
        end
    end
end
