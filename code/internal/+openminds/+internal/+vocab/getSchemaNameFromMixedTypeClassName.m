function schemaName = getSchemaNameFromMixedTypeClassName(mixedTypeClassName)
% getSchemaNameFromMixedTypeClassName - Get schema name from a mixed type class name
    arguments
        mixedTypeClassName (1,1) string
    end

    mixedTypeClassNameSplit = strsplit(mixedTypeClassName, '.');
    schemaNameLowercase = mixedTypeClassNameSplit{end-1};
    schemaName = openminds.internal.vocab.getSchemaName(schemaNameLowercase);
end