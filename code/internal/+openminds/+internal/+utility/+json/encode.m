function str = encode(s, options)

    arguments
        s struct
        options.PrettyPrint (1,1) logical = true
    end

    str = jsonencode(s, 'PrettyPrint', options.PrettyPrint);
    % Todo: Use regexp to make sure we only replace json key names
    % str = strrep(str, '"x_', '"_');
    str = strrep(str, '"x_', '"@');
    str = strrep(str, '"at_', '"@');
    str = strrep(str, '[]', 'null');
    
    if ~isequal(str(end), newline)
        str = sprintf('%s\n', str);
    end
end
