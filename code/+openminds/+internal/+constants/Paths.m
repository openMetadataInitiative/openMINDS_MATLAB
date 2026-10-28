classdef Paths < handle
%Paths Folders the toolbox reads from and writes to
%
%   GeneratedFolder is a Constant property. UserPath, SourceSchemaFolder
%   and LocalInstanceFolder are static methods that resolve their folder
%   on the first call and cache it for the rest of the session. They are
%   not Constant properties, for two reasons:
%
%   1. They are built under userpath, and userpath can be empty. MATLAB
%      leaves it empty on Linux when $HOME/Documents does not exist, which
%      is the case on CI runners. A path built under an empty userpath is
%      relative. MATLAB evaluates a Constant property once, when the class
%      is first loaded, so a Constant property built at that point would
%      hold the relative path for the rest of the session.
%      openminds.internal.setup.ensureUserpath sets a user folder when
%      userpath is empty, but it cannot run before this class is loaded:
%      validating the arguments of openminds.startup loads the class, and
%      openminds.startup is the first toolbox function a user calls.
%
%   2. The resolved folders are cached instead of rebuilt on every call so
%      that changing userpath later in the session does not change where
%      the toolbox reads from. The instance library is read again on every
%      model version change and must read from the same location each
%      time. Caching also avoids calling fullfile on every lookup, which
%      LocalInstanceFolder does once per controlled instance read.
%
%   See also openminds.internal.setup.ensureUserpath

    properties (Constant)
        % Everything written by the openMINDS pipeline, one subfolder per
        % model version. Named "resources" so that genpath skips it and no
        % addpath can put two model versions on the path at once.
        %
        % A Constant property, unlike the folders below, because it is
        % inside the toolbox and does not depend on userpath, and because
        % it is read on code paths that run often.
        GeneratedFolder = fullfile(openminds.toolboxdir(), 'generated', 'resources')
    end

    methods (Static)
        function folderPath = UserPath()
        % UserPath - Root of everything this toolbox stores under the user folder
            folderPaths = resolvedFolderPaths();
            folderPath = folderPaths.UserPath;
        end

        function folderPath = SourceSchemaFolder()
        % SourceSchemaFolder - Downloaded openMINDS schema files, the generator's input
            folderPaths = resolvedFolderPaths();
            folderPath = folderPaths.SourceSchemaFolder;
        end

        function folderPath = LocalInstanceFolder()
        % LocalInstanceFolder - Downloaded openMINDS instance library
            folderPaths = resolvedFolderPaths();
            folderPath = folderPaths.LocalInstanceFolder;
        end
    end
end

function folderPaths = resolvedFolderPaths()
% resolvedFolderPaths - Resolve the folders under the user folder once
%
%   The first call runs ensureUserpath, which sets userpath if it is empty
%   or names a folder that does not exist. Setting userpath writes a
%   MATLAB preference that persists across sessions, so it is done here
%   once, and only when userpath is unusable.
%
%   The folders are built together and cached because fullfile is slow
%   for a lookup that runs once per controlled instance read: resolving
%   LocalInstanceFolder took about 1 ms per call when rebuilt, against
%   about 8 us when cached.

    persistent cachedFolderPaths

    if isempty(cachedFolderPaths)
        userFolder = openminds.internal.setup.ensureUserpath();

        cachedFolderPaths.UserPath = ...
            fullfile(userFolder, "openMINDS_MATLAB");
        cachedFolderPaths.SourceSchemaFolder = fullfile( ...
            cachedFolderPaths.UserPath, "Repositories", "openMINDS-main", "schemas");
        cachedFolderPaths.LocalInstanceFolder = fullfile( ...
            cachedFolderPaths.UserPath, "Repositories", "openMINDS_instances-main", "instances");
    end

    folderPaths = cachedFolderPaths;
end
