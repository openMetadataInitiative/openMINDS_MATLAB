function org = organizationWithOneId()
% organizationWithOneId - Create a v4 Organization with one digital ID.

    ror = openminds.core.RORID("identifier", "https://ror.org/01xtthb56");

    org = openminds.core.Organization( ...
        "digitalIdentifier", ror, ...
        "fullName", "University of Oslo");
end
