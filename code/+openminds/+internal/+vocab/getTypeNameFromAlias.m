function typeName = getTypeNameFromAlias(nameAlias)
% getTypeNameFromAlias - Canonical type name for an alias, such as a lowercase name or a label.
%
%   typeName = openminds.internal.vocab.getTypeNameFromAlias(nameAlias) returns
%   the name (or type) of a Schema given a name alias. A name alias can be
%   a variation of the schema name, like a lowercase representation of the
%   schema name, or the label for a schema.
%
%   Examples:
%       openminds.internal.vocab.getTypeNameFromAlias("person")
%       ans =
%
%           "Person"
%
%       openminds.internal.vocab.getTypeNameFromAlias("protocol execution")
%       ans =
%
%           "ProtocolExecution"

    persistent typesVocab

    if isempty(typesVocab)
        typesVocab = openminds.internal.vocab.loadVocabJson("types");
    end

    C = struct2cell(typesVocab);

    allNames = cellfun(@(c) string(c.name), C);
    isMatch = strcmpi(allNames, nameAlias);
    
    if ~any(isMatch)
        allLabels = cellfun(@(c) string(c.label), C);
        isMatch = strcmpi(allLabels, nameAlias);
    end

    typeName = string( allNames(isMatch) );

    if isscalar(typeName)
        return
    elseif isempty(typeName)
        throwEmptyTypeNameException(nameAlias);
    else
        throwMultipleTypeNamesException(nameAlias);
    end
end

function throwEmptyTypeNameException(schemaAlias)
% THROWEMPTYSCHEMANAMEEXCEPTION Throws an exception for empty typeName.
    error('OPENMINDS:TypeNameNotFound', 'No type name matching "%s" was found.', schemaAlias);
end

function throwMultipleTypeNamesException(schemaAlias)
    % THROWMULTIPLESCHEMANAMESEXCEPTION Throws an exception for multiple schemaNames.
    error('OPENMINDS:MultipleTypeNamesFound', 'Multiple type names matched "%s".', schemaAlias)
end
