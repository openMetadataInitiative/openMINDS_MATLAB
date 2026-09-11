function absolutePath = resolveAbsolutePath(pathString)
% resolveAbsolutePath - Resolve a path against the working directory
%
%   Syntax:
%       absolutePath = openminds.internal.utility.resolveAbsolutePath(pathString)
%
%   Input Arguments:
%       pathString - A path, absolute or relative to the working directory
%
%   Output Arguments:
%       absolutePath - The path made absolute against the working directory
%       if it was relative. An absolute path is returned as it is.
%
%   A relative path names a different folder every time the working
%   directory changes. Resolving it when it is received pins the folder it
%   meant then.

    arguments
        pathString (1,1) string
    end

    if isAbsolutePath(pathString)
        absolutePath = pathString;
    else
        absolutePath = string( fullfile(pwd, pathString) );
    end
end

function tf = isAbsolutePath(pathString)
% isAbsolutePath - Whether a path names a folder without a starting point

    if ispc
        % A drive letter, or the leading pair of separators of a UNC path
        tf = ~isempty( regexp(pathString, '^([A-Za-z]:[\\/]|\\\\)', 'once') );
    else
        tf = startsWith(pathString, filesep);
    end
end
