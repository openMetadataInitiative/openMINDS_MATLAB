function pathParts = pathParts(pathStr)
%pathParts Split a path into folder(s) and file parts
%
%   pathParts = pathParts(pathStr) splits a path string using the platform
%   dependent file separator

    pathParts = split(pathStr, filesep);
end
