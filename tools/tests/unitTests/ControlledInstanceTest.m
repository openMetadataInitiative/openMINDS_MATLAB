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

        function testGetControlledInstanceRemote(testCase, instanceSpecification, versionNumber)
            jsonStr = openminds.internal.getControlledInstance(...
                instanceSpecification{:}, versionNumber, "FileSource", "github");
            
            expectedIdUriPrefix = sprintf("%s/instances", openminds.constant.BaseURI(versionNumber));
            testCase.assertTrue(contains(jsonStr.at_id, expectedIdUriPrefix));       
        end
    end
end
