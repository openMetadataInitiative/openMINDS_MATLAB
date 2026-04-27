function org = organizationWithTwoIds()
% organizationWithTwoIds - Create a v5 Organization with two digital IDs.

    ror = openminds.core.RORID("identifier", "https://ror.org/01xtthb56");
    rrid = openminds.core.RRID( ...
        "identifier", "https://scicrunch.org/resolver/RRID:SCR_012345");

    org = openminds.core.Organization( ...
        "digitalIdentifier", {ror, rrid}, ...
        "name", "University of Oslo");
end
