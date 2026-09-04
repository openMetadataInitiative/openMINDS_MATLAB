function rootPath = rootpath()
% rootpath - Return rootpath for the openMINDS code folder.

    import openminds.internal.utility.pathParts

    FILE_DEPTH = 4; % Relative to root

    thisPathSplit = pathParts( mfilename("fullpath") );
    rootPath = strjoin(thisPathSplit(1:end-FILE_DEPTH), filesep);
end
