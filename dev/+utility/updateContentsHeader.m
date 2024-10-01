function updateContentsHeader(toolboxFolder, contentsHeader)
    arguments
        toolboxFolder (1,1) string {mustBeFolder(toolboxFolder)}
        contentsHeader (1,1) string
    end

    % Read Contents.m
    contentsFilePath = fullfile(toolboxFolder, 'Contents.m');
    contentsStr = fileread(contentsFilePath);

    % Assume header is 5 lines
    contentsStrLines = strsplit(contentsStr, newline);
    contentsStrLines(1:5) = cellstr(strsplit(contentsHeader, newline));

    % Update Contents.m
    fid = fopen(contentsFilePath, 'w');
    fwrite(fid, strjoin(contentsStrLines, newline));
    fclose(fid);

    fprintf('Updated %s\n', contentsFilePath)
    disp(strjoin(contentsStrLines, newline))
end
