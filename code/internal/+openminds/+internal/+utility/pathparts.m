function pathParts = pathparts(pathStr)
%pathparts Split a path into folder(s) and file parts
%
%   pathParts = pathparts(pathStr) splits a path string using the platform
%   dependent file separator

    pathParts = split(pathStr, filesep); 
end
