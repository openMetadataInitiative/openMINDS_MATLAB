function mustBeValidStringLength(value, minLength, maxLength)
% mustBeValidStringLength - Checks if a string has a length within specified limits.
% 
% Syntax:
%   mustBeValidStringLength(value, minLength, maxLength) checks that the 
%   input string's length is between minLength and maxLength.
% 
% Input Arguments: 
%   value       - The string to be validated.
%   minLength   - The minimum allowed length of the string.
%   maxLength   - The maximum allowed length of the string.
% 
% Output Arguments: 
%   None. This function will throw an error if the validation fails.

    if numel(value) > 1
    end
    
    if minLength > 0
        msg = sprintf('String must be between %d and %d characters', minLength, maxLength);
    else
        msg = sprintf('String must be maximum %d characters', maxLength);
    end
    
    assert(strlength(value) >= minLength && strlength(value) <= maxLength, ...
        'OPENMINDS_MATLAB:PropertyValidators:InvalidStringLength', msg)
end
