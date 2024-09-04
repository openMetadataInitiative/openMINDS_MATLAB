function tf = isEmbeddedType(schemaType, propertyName)
    arguments
        schemaType (1,1) openminds.enum.Types
        propertyName (1,1) string
    end

    embeddedPropsForSchema = eval(sprintf("%s.EMBEDDED_PROPERTIES", schemaType.ClassName));
    tf = isfield(embeddedPropsForSchema, propertyName);
end