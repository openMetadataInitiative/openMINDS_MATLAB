function color = getSchemaColor(schemaName)
    
    persistent typesVocab

    if isempty(typesVocab)
        typesVocab = openminds.internal.vocab.loadVocabJson("types");
    end
    
    C = struct2cell(typesVocab);

    allNames = cellfun(@(c) string(c.name), C);
    isMatch = strcmpi(allNames, schemaName);

    if any(isMatch)
        color = C{isMatch}.color;
    else
        error('No schemas matched name "%s"', schemaName)
    end
end
