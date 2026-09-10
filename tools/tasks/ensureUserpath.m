function userFolder = ensureUserpath()
% ensureUserpath - Give MATLAB a user folder suited to where this is running
%
%   Syntax:
%       ensureUserpath()
%
%       userFolder = ensureUserpath()
%
%   Output Arguments:
%       userFolder - The user folder in use once this has run
%
%   The toolbox keeps the schemas and the instance library it downloads
%   under MATLAB's user folder, and picks a temporary folder when MATLAB
%   has none. On a continuous integration runner there is a better answer
%   than that, and it is one only the runner knows: a folder of its own,
%   removed with the job and outside the checked out repository. Knowing
%   which runner we are on is not the toolbox's business, so it lives here
%   rather than shipping with it.
%
%   Anywhere else it does nothing and leaves the choice to the toolbox,
%   which makes it when it first needs somewhere to write. This runs before
%   the toolbox is on the search path, so it cannot ask the toolbox
%   anything, and has nothing better to tell it either.
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

    userpath( char(runnerFolder) )

    % Read back rather than kept: MATLAB normalizes what it stores, and a
    % folder named one way now and another way on the next call reads as
    % two different folders.
    userFolder = string( userpath() );
end

function folderPath = runnerUserFolder()
% runnerUserFolder - The folder a GitHub Actions runner offers, if any
%
%   Missing when this is not running on a runner, or when the runner did
%   not name a folder after all.

    folderPath = missing;

    if ~strcmp(getenv('GITHUB_ACTIONS'), 'true')
        return
    end

    runnerFolder = string( getenv("RUNNER_TEMP") );

    if runnerFolder ~= "" && isfolder(runnerFolder)
        folderPath = runnerFolder;
    end
end
