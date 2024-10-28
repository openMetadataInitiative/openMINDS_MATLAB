toolsDir = fileparts(fileparts(mfilename('fullpath')));
addpath(genpath(toolsDir))

failed = string.empty;

try
    ommtools.codespellToolbox
catch
    failed = [failed, "codespell"];
end

try
    %ommtools.stylecheckToolbox %todo...
catch %#ok<UNRCH>
    failed = [failed, "stylecheck"];
end

if ~isempty(failed)
    message = strjoin("  " + failed, newline);
    error('The following checks failed:\n%s', message)
end
