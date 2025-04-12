function mustBeOneOf(value, allowedTypes)
% mustBeOneOf - Check that value(s) are object(s) of the allowed classes
%
% This function is almost identical to the builtin mustBeA, but will also work
% if value is a cell array of heterogeneous objects.

    if ~iscell(value)
        value = {value};
    end

    if ischar(allowedTypes)
        allowedTypes = {allowedTypes};
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
        error(...
            'OPENMINDS_MATLAB:PropertyValidators:MustBeTypeOf', ...
            'Value must be one of the following types:' + validTypesStr)
    end
    % assert(isValidType, 'Value must be one of the following types:' + validTypesStr)
end

function str = getValidTypesAsFormattedString(allowedTypes)
    allowedTypes = strcat("  ", allowedTypes);
    str = sprintf("\n" + strjoin( allowedTypes, ",\n") + "\n");
end
