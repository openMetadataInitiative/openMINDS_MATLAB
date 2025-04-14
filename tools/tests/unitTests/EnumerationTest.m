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
            % Test constructor and property initialization
            typeEnum = openminds.enum.Types.Person;
            testCase.verifyEqual(typeEnum.ClassName, "openminds.core.actors.Person");
            testCase.verifyEqual(typeEnum.AliasClassName, "openminds.core.Person");
            testCase.verifyTrue(startsWith(typeEnum.TypeURI, "https://openminds."));
            
            % Test None special case
            noneEnum = openminds.enum.Types.None;
            testCase.verifyEqual(noneEnum.ClassName, "None");
            testCase.verifyEqual(noneEnum.AliasClassName, "None");
            testCase.verifyEqual(noneEnum.TypeURI, "None");
            
            % Test instance creation methods
            personInstance = typeEnum.create();
            testCase.verifyClass(personInstance, "openminds.core.actors.Person");
            
            personInstance2 = typeEnum.createInstance();
            testCase.verifyClass(personInstance2, "openminds.core.actors.Person");
            
            % Test error for multiple objects
            multipleEnums = [openminds.enum.Types.Person, openminds.enum.Types.Dataset];
            testCase.verifyError(@() multipleEnums.createInstance(), '');
            
            % Test ismissing method
            testCase.verifyFalse(typeEnum.ismissing());
            testCase.verifyTrue(noneEnum.ismissing());
            
            % Test getSchemaName method
            testCase.verifyEqual(typeEnum.getSchemaName(), "Person");
            
            % Test static fromClassName method
            fromClassNameEnum = openminds.enum.Types.fromClassName("openminds.core.actors.Person");
            testCase.verifyEqual(fromClassNameEnum, openminds.enum.Types.Person);
            
            % Test static fromClassName with multiple inputs
            multipleClassNames = ["openminds.core.actors.Person", "openminds.core.products.Dataset"];
            multipleEnumsResult = openminds.enum.Types.fromClassName(multipleClassNames);
            testCase.verifyEqual(multipleEnumsResult, [openminds.enum.Types.Person, openminds.enum.Types.Dataset]);
            
            % Test static fromAtType method
            % Note: This test assumes the base URI is consistent with the current version
            baseURI = openminds.constant.BaseURI;
            fromAtTypeEnum = openminds.enum.Types.fromAtType(baseURI + "/Person");
            testCase.verifyEqual(fromAtTypeEnum, openminds.enum.Types.Person);
            
            % Test static fromAtType with multiple inputs
            multipleAtTypes = [baseURI + "/Person", baseURI + "/Dataset"];
            multipleEnumsFromAtType = openminds.enum.Types.fromAtType(multipleAtTypes);
            testCase.verifyEqual(multipleEnumsFromAtType, [openminds.enum.Types.Person, openminds.enum.Types.Dataset]);
            
            % Test error for invalid AtType
            testCase.verifyError(@() openminds.enum.Types.fromAtType("invalid://uri"), ...
                'OPENMINDS_MATLAB:Types:InvalidAtType');
        end
    end
end
