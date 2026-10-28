classdef ModelVersionFixtureTest < matlab.unittest.TestCase
% ModelVersionFixtureTest - Unit tests for ommtest.helper.ModelVersionFixture
%
%   The fixture is exercised through applyAndRun, which runs its whole
%   lifecycle synchronously: setup, the supplied function, then the
%   teardown that setup registered. That lets the version be observed both
%   while the fixture is applied and after it has been torn down, which a
%   fixture applied to the test itself does not allow, since that one is
%   torn down only once the test has ended.
%
%   applyAndRun was introduced in R2024b. The fixture itself uses nothing
%   newer than R2014a and is exercised on every release by MetaTypeTest;
%   only this direct observation of its lifecycle needs the newer method,
%   so those tests are filtered where it is absent rather than failing.

    methods (TestMethodSetup)
        function restoreModelVersionAfterEachTest(testCase)
            % These tests change the active version on purpose, and it is
            % global to the session.
            originalVersion = openminds.version();
            testCase.addTeardown(@() openminds.version(originalVersion));
        end
    end

    methods (Test)
        function testVersionIsSelectedWhileApplied(testCase)
            openminds.version("latest");
            fixture = testCase.fixtureRunnableHere(3);

            versionWhileApplied = fixture.applyAndRun(@() openminds.version());

            testCase.verifyEqual(versionWhileApplied, "v3.0")
        end

        function testVersionFoundIsRestoredAfterwards(testCase)
            openminds.version(4);
            versionBefore = openminds.version();
            fixture = testCase.fixtureRunnableHere(3);

            fixture.applyAndRun(@() openminds.version());

            testCase.verifyEqual(openminds.version(), versionBefore, ...
                'The version active before setup should be restored, not a fixed default')
        end

        function testNumberAndStringSelectTheSameVersion(testCase)
            fromNumber = ommtest.helper.ModelVersionFixture(3);
            fromString = ommtest.helper.ModelVersionFixture("v3.0");

            testCase.verifyEqual(fromNumber.ModelVersion, fromString.ModelVersion)
            testCase.verifyEqual(fromNumber.ModelVersion, "v3.0")
        end
    end

    methods (Access = private)
        function fixture = fixtureRunnableHere(testCase, modelVersion)
        % fixtureRunnableHere - The fixture, if this release can run its lifecycle here
            fixture = ommtest.helper.ModelVersionFixture(modelVersion);
            testCase.assumeTrue(ismethod(fixture, 'applyAndRun'), ...
                'Fixture.applyAndRun is not available before R2024b')
        end
    end
end
