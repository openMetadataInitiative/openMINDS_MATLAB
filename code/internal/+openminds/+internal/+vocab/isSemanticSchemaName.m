function tf = isSemanticSchemaName(fullSchemaName)
%isSemanticName Check if name is a semantic name
    tf = startsWith(fullSchemaName, openminds.constant.BaseURI);
end