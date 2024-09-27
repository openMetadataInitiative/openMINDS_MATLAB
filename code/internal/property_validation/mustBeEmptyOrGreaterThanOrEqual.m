function mustBeEmptyOrGreaterThanOrEqual(value, minimumValue)
%mustBeEmptyOrGreaterThanOrEqual

    isValid = isnan(value) || value > minimumValue;

    msg = sprintf('Value must be greater than or equal to %d.', minimumValue);
    assert( isValid, msg)
end
