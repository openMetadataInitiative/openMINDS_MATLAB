function postProcessLivescriptHtml(htmlFile)
%POSTPROCESSLIVESCRIPHTML Postprocess livescript HTMLs for improved online functionality
% 
% This function performs the following actions:

%
% Syntax:
%   postProcessLivescriptHtml(htmlFile)
%
% Input:
%   htmlFile - (1,1) string: Path to the HTML file to process.
%
% Example:
%   postProcessLivescriptHtml("example.html");

    arguments
        htmlFile (1,1) string {mustBeFile}
    end

    % Read the content of the HTML file
    htmlContent = fileread(htmlFile);

    % Remove unstable MATLAB-generated metadata from output wrappers.
    htmlContent = stripOutputWrapperUidAttributes(htmlContent);
    htmlContent = normalizeVariableEditorIds(htmlContent);

    % Write the modified content back to the HTML file
    try
        fid = fopen(htmlFile, 'wt');
        if fid == -1
            error('Could not open the file for writing: %s', htmlFile);
        end
        fwrite(fid, htmlContent, 'char');
        fclose(fid);
    catch
        error('Could not write to the file: %s', htmlFile);
    end
end

function htmlContent = stripOutputWrapperUidAttributes(htmlContent)
    expr = '(<div[^>]*class\s*=\s*"[^"]*eoOutputWrapper[^"]*")\s+uid="[^"]*"';
    htmlContent = regexprep(htmlContent, expr, '$1');
end

function htmlContent = normalizeVariableEditorIds(htmlContent)
    expr = 'variableeditor_(client_Document|views_SummaryBar|TableViewModel)_([0-9]+)';
    tokens = regexp(htmlContent, expr, 'tokens');

    if isempty(tokens)
        return
    end

    originalSuffixes = cellfun(@(token) token{2}, tokens, 'UniformOutput', false);
    uniqueSuffixes = unique(originalSuffixes, 'stable');

    for i = 1:numel(uniqueSuffixes)
        oldSuffix = uniqueSuffixes{i};
        tempSuffix = sprintf('__omm_variableeditor_%d__', i);
        htmlContent = regexprep(htmlContent, ...
            ['(variableeditor_(?:client_Document|views_SummaryBar|TableViewModel)_)' oldSuffix], ...
            ['$1' tempSuffix]);
    end

    for i = 1:numel(uniqueSuffixes)
        tempSuffix = sprintf('__omm_variableeditor_%d__', i);
        newSuffix = string(i);
        htmlContent = strrep(htmlContent, tempSuffix, char(newSuffix));
    end
end
