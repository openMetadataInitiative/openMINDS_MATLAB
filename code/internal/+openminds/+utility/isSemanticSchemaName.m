function tf = isSemanticSchemaName(fullSchemaName)
%isSemanticSchemaName Check if name is a semantic name
    tf = startsWith(fullSchemaName, openminds.constant.BaseURI);
end
