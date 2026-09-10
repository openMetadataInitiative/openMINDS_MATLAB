classdef Paths < handle
%Paths Folders the toolbox reads from and writes to
%
%   The folders the toolbox keeps its downloads in sit under MATLAB's user
%   folder, which is not known until MATLAB can tell us. Asking for it as a
%   constant asks too early: MATLAB evaluates a constant property once,
%   when the class is first loaded, and a user folder that does not exist
%   yet leaves userpath empty and every folder built under it relative.
%   Validating an argument to openminds.startup already loads this class,
%   so there is no point inside the toolbox early enough to get ahead of
%   that.
%
%   These are resolved when they are first asked for instead, which is
%   always late enough because it is the moment the answer is needed, and
%   then kept for the rest of the session. Resolving them on every call
%   would answer differently once userpath changed, and move the library
%   out from under whoever was reading it.
%
%   See also openminds.internal.setup.ensureUserpath

    properties (Constant)
        % Everything written by the openMINDS pipeline, one subfolder per
        % model version. Named "resources" so that genpath skips it and no
        % addpath can put two model versions on the path at once.
        %
        % Constant because it sits inside the toolbox, which cannot move
        % while MATLAB is running, and because it is read on paths that run
        % often.
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
% resolvedFolderPaths - The folders under the user folder, resolved once
%
%   Resolving these gives MATLAB a user folder when it has none, because
%   this is the point where an answer is actually needed and the toolbox
%   has nowhere else to put what it downloads. That sets a MATLAB
%   preference, so it happens once, and only when userpath is unusable.
%
%   They are built together and kept, rather than built per call: fullfile
%   costs enough to be worth avoiding on a lookup that runs once per
%   controlled instance read.

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
