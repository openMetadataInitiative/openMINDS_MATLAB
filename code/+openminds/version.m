function versionStr = version(version)
    arguments
        version (1,1) openminds.internal.utility.VersionNumber ...
            {openminds.mustBeValidVersion(version)} = missing
    end
    if ismissing(version)
        versionStr = string(openminds.getModelVersion());
    else
        openminds.selectOpenMindsVersion(version)
        versionStr = string(version);
    end
end
