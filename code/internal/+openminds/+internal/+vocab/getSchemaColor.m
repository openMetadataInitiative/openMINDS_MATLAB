function color = getSchemaColor(schemaName)
    
    persistent typesVocab

    if isempty(typesVocab)
        typesVocab = openminds.internal.vocab.loadVocabJson("types");
    end    
    
    C = struct2cell(typesVocab);
    S = [C{:}];

    isMatch = strcmp({S.name}, schemaName);

    if any(isMatch)
        color = S(isMatch).color;
    else
        error('No schemas matched name "%s"', schemaName)
    end
end