function textStr = cellArrayToTextStringArray(cellArray)
%cellArrayToTextString Create a text string representing the cell array                
    cellOfPaddedStrings = cellfun(@(c) sprintf('"%s"', c), cellArray, 'UniformOutput', false);
    textStr = sprintf('[%s]', strjoin(cellOfPaddedStrings, ', '));
end
