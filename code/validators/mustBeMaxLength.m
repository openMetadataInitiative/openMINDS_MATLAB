function mustBeMaxLength(value, maxLength)
    
    if isempty(value); return; end

    if length(value) > maxLength
        error(...
            'OPENMINDS_MATLAB:PropertyValidators:ListIsTooLong', ...
            'Must be an array of maximum %d items', maxLength)
    end
end
