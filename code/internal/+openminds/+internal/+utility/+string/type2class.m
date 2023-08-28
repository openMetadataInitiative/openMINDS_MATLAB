function className = type2class(openmindsType)

    typeSplit = strsplit(openmindsType, '/');

    modelName = typeSplit{end-1};
    schemaName = typeSplit{end};

    className = sprintf('openminds.%s.%s', modelName, schemaName);
end