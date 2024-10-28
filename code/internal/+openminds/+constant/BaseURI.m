function baseURI = BaseURI(version)
    
    arguments
        version (1,1) openminds.internal.utility.VersionNumber ...
            {openminds.mustBeValidVersion(version)} = missing
    end

    if ismissing(version)
        version = openminds.internal.utility.VersionNumber( ...
            openminds.getSchemaVersion() ...
            );
    end

    if version <= 3
        baseURI = "https://openminds.ebrains.eu";

    elseif version >= 4
        baseURI = "https://openminds.om-i.org";
    end
end
