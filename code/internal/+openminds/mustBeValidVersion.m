function mustBeValidVersion(version)
    arguments
        version (1,1) openminds.internal.utility.VersionNumber
    end

    % Allow missing version specification
    if ismissing(version); return; end

    validVersions = openminds.internal.listValidVersions();
    version.Format = 'vX.Y';
    version.validateVersion(version, validVersions{:})
end