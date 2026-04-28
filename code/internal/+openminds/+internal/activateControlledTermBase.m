function controlledTermVersion = activateControlledTermBase(modelVersion)
%activateControlledTermBase Activate the controlled-term base for a model version.

    arguments
        modelVersion (1,1) openminds.internal.utility.VersionNumber ...
            {openminds.mustBeValidVersion(modelVersion)} = "latest"
    end

    controlledTermVersion = getControlledTermVersion(modelVersion);

    rootPath = openminds.internal.rootpath();
    abstractFolder = fullfile(rootPath, "internal", "+openminds", "+abstract");
    sourceFile = fullfile(abstractFolder, "private", ...
        "ControlledTerm_" + controlledTermVersion + ".m");
    targetFile = fullfile(abstractFolder, "ControlledTerm.m");

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
