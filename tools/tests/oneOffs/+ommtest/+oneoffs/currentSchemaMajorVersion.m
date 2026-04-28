function majorVersion = currentSchemaMajorVersion()
% currentSchemaMajorVersion - Identify the active openMINDS schema generation.

    % Use the Organization type for probing
    organizationMeta = meta.class.fromName("openminds.core.actors.Organization");
    propertyNames = string({organizationMeta.PropertyList.Name});

    if any(propertyNames == "name") && any(propertyNames == "countryOfFormation")
        majorVersion = 5;
    else
        majorVersion = 4;
    end
end
