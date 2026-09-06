function text = normalizeBlankNodeIds(text)
% normalizeBlankNodeIds - Replace generated blank-node ids with stable ones
%
%   Syntax:
%       text = ommtools.normalizeBlankNodeIds(text)
%
%   Description:
%       An instance created without an identifier gets a blank-node id
%       built from a fresh UUID, so the display header of every such
%       instance differs between two runs of the same live script. An
%       export that embeds those headers is therefore never the same twice,
%       and committing it would record a change on every run.
%
%       Each distinct id is replaced by _:<n>, numbered in order of first
%       appearance. Two displays of the same instance keep the same number,
%       so the export still shows which headers refer to one object.
%
%   Input Arguments:
%       text - Exported markdown or HTML, as a string scalar.
%
%   Output Arguments:
%       text - The same text with every blank-node id replaced.

    arguments
        text (1,1) string
    end

    % A blank-node id is "_:" followed by a canonical 8-4-4-4-12 hex UUID.
    ID_PATTERN = "_:[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}";

    ids = unique(regexp(text, ID_PATTERN, "match"), "stable");

    for i = 1:numel(ids)
        text = regexprep(text, regexptranslate("escape", ids(i)), "_:" + i);
    end
end
