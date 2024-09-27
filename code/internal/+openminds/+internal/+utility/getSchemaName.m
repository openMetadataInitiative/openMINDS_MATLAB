function schemaName = getSchemaName(fullSchemaName, stringCase)
%getSchemaName Get schema name from full schema class name or semantic name
%
%   schemaName = openminds.internal.utility.getSchemaName(fullSchemaName)
%
%   Example:
%   fullSchemaName = 'openminds.core.research.Subject';
%   schemaName = openminds.internal.utility.getSchemaName(fullSchemaName)
%   schemaName =
%
%     'Subject'

    arguments
        fullSchemaName (1,1) string
        stringCase (1,1) string = "same"
    end

    if openminds.utility.isSemanticSchemaName(fullSchemaName)
        schemaName = getSchemaNameFromSemanticName(fullSchemaName);
    elseif openminds.utility.isSchemaClassName(fullSchemaName) || contains(fullSchemaName, 'mixedtype')
        schemaName = getSchemaNameFromFullMatlabClassName(fullSchemaName);
    else
        schemaName = fullSchemaName;
    end

    if isempty(schemaName)
        schemaName = fullSchemaName;
    end

    if stringCase == "same"
        return
    elseif stringCase == "camel"
        schemaName = openminds.internal.utility.string.camelCase(schemaName);
    elseif stringCase == "upper"
        schemaName = upper(schemaName);
    else
        error('String case "%s" is not implemented', stringCase)
    end
end

% TODO:Utility methods:
function schemaName = getSchemaNameFromSemanticName(semanticName)
    [~, schemaName] = fileparts(semanticName);
end

function schemaName = getSchemaNameFromFullMatlabClassName(fullSchemaName)
    if contains(fullSchemaName, 'mixedtype')
        [fullSchemaName, ~] = openminds.internal.utility.string.packageParts(fullSchemaName);
    end

    expression = '(?<=\.)\w*$'; % Get every word after a . at the end of a string
    schemaName = regexp(fullSchemaName, expression, 'match', 'once');
end
