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
    
    if ~any(isMatch)
        throwNoMatchingSchemaException(schemaName);
    end

    S = S(isMatch);
    schemaLabel = string( S(1).label );

    if numel(S) == 1
        return
    else
        if getpref('openminds_ui', 'dev', false)
            displayMultipleMatchingSchemasWarning(schemaName); % Todo
        end
    end
end

function throwNoMatchingSchemaException(schemaAlias)
% throwNoMatchingSchemaException Throws an exception for non-matching schemaName.
    error('OPENMINDS:SchemaNameNotFound', 'No schema name matching "%s" was found.', schemaAlias);
end

function displayMultipleMatchingSchemasWarning(schemaName)
    warning('Multiple vocab type elements matched schema with name "%s"', schemaName)
end
