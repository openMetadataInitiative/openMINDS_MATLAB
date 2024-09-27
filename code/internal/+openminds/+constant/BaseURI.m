function baseURI = BaseURI(version)
    
    arguments
        version (1,1) openminds.internal.utility.VersionNumber ...
            {openminds.mustBeValidVersion(version)} = "3.0" % Todo: change to latest
    end

    if version <= 3
        baseURI = "https://openminds.ebrains.eu";

    elseif version >= 4
        baseURI = "https://openminds.om-i.org";
    end
end
