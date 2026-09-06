function schemaClassName = classNameFromUri(schemaUri)
    
    arguments
        schemaUri char
    end

    persistent schemaList
    if isempty(schemaList)
        schemaList = openminds.internal.utility.dir.listSourceSchemas();
    end

    uri = matlab.net.URI(schemaUri);
    schemaModule = uri.Path(2);
    schemaName = uri.Path(3);

    isMatch = strcmpi(schemaList.SchemaName, schemaName) ...
                & strcmpi(schemaList.ModuleName, schemaModule);
    if ~any(isMatch)
        schemaClassName = '';
        warning('OPENMINDS:SchemaNotFound', 'Schema %s.%s was not found', schemaModule, schemaName)
    else
        t = schemaList(isMatch, :);
        % schemaClassName = openminds.internal.utility.string.buildClassName(t.SchemaName, t.SubModuleName, t.ModuleName);
        schemaClassName = openminds.internal.utility.string.buildClassName(t.SchemaName, '', t.ModuleName);
    end
end
