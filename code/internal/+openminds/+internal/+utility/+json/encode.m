function str = encode(s)
    
    str = jsonencode(s, 'PrettyPrint', true);
    % Todo: Use regexp to make sure we only replace json key names
    str = strrep(str, '"x_', '"_');
    str = strrep(str, '"at_', '"@');
    str = strrep(str, '[]', 'null');
    
    if ~isequal(str(end), newline)
        str = sprintf('%s\n', str);
    end
end