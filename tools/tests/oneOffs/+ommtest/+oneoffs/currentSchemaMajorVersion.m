function majorVersion = currentSchemaMajorVersion()
% currentSchemaMajorVersion - Identify the active openMINDS schema generation.

    schemaVersion = openminds.getModelVersion("VersionNumber");

    if schemaVersion > 4
        majorVersion = 5;
    else
        majorVersion = 4;
    end
end
