classdef InstanceLibraryFixture < matlab.unittest.fixtures.Fixture
%InstanceLibraryFixture Read a small instance library for the duration of a test
%
%   The instance library is one object per session, read by default from
%   the library downloaded under the user folder. A test that reads it
%   there depends on a network, on a download of seventy megabytes, and
%   on whatever upstream holds on the day. This fixture copies a small
%   library kept with the tests into a temporary folder and makes that the
%   library in use, so a test reads a known set of instances, and may
%   change the copy as it likes.
%
%   Usage:
%       fixture = testCase.applyFixture(ommtest.helper.InstanceLibraryFixture);
%       fixture.Library   % the instance library reading the copy
%       fixture.Folder    % the copy, one subfolder per library version
%
%   Use fixture.Library rather than getSingleton with no argument: the
%   library asked for by no argument is the one at the default location,
%   and asking for it replaces the fixture's library with the downloaded
%   one. Ask for getSingleton(fixture.Folder) to get the fixture's library
%   back after it has been rebuilt.
%
%   The library kept with the tests is under tools/tests/fixtures/instances
%   and holds, for the "latest" version: two age categories and a
%   biological sex, stored one type per folder under terminologies; a
%   license and a content type, stored under the plural folder names
%   their IRIs also use; and a parcellation entity, stored in a subfolder
%   of its atlas. Every type exists in every model version from v3.0 on.
%
%   Afterwards the library in use is deleted, and the next use reads the
%   default location again. It is deleted rather than read again here, so
%   that a suite which never needs the downloaded library never downloads
%   it. A handle to the library obtained before the fixture is applied is
%   deleted when it is applied, as any change of location deletes the
%   library in use.
%
%   Each application makes its own copy, so nothing a test changes is seen
%   by another.
%
%   See also matlab.unittest.fixtures.Fixture, openminds.internal.InstanceLibrary

    properties (SetAccess = private)
        % Folder - The temporary copy of the library this fixture reads
        Folder (1,1) string = missing

        % Library - The instance library reading that copy
        Library
    end

    methods
        function setup(fixture)
            fixture.Folder = string(tempname());
            copyfile(sourceFolder(), fixture.Folder);
            fixture.addTeardown(@() rmdir(fixture.Folder, "s"));

            % Registered before the library is replaced, so the restore is
            % on record from the moment there is something to restore, and
            % it runs before the copy is removed, since teardowns run in
            % the reverse of the order they were added.
            fixture.Library = ...
                openminds.internal.InstanceLibrary.getSingleton(fixture.Folder);
            fixture.addTeardown(@() delete(fixture.Library));

            fixture.SetupDescription = sprintf( ...
                'Read the instance library from a copy of the test library at "%s".', ...
                fixture.Folder);
            fixture.TeardownDescription = ...
                'Deleted that library, so the next use reads the default location.';
        end
    end

    methods (Access = protected)
        function tf = isCompatible(~, ~)
        % isCompatible - Whether a shared fixture can stand in for another
        %
        %   Never: each application makes its own copy, so that what one
        %   test changes is not what the next one reads.
            tf = false;
        end
    end
end

function folderPath = sourceFolder()
% sourceFolder - The library kept with the tests
    testsFolder = fileparts(fileparts(fileparts( mfilename('fullpath') )));
    folderPath = fullfile(testsFolder, "fixtures", "instances");
end
