function singletonObject = getSingleton(folderPath, options)
% getSingleton - Get the instance library of this session
%
%   Syntax:
%       library = openminds.internal.InstanceLibrary.getSingleton()
%       returns the one instance library of the session, read from its
%       default location under the user folder. The library is created
%       on first use, and that first use downloads it if it is not there
%       yet.
%
%       library = getSingleton(folderPath) reads the library at
%       folderPath instead. That folder has to hold a copy of the
%       library already, one subfolder per version such as "latest",
%       because only the default location is downloaded into.
%
%       library = getSingleton(..., Reset=true) discards the library in
%       use and reads it again.
%
%       library = getSingleton(..., UseGit=true) leaves retrieving the
%       library to the caller: nothing is downloaded. The git pull the
%       name refers to is not implemented.
%
%   Input Arguments:
%       folderPath - Folder holding one subfolder per library version,
%       such as "v3.0" and "latest". Defaults to the instance folder
%       under the user folder.
%
%   Output Arguments:
%       singletonObject - The openminds.internal.InstanceLibrary of the
%       session. The same handle is returned on every call while the
%       library stays current. It is replaced, and the previous handle
%       deleted, when the location asked for differs from the one in
%       use, when the model version is found to have changed since the
%       library was read, or on Reset=true.
%
%   See also InstanceLibrary, notifyModelVersionChanged,
%   openminds.internal.listControlledInstances

    arguments
        folderPath (1,1) string = ...
            openminds.internal.constants.Paths.LocalInstanceFolder;

        options.UseGit (1,1) logical = false
        options.Reset (1,1) logical = false
    end

    import openminds.internal.InstanceLibrary

    % InstanceLibraryLocation is stored as an absolute path, so the
    % requested path is made absolute before the two are compared.
    folderPath = openminds.internal.utility.resolveAbsolutePath(folderPath);

    % Only the default location is downloaded into, so any other location
    % has to hold a library already: at least one version folder.
    defaultLocation = openminds.internal.utility.resolveAbsolutePath( ...
        openminds.internal.constants.Paths.LocalInstanceFolder);

    if folderPath ~= defaultLocation ...
            && isempty(InstanceLibrary.listVersionFolders(folderPath))
        error("OPENMINDS:InstanceLibrary:LocationNotFound", ...
            ['No instance library at "%s": the folder does not exist, or ', ...
            'holds no version folder such as "latest". The library is only ', ...
            'downloaded into its default location, "%s". Another location ', ...
            'has to hold a copy of the library already.'], ...
            folderPath, defaultLocation)
    end

    SINGLETON_NAME = InstanceLibrary.SINGLETON_NAME;
    singletonObject = getappdata(0, SINGLETON_NAME);

    currentModelVersion = openminds.version();

    if ~isempty(singletonObject) && isvalid(singletonObject)
        % Replaced when another location is asked for, when the table was
        % typed against another model version, or when asked to.
        isStale = ~strcmp(folderPath, singletonObject.InstanceLibraryLocation) ...
            || ~strcmp(currentModelVersion, singletonObject.ModelVersion) ...
            || options.Reset;

        if isStale
            delete(singletonObject)
            singletonObject = [];
        end
    end

    % Create a new singleton if necessary
    if isempty(singletonObject) || ~isvalid(singletonObject)
        options = rmfield(options, 'Reset');
        nvPairs = namedargs2cell(options);
        singletonObject = InstanceLibrary(folderPath, nvPairs{:});
        setappdata(0, SINGLETON_NAME, singletonObject)
    end
end
