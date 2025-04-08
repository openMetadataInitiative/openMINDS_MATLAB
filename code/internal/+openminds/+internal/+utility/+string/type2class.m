function className = type2class(openmindsType)

    typeSplit = strsplit(openmindsType, '/');
    schemaName = typeSplit{end};
    
    if startsWith(openmindsType, "https://openminds.om-i.org/types")
        className = openminds.enum.Types(schemaName).ClassName;
    else
        modelName = lower( typeSplit{end-1} );
        className = sprintf('openminds.%s.%s', modelName, schemaName);
    end
end
