classdef ControlledInstanceTest < matlab.unittest.TestCase

    properties (TestParameter)
        instanceSpecification = { {'adult', "AgeCategory"} }
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
            
            expectedIdUriPrefix = sprintf("%s/instances", openminds.constant.BaseIRI(versionNumber));
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

        function testIdentifierOnlyLinkToControlledInstanceIsLookedUp(testCase)
        % A document that links a property holding several types to a
        % controlled instance by identifier alone describes nothing about
        % it, so the instance is taken from the library, as a controlled
        % term built from a bare identifier is. Held as a reference of
        % unknown type instead, it could not be saved.

            licenseIRI = "https://openminds.om-i.org/instances/licenses/CC-BY-4.0";

            atlasVersion = openminds.sands.atlas.AnatomicalAtlasVersion();
            atlasVersion.usageCondition = struct('at_id', licenseIRI);

            license = atlasVersion.usageCondition(1);
            testCase.verifyClass(license, 'openminds.core.data.License')
            testCase.verifyFalse(license.isReference())
            testCase.verifyEqual(string(license.id), licenseIRI)
            testCase.verifyNotEqual(string(license.fullName), "")
        end

        function testIdentifierOnlyLinkToUnknownControlledInstanceStaysReference(testCase)
        % The library may not hold the instance an identifier points to,
        % as when the two spell a name differently. The link is then kept
        % as a reference and the reader is told, rather than the read
        % failing.

            missingIRI = "https://openminds.om-i.org/instances/licenses/no-such-license";

            atlasVersion = openminds.sands.atlas.AnatomicalAtlasVersion();
            testCase.verifyWarning( ...
                @() atlasVersion.set("usageCondition", struct('at_id', missingIRI)), ...
                'openMINDS:MixedTypeSet:ControlledInstanceNotFound')

            link = atlasVersion.usageCondition(1);
            testCase.verifyClass(link, 'openminds.internal.MixedTypeReference')
            testCase.verifyEqual(string(link.id), missingIRI)
        end

        function testGetControlledInstanceRemote(testCase, instanceSpecification, versionNumber)
            jsonStr = openminds.internal.getControlledInstance(...
                instanceSpecification{:}, versionNumber, "FileSource", "github");
            
            expectedIdUriPrefix = sprintf("%s/instances", openminds.constant.BaseIRI(versionNumber));
            testCase.assertTrue(contains(jsonStr.at_id, expectedIdUriPrefix));
        end
    end
end
