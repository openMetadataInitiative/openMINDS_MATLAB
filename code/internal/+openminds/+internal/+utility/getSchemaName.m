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

    if isSemanticName(fullSchemaName)
        schemaName = getSchemaNameFromSemanticName(fullSchemaName);
    elseif isFullClassName(fullSchemaName)
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

function tf = isSemanticName(fullSchemaName)
%isSemanticName Check if name is a semantic name
    tf = startsWith(fullSchemaName, "https://openminds.ebrains.eu");
end

function tf = isFullClassName(fullSchemaName)
%isSemanticName Check if name is MATLAB full class name
    %tf = contains(fullSchemaName, '.') && exist(fullSchemaName, 'class') == 8;
    tf = contains(fullSchemaName, '.') && ~isempty(meta.class.fromName(fullSchemaName));
end

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
