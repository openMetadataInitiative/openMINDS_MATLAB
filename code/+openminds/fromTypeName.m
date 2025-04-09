function instance = fromTypeName( typeNameURI, identifier )
    arguments
        typeNameURI
        identifier = ''
    end
    enumType = openminds.enum.Types.fromAtType(typeNameURI);
    instance = feval(enumType.ClassName, 'id', identifier);
end
