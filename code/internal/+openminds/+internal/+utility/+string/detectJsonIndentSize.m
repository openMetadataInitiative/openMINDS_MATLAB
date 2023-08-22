function indentSize = detectJsonIndentSize(jsonStr)
    match = regexp(jsonStr, '(?<=\n)\s*', 'match', 'once');
    indentSize = numel(match);
end