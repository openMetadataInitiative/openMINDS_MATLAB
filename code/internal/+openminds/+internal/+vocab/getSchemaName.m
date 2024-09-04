function schemaName = getSchemaName(nameAlias)
% getSchemaName - Get name (or type) for a schema given a name alias.
%
%   Todo: Describe what nameAlias is

    persistent typesVocab

    if isempty(typesVocab)
        typesVocab = openminds.internal.vocab.loadVocabJson("types");
    end

    C = struct2cell(typesVocab);
    S = [C{:}];

    allNames = {S.name};

    isMatch = strcmpi(allNames, nameAlias);

    schemaName = string( allNames(isMatch) );

    if numel(schemaName) == 1
        return
    elseif isempty(schemaName)
        throwEmptySchemaNameException(schemaAlias);
    else
        throwMultipleSchemaNamesException(schemaAlias);
    end
end

function throwEmptySchemaNameException(schemaAlias)
% THROWEMPTYSCHEMANAMEEXCEPTION Throws an exception for empty schemaName.
    error('OPENMINDS:SchemaNameNotFound', 'No schema name matching "%s" was found.', schemaAlias);
end

function throwMultipleSchemaNamesException(schemaAlias)
    % THROWMULTIPLESCHEMANAMESEXCEPTION Throws an exception for multiple schemaNames.
    error('OPENMINDS:MultipleSchemaNamesFound', 'Multiple schema names matched "%s".', schemaAlias)
end

