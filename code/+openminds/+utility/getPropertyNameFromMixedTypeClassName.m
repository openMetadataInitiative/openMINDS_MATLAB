function propertyName = getPropertyNameFromMixedTypeClassName(mixedTypeClassName)
% getPropertyNameFromMixedTypeClassName - Get property name from a mixed type class name
    arguments
        mixedTypeClassName (1,1) string
    end

    mixedTypeClassNameSplit = strsplit(mixedTypeClassName, '.');
    propertyName = openminds.internal.vocab.getPropertyName( mixedTypeClassNameSplit{end} );
end
