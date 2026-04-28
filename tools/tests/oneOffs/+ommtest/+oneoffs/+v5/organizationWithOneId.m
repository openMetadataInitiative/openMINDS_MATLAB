function org = organizationWithOneId()
% organizationWithOneId - Create a v5 Organization with one digital ID.

    ror = openminds.core.RORID("identifier", "https://ror.org/01xtthb56");

    org = openminds.core.Organization( ...
        "digitalIdentifier", ror, ...
        "name", "University of Oslo");
end
