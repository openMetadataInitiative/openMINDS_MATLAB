function mustMatchPattern(str, pattern)
% mustMatchPattern - Validates that a string matches a specified pattern.
% 
% Syntax:
%   mustMatchPattern(str, pattern)
% 
% Input Arguments:
%   str     - The string to be validated.
%   pattern - The regular expression pattern that the string must match.

    isValid = ~isempty( regexp(str, pattern, "match") ) || str == "";
    assert(isValid, ...
        'OPENMINDS_MATLAB:PropertyValidators:TextDoesNotMatchPattern', ...
        '\nString must match the following pattern: %s', pattern)
end
