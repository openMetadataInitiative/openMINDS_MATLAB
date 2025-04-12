function mustBeValidTime(value)
    isValid = all(value.Year == 0 & value.Month == 0 & value.Day == 0);
    if ~isValid
        warning('OPENMINDS_MATLAB:PropertyValidators:InvalidTime', ...
            'Value must be a datetime value without date information')
    end
end
