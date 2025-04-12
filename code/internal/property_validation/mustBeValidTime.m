function mustBeValidTime(value)
    
    [h, m, s] = hms(value); hmsArray = [h; m; s];
    isValid = all(value.Year == -1) && all( sum(hmsArray, 1) ~= 0);

    if ~isValid
        warning('OPENMINDS_MATLAB:PropertyValidators:InvalidTime', ...
            'Value must be a datetime value without date information')
    end
end
