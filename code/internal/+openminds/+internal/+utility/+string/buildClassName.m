function name = buildClassName(schemaName, schemaCategory, schemaModule)
    
    arguments
        schemaName char
        schemaCategory char
        schemaModule char
    end

    schemaName = openminds.internal.utility.string.pascalCase(schemaName);
    schemaModule = lower(schemaModule);
    schemaCategory = lower(schemaCategory);
    
    if isempty(schemaCategory) % This might be empty, i.e for controlled terms
        name = strjoin({'openminds', schemaModule, schemaName}, '.');
    else
        name = strjoin({'openminds', schemaModule, schemaCategory, schemaName}, '.');
    end
end
