function folded_message = strfold(message, length)
    % Initialize an empty cell array to store the folded lines
    folded_message = {};

    % Split the message into words
    words = strsplit(message);

    % Initialize the current line as an empty string
    line = '';

    % Loop through the words in the message
    for i = 1:numel(words)
        % If the length of the current line plus the length of the next word plus one for the space between words is less than or equal to the desired length, add the word to the current line
        if numel(line) + numel(words{i}) + 1 <= length
            line = [line ' ' words{i}]; %#ok<AGROW>
        % Otherwise, add the current line to the folded message and start a new line with the next word
        else
            folded_message{end+1} = strtrim(line); %#ok<AGROW>
            line = words{i};
        end
    end

    % Add the last line to the folded message
    folded_message{end+1} = strtrim(line);
end
