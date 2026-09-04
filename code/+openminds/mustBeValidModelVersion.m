function mustBeValidModelVersion(version)
%mustBeValidModelVersion Validate that a version names an installed openMINDS model version
    arguments
        version (1,1) openminds.internal.utility.VersionNumber
    end

    % Allow missing version specification
    if ismissing(version); return; end

    validVersions = openminds.internal.listModelVersions();
    version.Format = 'vX.Y';
    version.validateVersion(version, validVersions{:})
end
