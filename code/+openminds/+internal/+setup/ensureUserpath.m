function userFolder = ensureUserpath()
% ensureUserpath - Set userpath to the temporary folder if it is unusable
%
%   Syntax:
%       openminds.internal.setup.ensureUserpath()
%
%       userFolder = openminds.internal.setup.ensureUserpath()
%
%   Output Arguments:
%       userFolder - The user folder in use after this call
%
%   The toolbox stores the schemas and the instance library it downloads
%   under MATLAB's user folder, which userpath returns. userpath is empty
%   on Linux when $HOME/Documents does not exist, which is the case on CI
%   runners. A path built under an empty userpath is relative, and a
%   relative path points somewhere else as soon as the working directory
%   changes.
%
%   If userpath is empty or names a folder that does not exist, this
%   function sets it to the system temporary folder and warns. Otherwise
%   it does nothing. The toolbox calls it the first time it resolves one
%   of its download folders. Code that has a better folder to offer, such
%   as a CI task, can set userpath before then.
%
%   See also openminds.internal.constants.Paths

    userFolder = string( userpath() );

    % A userpath that names a folder that does not exist is as unusable as
    % an empty one: nothing can be written under it.
    if userFolder ~= "" && isfolder(userFolder)
        return
    end

    userpath( char(fallbackUserFolder()) )

    % Read the folder back instead of returning the fallback as given.
    % MATLAB normalizes the path it stores (tempdir ends in a separator,
    % the stored value does not), and every call must return the same
    % string for the same folder.
    userFolder = string( userpath() );

    % Warn, with an identifier, because this decides where tens of
    % megabytes are downloaded. It fires once: userpath has been set above,
    % so every later call returns early.
    warning('OPENMINDS:Setup:NoUserFolder', ...
        ['MATLAB''s userpath is empty or names a folder that does not ', ...
        'exist, so openMINDS will keep the files it downloads in "%s". ', ...
        'That folder is temporary and may be cleared, which means ', ...
        'downloading them again. To keep them somewhere permanent, call ', ...
        'userpath(folder) with a folder of your choosing before using ', ...
        'openMINDS.'], userFolder)
end

function userFolder = fallbackUserFolder()
% fallbackUserFolder - Folder to use when userpath is unusable
%
%   The system temporary folder, not the working directory. The working
%   directory is often a repository or a project folder, and downloading
%   tens of megabytes into one of those is worse than downloading into a
%   folder that may be cleared. Setting userpath also persists across
%   sessions, so the working directory would stay the user folder for
%   good.

    userFolder = string( tempdir() );
end
