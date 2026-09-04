function controlledTermVersion = installControlledTermBase(modelVersion)
%installControlledTermBase Copy the controlled-term base for a model version into place
%
%   The base class for controlled terms differs between model versions.
%   The variant for the given version is copied over the tracked
%   openminds.base.ControlledTerm file, so this writes to the source
%   tree whenever the version changes.

    arguments
        modelVersion (1,1) openminds.internal.utility.VersionNumber ...
            {openminds.mustBeValidModelVersion(modelVersion)} = "latest"
    end

    controlledTermVersion = getControlledTermVersion(modelVersion);

    rootPath = openminds.toolboxdir();
    baseFolder = fullfile(rootPath, "+openminds", "+base");
    sourceFile = fullfile(baseFolder, "private", "controlledTerms", ...
        controlledTermVersion, "ControlledTerm.m");
    targetFile = fullfile(baseFolder, "ControlledTerm.m");

    if ~isfile(sourceFile)
        error("openMINDS:ControlledTerm:MissingVersionedBase", ...
            'No controlled-term base exists for version "%s".', controlledTermVersion)
    end

    sourceText = fileread(sourceFile);
    if isfile(targetFile)
        targetText = fileread(targetFile);
    else
        targetText = '';
    end

    if ~strcmp(sourceText, targetText)
        [success, message] = copyfile(sourceFile, targetFile, "f");
        if ~success
            error("openMINDS:ControlledTerm:ActivationFailed", ...
                'Could not activate controlled-term base "%s": %s', ...
                controlledTermVersion, message)
        end
        rehash
    end
end

function controlledTermVersion = getControlledTermVersion(modelVersion)
    if modelVersion >= 5
        controlledTermVersion = "v3";
    else
        controlledTermVersion = "v2";
    end
end
