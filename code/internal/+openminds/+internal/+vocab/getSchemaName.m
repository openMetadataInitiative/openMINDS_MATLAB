function schemaName = getSchemaName(nameAlias)
% getSchemaName - Get name (or type) for a schema given a name alias.
%
%   schemaName = openminds.internal.vocab.getSchemaName(nameAlias) returns
%   the name (or type) of a Schema given a name alias. A name alias can be
%   a variation of the schema name, like a lowercase representation of the
%   schema name, or the label for a schema.
%
%   Examples:
%       openminds.internal.vocab.getSchemaName("person")
%       ans =
%
%           "Person"
%
%       openminds.internal.vocab.getSchemaName("protocol execution")
%       ans =
%
%           "ProtocolExecution"

    persistent typesVocab

    if isempty(typesVocab)
        typesVocab = openminds.internal.vocab.loadVocabJson("types");
    end

    C = struct2cell(typesVocab);
    S = [C{:}];

    allNames = {S.name};

    isMatch = strcmpi(allNames, nameAlias);
    
    if ~any(isMatch)
        allLabels = {S.label};
        isMatch = strcmpi(allLabels, nameAlias);
    end

    schemaName = string( allNames(isMatch) );

    if numel(schemaName) == 1
        return
    elseif isempty(schemaName)
        throwEmptySchemaNameException(nameAlias);
    else
        throwMultipleSchemaNamesException(nameAlias);
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
