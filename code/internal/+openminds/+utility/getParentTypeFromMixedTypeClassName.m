function schemaName = getParentTypeFromMixedTypeClassName(mixedTypeClassName)
% getParentTypeFromMixedTypeClassName - Get (metadata) type name from a mixed type class name

    arguments
        mixedTypeClassName (1,1) string
    end

    mixedTypeClassNameSplit = strsplit(mixedTypeClassName, '.');
    schemaNameLowercase = mixedTypeClassNameSplit{end-1};
    schemaName = openminds.internal.vocab.getSchemaName(schemaNameLowercase);
end
