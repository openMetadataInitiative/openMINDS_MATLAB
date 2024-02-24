function mustBeValidDate(value)
    assert(value.Hour == 0 && value.Minute == 0 && value.Second == 0, ...
        'Value must be a datetime value without time information')
end