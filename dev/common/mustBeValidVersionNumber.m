function mustBeValidVersionNumber(versionNumber)
    suggestion = 'The version format should be: <major>.<minor>.<patch> or <major>.<minor>.<patch>.<build>.';
    pattern = '^\d+\.\d+\.\d+$|^\d+\.\d+\.\d+\.\d+$';
    assert( ~isempty( regexp(versionNumber, pattern, 'once')), ...
        'The version number "%s" is incorrect.\n%s', versionNumber, suggestion)
end
