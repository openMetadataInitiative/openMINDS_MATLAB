function mustBeOneOf(value, allowedTypes)

    if ~iscell(value)
        value = {value};
    end

    types = cellfun(@(c) class(c), value, 'UniformOutput', false);

    isValidType = iscell(value) && all(ismember(types, allowedTypes));
    validTypesStr = getValidTypesAsFormattedString(allowedTypes);

    if ~isValidType
        error('Value must be one of the following types:' + validTypesStr)
    end
    %assert(isValidType, 'Value must be one of the following types:' + validTypesStr)
end

function str = getValidTypesAsFormattedString(allowedTypes)
    allowedTypes = strcat("  ", allowedTypes);
    str = sprintf("\n" + strjoin( allowedTypes, ",\n") + "\n");
end