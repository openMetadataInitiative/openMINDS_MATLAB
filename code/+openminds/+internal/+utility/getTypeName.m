function typeName = getTypeName(name, stringCase)
%getTypeName Type name from a class name, a type IRI, or a plain name
%
%   name may be a string array; the result has the same shape.
%
%   typeName = openminds.internal.utility.getTypeName(name)
%
%   Example:
%   name = 'openminds.core.research.Subject';
%   typeName = openminds.internal.utility.getTypeName(name)
%   typeName =
%
%     'Subject'

    arguments
        name (1,:) string
        stringCase (1,1) string = "same"
    end

    if ~isscalar(name)
        typeName = arrayfun(@(n) openminds.internal.utility.getTypeName(n, stringCase), name);
        return
    end

    if openminds.utility.isTypeIRI(name)
        typeName = typeNameFromTypeIRI(name);
    elseif openminds.utility.isTypeClassName(name) || contains(name, 'mixedtype')
        typeName = typeNameFromClassName(name);
    else
        typeName = name;
    end

    if isempty(typeName)
        typeName = name;
    end

    if stringCase == "same"
        return
    elseif stringCase == "camel"
        typeName = openminds.internal.utility.string.camelCase(typeName);
    elseif stringCase == "upper"
        typeName = upper(typeName);
    else
        error('String case "%s" is not implemented', stringCase)
    end
end

% TODO:Utility methods:
function typeName = typeNameFromTypeIRI(typeIRI)
    [~, typeName] = fileparts(typeIRI);
end

function typeName = typeNameFromClassName(name)
    if contains(name, 'mixedtype')
        [name, ~] = openminds.internal.utility.string.packageParts(name);
    end

    expression = '(?<=\.)\w*$'; % Get every word after a . at the end of a string
    typeName = regexp(name, expression, 'match', 'once');
end
