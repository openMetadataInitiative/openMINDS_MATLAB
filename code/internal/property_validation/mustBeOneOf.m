function mustBeOneOf(value, allowedTypes)

    if ~iscell(value)
        value = {value};
    end
    
    isOneOf = false(size(value));
    for i = 1:numel(value)
        for j = 1:numel(allowedTypes)
            if isa(value{i}, allowedTypes{j})
                isOneOf(i) = true;
                continue
            end
         end
    end

    isValidType = all( isOneOf );
    validTypesStr = getValidTypesAsFormattedString(allowedTypes);

    if ~isValidType
        error('Value must be one of the following types:' + validTypesStr)
    end
    % assert(isValidType, 'Value must be one of the following types:' + validTypesStr)
end

function str = getValidTypesAsFormattedString(allowedTypes)
    allowedTypes = strcat("  ", allowedTypes);
    str = sprintf("\n" + strjoin( allowedTypes, ",\n") + "\n");
end
