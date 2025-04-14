classdef MetaTypeTest < matlab.unittest.TestCase
    
    methods (Test)
        function testRegistrySingleton(testCase)
            import openminds.internal.meta.MetaTypeRegistry

            registry = MetaTypeRegistry.getSingleton();
            testCase.verifyClass(registry, 'openminds.internal.meta.MetaTypeRegistry');
            testCase.verifyEqual(registry.ModelVersion, "latest")

            % Verify that we get the same handle if we ask for the singleton again
            newRegistry = MetaTypeRegistry.getSingleton();
            testCase.verifySameHandle(registry, newRegistry)

            % Change model version
            openminds.version(3);
            testCase.addTeardown(@() openminds.version("latest"))

            registry = MetaTypeRegistry.getSingleton();
            testCase.verifyClass(registry, 'openminds.internal.meta.MetaTypeRegistry');
            testCase.verifyEqual(registry.ModelVersion, "v3.0")

            % Test that we get a new object if we reset the singleton
            newRegistry = MetaTypeRegistry.getSingleton("Reset", true);
            testCase.verifyNotSameHandle(registry, newRegistry)
            testCase.verifyTrue(~isvalid(registry))
        end

        function testGetMetatypeFromRegistry(testCase)
            import openminds.internal.meta.MetaTypeRegistry

            registry = MetaTypeRegistry.getSingleton();
            metaPerson = registry("Person");
            anotherMetaPerson = registry("openminds.core.actors.Person");

            testCase.verifySameHandle(metaPerson, anotherMetaPerson)

            registry.clearCache()
            yetAnotherMetaPerson = registry("Person");
            testCase.verifyNotSameHandle(metaPerson, yetAnotherMetaPerson)

            % Try assigning
            try
                registry('OriginalPerson') = metaPerson; %#ok<NASGU>
            catch ME
                testCase.verifyEqual(string(ME.identifier), ...
                    "OPENMINDS_MATLAB:MetaTypeRegistry:UnsupportedIndexingOperation")
            end

            % Try deleting
            try
                registry('Person') = []; %#ok<NASGU>
            catch ME
                testCase.verifyEqual(string(ME.identifier), ...
                    "OPENMINDS_MATLAB:MetaTypeRegistry:UnsupportedIndexingOperation")
            end
        end

        function testMetaType(testCase)
            % The following verifications was written for v4.0 of the
            % DatasetVersion schema and might need to change in the future
            
            metaDSV = openminds.internal.meta.fromClassName('DatasetVersion');

            testCase.verifyTrue( metaDSV.isPropertyValueScalar('accessibility') )
            testCase.verifyFalse( metaDSV.isPropertyValueScalar('author') )
            
            testCase.verifyTrue( metaDSV.isPropertyWithLinkedType('accessibility') )
            testCase.verifyFalse( metaDSV.isPropertyWithLinkedType('description') )
            testCase.verifyFalse( metaDSV.isPropertyWithLinkedType('copyright') )

            testCase.verifyFalse( metaDSV.isPropertyWithEmbeddedType('accessibility') )
            testCase.verifyFalse( metaDSV.isPropertyWithEmbeddedType('description') )
            testCase.verifyTrue( metaDSV.isPropertyWithEmbeddedType('copyright') )

            testCase.verifyTrue( metaDSV.isPropertyMixedType('author') )
            testCase.verifyFalse( metaDSV.isPropertyMixedType('accessibility') )

            testCase.verifyTrue( metaDSV.isLinkedTypeOfAnyProperty("Person") )
            testCase.verifyFalse( metaDSV.isLinkedTypeOfAnyProperty("SubjectState") )

            linkedAuthorTypes = metaDSV.listLinkedTypesForProperty('author');
            testCase.verifyEqual(linkedAuthorTypes, ...
                ["openminds.core.actors.Consortium", ...
                "openminds.core.actors.Organization", ...
                "openminds.core.actors.Person"])

            embeddedCopyrightTypes = metaDSV.listEmbeddedTypesForProperty('copyright');
            testCase.verifyEqual(embeddedCopyrightTypes, embeddedCopyrightTypes)
        end
    end
end