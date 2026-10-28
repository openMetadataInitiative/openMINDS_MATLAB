function userFolder = ensureUserpath()
% ensureUserpath - Set userpath to the runner's temporary folder on GitHub Actions
%
%   Syntax:
%       ensureUserpath()
%
%       userFolder = ensureUserpath()
%
%   Output Arguments:
%       userFolder - The user folder in use after this call
%
%   The toolbox stores the schemas and the instance library it downloads
%   under userpath, and falls back to the system temporary folder when
%   userpath is empty. On a GitHub Actions runner userpath is empty because
%   $HOME/Documents does not exist, and RUNNER_TEMP is a better fallback
%   than the system temporary folder: it belongs to the job, is removed
%   when the job ends, and is outside the checked out repository.
%   Detecting the runner is a CI concern, so this lives in tools rather
%   than in the toolbox.
%
%   This function does nothing when userpath is already usable, or when
%   not running on GitHub Actions. It runs before the toolbox is on the
%   search path, so it must not call toolbox functions.
%
%   See also openminds.internal.setup.ensureUserpath

    userFolder = string( userpath() );

    if userFolder ~= "" && isfolder(userFolder)
        return
    end

    runnerFolder = runnerUserFolder();

    if ismissing(runnerFolder)
        return
    end

    % An empty userpath on a GitHub runner triggers this warning when
    % userpath is called. That is the situation this function exists for,
    % so the warning is silenced around the call.
    oldWarningState = warning('off', 'MATLAB:mpath:UnableToLocatePersonalFolder');
    warningCleanup = onCleanup(@() warning(oldWarningState));

    userpath( char(runnerFolder) )

    % Read the folder back instead of returning runnerFolder. MATLAB
    % normalizes the path it stores, and every call must return the same
    % string for the same folder.
    userFolder = string( userpath() );

    if ~nargout
        clear('userFolder')
    end
end

function folderPath = runnerUserFolder()
% runnerUserFolder - The RUNNER_TEMP folder of a GitHub Actions runner
%
%   Returns missing when not running on GitHub Actions, or when
%   RUNNER_TEMP is unset or names a folder that does not exist.

    folderPath = missing;

    if ~strcmp(getenv('GITHUB_ACTIONS'), 'true')
        return
    end

    runnerFolder = string( getenv("RUNNER_TEMP") );

    if runnerFolder ~= "" && isfolder(runnerFolder)
        folderPath = runnerFolder;
    end
end
