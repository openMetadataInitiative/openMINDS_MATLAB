function propertyIRIPrefix = PropertyIRIPrefix()
    baseIRI = openminds.constant.BaseIRI();
    if startsWith(baseIRI, "https://openminds.ebrains.eu")
        propertyIRIPrefix = sprintf("%s/vocab/", baseIRI);
    else
        propertyIRIPrefix = sprintf("%s/props/", baseIRI);
    end
end
