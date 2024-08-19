function schemaLabel = getSchemaLabelFromName(schemaName)
    arguments
        schemaName (1,1) string
    end

    persistent typesVocab

    if isempty(typesVocab)
        typesVocab = openminds.internal.vocab.loadVocabJson("types");
    end

    C = struct2cell(typesVocab);
    S = [C{:}];

    allNames = {S.name};
    isMatch = strcmpi(allNames, schemaName);

    allLabels = {S.label};

    schemaLabel = string( allLabels(isMatch) );

    if numel(schemaName) == 1
        return
    elseif isempty(schemaName)
        throwNoMatchingSchemaException(schemaName);
    else
        throwMultipleMatchingSchemasException(schemaName);
    end
end
