function baseURI = BaseURI(version)
    
    arguments
        version (1,1) string = missing
    end

    if ismissing(version)
        version = "latest"; % Todo: Get from preferences
    end

    versionNumber = 3; %Todo: Version as number

    if versionNumber <= 3
        baseURI = "https://openminds.ebrains.eu";

    elseif versionNumber >= 4
        baseURI = "https://openminds.om-i.org";
    end
end
