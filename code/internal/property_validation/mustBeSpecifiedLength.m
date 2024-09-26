function mustBeSpecifiedLength(value, minLength, maxLength)
    
    if isempty(value); return; end

    if length(value) < minLength
        error('Must be an array of minimum %d items', minLength)
    end

    if length(value) > maxLength
        error('Must be an array of maximum %d items', maxLength)
    end
end
