function userFolder = ensureUserpath()
% ensureUserpath - Give MATLAB a user folder when it has none
%
%   Syntax:
%       openminds.internal.setup.ensureUserpath()
%
%       userFolder = openminds.internal.setup.ensureUserpath()
%
%   Output Arguments:
%       userFolder - The user folder in use once this has run
%
%   The toolbox keeps the schemas and the instance library it downloads
%   under MATLAB's user folder. That folder does not exist on a fresh
%   continuous integration runner, which leaves userpath empty and every
%   path built under it relative. A relative path stops naming the same
%   folder as soon as anything changes the working directory.
%
%   Call this before anything reads one of those paths. They are constant
%   properties, and MATLAB evaluates those once, when the class is first
%   loaded, so a path read before this has run keeps the value it resolved
%   to then for the rest of the session.
%
%   See also openminds.internal.constants.Paths

    userFolder = string( userpath() );

    % A user folder that is set but absent leaves the paths built under it
    % just as unusable as an empty userpath does.
    if userFolder ~= "" && isfolder(userFolder)
        return
    end

    userFolder = fallbackUserFolder();
    userpath( char(userFolder) )

    fprintf(['MATLAB has no user folder. openMINDS will keep the files it ', ...
        'downloads in "%s".\n'], userFolder)
end

function userFolder = fallbackUserFolder()
% fallbackUserFolder - A folder that exists and can be written to
%
%   A GitHub Actions runner names a folder for this, which is removed with
%   the job and lies outside the checked out repository. Anywhere else the
%   working directory is used, which keeps the files where whoever ran the
%   setup can find them.

    if strcmp(getenv('GITHUB_ACTIONS'), 'true')
        userFolder = string( getenv("RUNNER_TEMP") );

        if userFolder ~= "" && isfolder(userFolder)
            return
        end
    end

    userFolder = string( pwd );
end
