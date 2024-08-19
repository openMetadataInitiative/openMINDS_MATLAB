function tf = isSchemaClassName(fullSchemaName)
%isSchemaClassName Check if name is MATLAB full class name for schema
    tf = startsWith(fullSchemaName, "openminds.") && ...
            ~isempty(meta.class.fromName(fullSchemaName));
end