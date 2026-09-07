% ensureUserpath - Give MATLAB a user folder when it has none
%
%   On a GitHub Actions runner MATLAB's default user folder does not exist,
%   so userpath is empty and every call that resolves a path under it warns.
%   The toolbox keeps its instance library under userpath, so that warning
%   fires on every controlled-term lookup. Point userpath at a folder that
%   exists so the warning cannot fire. Mirrors what setup.m does for CI.
% Guard on the folder existing rather than on emptiness alone: userpath is
% documented to return empty when its default folder is missing, but a
% folder that is set and absent would warn just the same.
currentUserpath = userpath;
if isempty(currentUserpath) || ~isfolder(currentUserpath)
    userpath(getenv("RUNNER_TEMP"))
end
