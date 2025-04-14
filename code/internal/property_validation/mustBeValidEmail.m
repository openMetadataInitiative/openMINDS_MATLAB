function mustBeValidEmail(value)
% mustBeValidEmail - Validate if the input is formatted as an email address.
%
% Syntax:
%   mustBeValidEmail(value) Checks if the input is formatted as an email 
%   address and raises an error if it is invalid. This is not an exhaustive 
%   validation and it does not guarantee that the email address exists.
%
% Input Arguments:
%   value - A string representing the email address to be validated.

    arguments
        value (1,1) string 
    end
    
    value = char(value);

    if ~isempty(value)
        pattern = '^[^@\s]+@[^@\s]+\.[^@\s]+$';
        matchedStr = regexp(value, pattern, 'match', 'once');
        isValid = ~isempty(matchedStr);
        if ~isValid()
            error('OPENMINDS_MATLAB:PropertyValidators:InvalidEmail', ...
                '"%s" is not formatted as a valid email adress', value)
        end
    end
end
