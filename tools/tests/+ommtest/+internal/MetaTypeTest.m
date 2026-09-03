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
                registry('OriginalPerson') = metaPerson;
            catch ME
                testCase.verifyEqual(string(ME.identifier), ...
                    "OPENMINDS_MATLAB:MetaTypeRegistry:UnsupportedIndexingOperation")
            end

            % Try deleting
            try
                registry('Person') = [];
            catch ME
                testCase.verifyEqual(string(ME.identifier), ...
                    "OPENMINDS_MATLAB:MetaTypeRegistry:UnsupportedIndexingOperation")
            end

            % Try getting an invalid key
            testCase.verifyError(...
                @() registry('InvalidType'), ...
                "OPENMINDS_MATLAB:MetaTypeRegistry:InvalidKey")

            % Try using chained indexing
            testCase.verifyEqual( string(registry('Person').Name), "Person")
        end

        function testScalarConstraintFromValidator(testCase)
        % A property restricted to a scalar by mustBeScalarOrEmpty must be
        % reported as scalar even though its size declaration is (1,:).
        % Both the generated type classes and openMINDS itself rely on
        % this, because every linked and embedded property is declared
        % that way.

            metaType = openminds.internal.meta.Type( ...
                'ommtest.helper.PropertyDeclarationFixture');

            testCase.verifyTrue( metaType.isPropertyValueScalar('scalarByValidator') )
            testCase.verifyTrue( metaType.isPropertyValueScalar('scalarBySize') )
            testCase.verifyFalse( metaType.isPropertyValueScalar('unrestrictedList') )
        end

        function testScalarConstraintOnGeneratedType(testCase)
        % The same check against a generated type, so the behaviour is
        % pinned for a real property and not only for the fixture.

            metaType = openminds.internal.meta.fromClassName( ...
                'openminds.core.miscellaneous.Membership');

            testCase.verifyTrue( metaType.isPropertyValueScalar('startDate') )
        end

        function testPropertyWithoutDeclaredClassIsNotMixedType(testCase)
        % Checking a property that has no declared class must answer the
        % question rather than error, and asking for its mixed type must
        % fail with an identified error.

            metaType = openminds.internal.meta.Type( ...
                'ommtest.helper.PropertyDeclarationFixture');

            testCase.verifyFalse( metaType.isPropertyMixedType('withoutDeclaredClass') )

            testCase.verifyError( ...
                @() metaType.getMixedTypeForProperty('withoutDeclaredClass'), ...
                'OPENMINDS_MATLAB:MetaType:NotAMixedType')
        end

        function testMetaType(testCase)
            previousVersion = openminds.version();
            openminds.version(5);
            testCase.addTeardown(@() openminds.version(previousVersion))
            
            metaDSV = openminds.internal.meta.fromClassName('DatasetVersion');

            testCase.verifyTrue( metaDSV.isPropertyValueScalar('accessibility') )
            testCase.verifyFalse( metaDSV.isPropertyValueScalar('contribution') )
            
            testCase.verifyTrue( metaDSV.isPropertyWithLinkedType('accessibility') )
            testCase.verifyFalse( metaDSV.isPropertyWithLinkedType('description') )
            testCase.verifyFalse( metaDSV.isPropertyWithLinkedType('copyright') )

            testCase.verifyFalse( metaDSV.isPropertyWithEmbeddedType('accessibility') )
            testCase.verifyFalse( metaDSV.isPropertyWithEmbeddedType('description') )
            testCase.verifyTrue( metaDSV.isPropertyWithEmbeddedType('copyright') )
            testCase.verifyTrue( metaDSV.isPropertyWithEmbeddedType('contribution') )

            testCase.verifyTrue( metaDSV.isPropertyMixedType('digitalIdentifier') )
            testCase.verifyTrue( metaDSV.isPropertyMixedType('usageCondition') )
            testCase.verifyFalse( metaDSV.isPropertyMixedType('accessibility') )
            testCase.verifyFalse( metaDSV.isPropertyMixedType('contribution') )

            testCase.verifyTrue( metaDSV.isLinkedTypeOfAnyProperty("SubjectState") )
            testCase.verifyFalse( metaDSV.isLinkedTypeOfAnyProperty("Person") )

            linkedDigitalIdentifierTypes = metaDSV.listLinkedTypesForProperty('digitalIdentifier');
            testCase.verifyEqual(linkedDigitalIdentifierTypes, ...
                ["openminds.core.digitalidentifier.DOI", ...
                "openminds.core.digitalidentifier.GenericIdentifier", ...
                "openminds.core.digitalidentifier.IdentifiersDotOrgID", ...
                "openminds.core.digitalidentifier.RRID"])

            linkedUsageConditionTypes = metaDSV.listLinkedTypesForProperty('usageCondition');
            testCase.verifyEqual(linkedUsageConditionTypes, ...
                ["openminds.core.data.License", ...
                "openminds.core.data.UsageAgreement"])

            embeddedCopyrightTypes = metaDSV.listEmbeddedTypesForProperty('copyright');
            testCase.verifyEqual(embeddedCopyrightTypes, "openminds.core.data.Copyright")

            embeddedContributionTypes = metaDSV.listEmbeddedTypesForProperty('contribution');
            testCase.verifyEqual(embeddedContributionTypes, "openminds.core.actors.Contribution")
        end
    end
end
