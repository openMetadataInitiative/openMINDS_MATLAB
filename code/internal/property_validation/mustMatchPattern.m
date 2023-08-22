function mustMatchPattern(str, pattern)
    isValid = ~isempty( regexp(str, pattern, "match") ) || str == "";
    assert(isValid, '\nString must match the following pattern: %s', pattern)
end