function typeLabel = getTypeLabel(typeName)
% getTypeLabel - Display label of a type, from the openMINDS types vocabulary
    arguments
        typeName (1,1) string
    end

    persistent typesVocab

    if isempty(typesVocab)
        typesVocab = openminds.internal.vocab.loadVocabJson("types");
    end

    C = struct2cell(typesVocab);

    allNames = cellfun(@(c) string(c.name), C);
    isMatch = strcmpi(allNames, typeName);
    
    if ~any(isMatch)
        throwNoMatchingTypeException(typeName);
    end

    S = C{isMatch};
    typeLabel = string( S(1).label );

    if isscalar(S)
        return
    else
        if getpref('openminds_ui', 'dev', false)
            displayMultipleMatchingSchemasWarning(typeName); % Todo
        end
    end
end

function throwNoMatchingTypeException(schemaAlias)
% throwNoMatchingTypeException Throws an exception for non-matching typeName.
    error('OPENMINDS:TypeNameNotFound', 'No type name matching "%s" was found.', schemaAlias);
end

function displayMultipleMatchingSchemasWarning(typeName)
    warning('Multiple vocab type elements matched the type name "%s"', typeName)
end
