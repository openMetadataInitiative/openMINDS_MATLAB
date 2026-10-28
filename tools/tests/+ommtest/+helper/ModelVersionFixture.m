classdef ModelVersionFixture < matlab.unittest.fixtures.Fixture
%ModelVersionFixture Select an openMINDS model version for the duration of a test
%
%   The active model version is global to the MATLAB session, so a test
%   that changes it changes it for everything that runs afterwards. This
%   fixture restores whichever version was active when it was applied,
%   whether the test passes, fails or errors.
%
%   Usage:
%       testCase.applyFixture(ommtest.helper.ModelVersionFixture(3))
%       testCase.applyFixture(ommtest.helper.ModelVersionFixture("v3.0"))
%
%   Restoring the version does not undo everything a switch causes. Class
%   definitions are reloaded when the version changes, but only once no
%   instance of them is held in memory: an instance that outlives the test,
%   directly or in a singleton, pins the definition it was created from,
%   and the next test sees a class that no longer matches the active
%   version. Leave no openMINDS instances behind and this fixture is
%   enough.
%
%   See also matlab.unittest.fixtures.Fixture, openminds.version

    properties (SetAccess = immutable)
        % Version to select while the fixture is applied, as "vX.Y"
        ModelVersion (1,1) string
    end

    methods
        function fixture = ModelVersionFixture(modelVersion)
            arguments
                modelVersion (1,1) {openminds.mustBeValidModelVersion}
            end

            % Normalized so that a fixture built from 3 and one built from
            % "v3.0" compare equal, and so the version is reported the same
            % way openminds.version reports it. The default format of a
            % VersionNumber is "X.Y.Z", which openminds.version does not
            % use, so the format is set the way mustBeValidModelVersion
            % sets it before validating.
            modelVersion = openminds.internal.utility.VersionNumber(modelVersion);
            modelVersion.Format = 'vX.Y';

            fixture.ModelVersion = string(modelVersion);
        end

        function setup(fixture)
            previousModelVersion = openminds.version();

            % Registered before the version is changed, so that the
            % restore is on record from the moment there is something to
            % restore, and registered here rather than in a teardown
            % method, so that what is undone is exactly what this setup
            % did, and nothing runs if it did not get this far.
            fixture.addTeardown(@openminds.version, previousModelVersion);
            openminds.version(fixture.ModelVersion);

            fixture.SetupDescription = sprintf(...
                'Selected openMINDS model version %s.', fixture.ModelVersion);
            fixture.TeardownDescription = sprintf(...
                'Restored openMINDS model version %s.', previousModelVersion);
        end
    end

    methods (Access = protected)
        function tf = isCompatible(fixture, other)
        % isCompatible - Whether a shared fixture can stand in for another
        %
        %   Two fixtures selecting the same version have the same effect,
        %   so a shared one is kept rather than torn down and set up again.
            tf = fixture.ModelVersion == other.ModelVersion;
        end
    end
end
