function mustBeValidDate(value)
    % Todo: Should this be considered invalid?
    % Skip NaT - Result of adding empty string to property value
    if isnat(value); return; end

    assert( all(value.Hour == 0 & value.Minute == 0 & value.Second == 0), ...
        'OPENMINDS_MATLAB:PropertyValidators:InvalidDate', ...
        'Value must be a datetime value without time information')
end
