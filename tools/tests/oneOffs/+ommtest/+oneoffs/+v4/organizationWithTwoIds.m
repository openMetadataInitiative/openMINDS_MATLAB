function org = organizationWithTwoIds()
% organizationWithTwoIds - Create a v4 Organization with two digital IDs.

    ror = openminds.core.RORID("identifier", "https://ror.org/01xtthb56");
    grid = openminds.core.GRIDID( ...
        "identifier", "https://grid.ac/institutes/grid.5510.1");

    org = openminds.core.Organization( ...
        "digitalIdentifier", {ror, grid}, ...
        "fullName", "University of Oslo");
end
