classdef EnumerationTest < matlab.unittest.TestCase
% EnumerationTest - Unit tests for the openminds enumeration types

    methods (Test)
        function testModuleEnumeration(testCase)
            moduleEnum = openminds.enum.Modules("core");
            
            typesInCoreModule = moduleEnum.listTypes();

            selectedTypesOfCore = ["Person", "DatasetVersion", "Subject"];

            testCase.verifyTrue( ...
                all(ismember(selectedTypesOfCore, typesInCoreModule)) ...
            )
        end

        function testTypeEnumeration(testCase)




        end
    end
end