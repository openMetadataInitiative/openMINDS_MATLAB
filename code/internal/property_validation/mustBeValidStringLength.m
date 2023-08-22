function mustBeValidStringLength(value, minLength, maxLength)
    
    if numel(value) > 1
        
    end
    
    if minLength > 0
        msg = sprintf('String must be between %d and %d characters', minLength, maxLength);
    else
        msg = sprintf('String must be maximum %d characters', maxLength);
    end
    
    assert(strlength(value) >= minLength && strlength(value) <= minLength, msg)
end

