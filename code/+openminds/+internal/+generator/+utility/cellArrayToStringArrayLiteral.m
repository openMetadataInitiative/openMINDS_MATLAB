function textStr = cellArrayToStringArrayLiteral(cellArray)
%cellArrayToStringArrayLiteral MATLAB string array literal, ["a", "b"], for a cell array of char
    cellOfPaddedStrings = cellfun(@(c) sprintf('"%s"', c), cellArray, 'UniformOutput', false);
    textStr = sprintf('[%s]', strjoin(cellOfPaddedStrings, ', '));
end
