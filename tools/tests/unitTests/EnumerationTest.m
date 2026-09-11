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
            testCase.verifyTrue(startsWith(typeEnum.TypeIRI, "https://openminds."));
            
            % Test None special case
            noneEnum = openminds.enum.Types.None;
            testCase.verifyEqual(noneEnum.ClassName, "None");
            testCase.verifyEqual(noneEnum.AliasClassName, "None");
            testCase.verifyEqual(noneEnum.TypeIRI, "None");
            
            % Test instance creation
            personInstance = typeEnum.createInstance();
            testCase.verifyClass(personInstance, "openminds.core.actors.Person");
            
            % Test error for multiple objects
            multipleEnums = [openminds.enum.Types.Person, openminds.enum.Types.Dataset];
            testCase.verifyError(@() multipleEnums.createInstance(), '');
            
            % Test ismissing method
            testCase.verifyFalse(typeEnum.ismissing());
            testCase.verifyTrue(noneEnum.ismissing());
            
            % Test getTypeName method
            testCase.verifyEqual(typeEnum.getTypeName(), "Person");
            
            % Test static fromClassName method
            fromClassNameEnum = openminds.enum.Types.fromClassName("openminds.core.actors.Person");
            testCase.verifyEqual(fromClassNameEnum, openminds.enum.Types.Person);
            
            % Test static fromClassName with multiple inputs
            multipleClassNames = ["openminds.core.actors.Person", "openminds.core.products.Dataset"];
            multipleEnumsResult = openminds.enum.Types.fromClassName(multipleClassNames);
            testCase.verifyEqual(multipleEnumsResult, [openminds.enum.Types.Person, openminds.enum.Types.Dataset]);
            
            % Test static fromAtType method
            % Note: This test assumes the base URI is consistent with the current version
            baseIRI = openminds.constant.BaseIRI;
            fromAtTypeEnum = openminds.enum.Types.fromAtType(baseIRI + "/Person");
            testCase.verifyEqual(fromAtTypeEnum, openminds.enum.Types.Person);
            
            % Test static fromAtType with multiple inputs
            multipleAtTypes = [baseIRI + "/Person", baseIRI + "/Dataset"];
            multipleEnumsFromAtType = openminds.enum.Types.fromAtType(multipleAtTypes);
            testCase.verifyEqual(multipleEnumsFromAtType, [openminds.enum.Types.Person, openminds.enum.Types.Dataset]);
            
            % Test error for invalid AtType
            testCase.verifyError(@() openminds.enum.Types.fromAtType("invalid://uri"), ...
                'OPENMINDS_MATLAB:Types:InvalidAtType');
        end

        function testFromAtTypeAcceptsBothNamespaces(testCase)
        % Documents written for an older model use the EBRAINS namespace
        % and newer ones use the om-i namespace. Both name the type in
        % their last segment, and both must resolve against the active
        % model version.

            for baseIRI = [openminds.constant.BaseIRI("v1"), ...
                           openminds.constant.BaseIRI("v4")]
                testCase.verifyEqual( ...
                    openminds.enum.Types.fromAtType(baseIRI + "/Person"), ...
                    openminds.enum.Types.Person, ...
                    sprintf('Expected "%s" to be an accepted namespace.', baseIRI))
            end
        end

        function testFromAtTypeDoesNotRereadTheModelVersionsPerCall(testCase)
        % fromAtType runs once per node of every document read. It used to
        % call openminds.constant.BaseIRI for both namespaces on every
        % call, and each of those calls listed the installed model versions
        % from disk, which cost more than the rest of the function. The
        % bound is far above what 1000 calls need with the base IRIs cached
        % and far below what re-reading the versions 1000 times costs.

            MAX_SECONDS_FOR_1000_CALLS = 2;

            atType = openminds.constant.BaseIRI("v4") + "/Person";
            openminds.enum.Types.fromAtType(atType); % Exclude any warm-up

            elapsed = timeit(@() callFromAtType(atType, 1000));

            testCase.verifyLessThan(elapsed, MAX_SECONDS_FOR_1000_CALLS, ...
                'fromAtType is resolving the base IRIs on every call again.')
        end
    end
end

function callFromAtType(atType, numCalls)
    for i = 1:numCalls
        openminds.enum.Types.fromAtType(atType);
    end
end
