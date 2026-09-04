function mustBeMinLength(value, minLength)
    
    if isempty(value); return; end

    if length(value) < minLength
        error(...
            'OPENMINDS_MATLAB:PropertyValidators:ListIsTooShort', ...
            'Must be an array of minimum %d items', minLength)
    end
end
