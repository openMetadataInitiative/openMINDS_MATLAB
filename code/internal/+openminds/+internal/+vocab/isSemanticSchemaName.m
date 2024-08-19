function tf = isSemanticSchemaName(fullSchemaName)
%isSemanticName Check if name is a semantic name
    tf = startsWith(fullSchemaName, "https://openminds.ebrains.eu");
end