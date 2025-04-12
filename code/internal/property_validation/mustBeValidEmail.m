function mustBeValidEmail(value)
    % todo: include dashes and dots, and multilevel domains.
    % Compare match to value to see if they are equal..
    if ~isempty(value)
        matchedPattern = regexp(value, '\w*\@\w*\.\w*', 'match');
        isValid = ~isempty(matchedPattern);
        if ~isValid()
            error('OPENMINDS_MATLAB:PropertyValidators:InvalidEmail', ...
                '"%s" is not a valid email adress', value)
        end
    end
end
