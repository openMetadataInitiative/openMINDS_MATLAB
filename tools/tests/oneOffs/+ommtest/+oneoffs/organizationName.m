function name = organizationName(org)
% organizationName - Return the active schema's primary organization name.

    if isprop(org, "name")
        name = org.name;
    else
        name = org.fullName;
    end
end
