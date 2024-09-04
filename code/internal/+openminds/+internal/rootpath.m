function rootPath = rootpath()
% rootpath - Return rootpath for the openMINDS code folder.

    import openminds.internal.utility.pathparts

    FILE_DEPTH = 4; % Relative to root

    thisPathSplit = pathparts( mfilename("fullpath") );
    rootPath = strjoin(thisPathSplit(1:end-FILE_DEPTH), filesep);
end
