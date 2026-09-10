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

    userpath( char(fallbackUserFolder()) )

    % Read back rather than kept: MATLAB normalizes what it stores, and a
    % folder named one way now and another way on the next call reads as
    % two different folders.
    userFolder = string( userpath() );

    % Said out loud, and with an identifier, because this decides where
    % tens of megabytes are written on someone's machine. It is said once:
    % the folders built on it are resolved once per session.
    warning('OPENMINDS:Setup:NoUserFolder', ...
        ['MATLAB has no user folder, so openMINDS will keep the files it ', ...
        'downloads in "%s". That folder is temporary and may be cleared, ', ...
        'which means downloading them again. To keep them somewhere ', ...
        'permanent, call userpath(folder) with a folder of your choosing ', ...
        'before using openMINDS.'], userFolder)
end

function userFolder = fallbackUserFolder()
% fallbackUserFolder - A folder that exists and can be written to
%
%   A GitHub Actions runner names a folder for this, which is removed with
%   the job and lies outside the checked out repository.
%
%   Anywhere else the temporary folder is used, rather than the working
%   directory. Neither is a folder anyone asked for, but the working
%   directory is as often as not a repository or a project folder, and
%   writing tens of megabytes into one of those is a worse surprise than
%   writing them somewhere that may be cleared. It would also be recorded
%   as the user folder for good, naming a directory that was only ever
%   where MATLAB happened to be standing.

    if strcmp(getenv('GITHUB_ACTIONS'), 'true')
        userFolder = string( getenv("RUNNER_TEMP") );

        if userFolder ~= "" && isfolder(userFolder)
            return
        end
    end

    userFolder = string( tempdir() );
end
