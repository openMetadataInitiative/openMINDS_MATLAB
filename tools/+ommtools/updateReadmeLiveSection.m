function updateReadmeLiveSection(readmePath, exportedMarkdownPath)
% updateReadmeLiveSection - Replace the README's generated section with an export
%
%   Syntax:
%       ommtools.updateReadmeLiveSection(readmePath, exportedMarkdownPath)
%
%   Description:
%       The README carries a region delimited by two HTML comments,
%       <!-- livescript:start --> and <!-- livescript:end -->. Everything
%       between them is replaced by the contents of a markdown file that
%       export produced from a live script, so the README's examples are
%       the live script's examples and cannot drift from it.
%
%       The export's headings are shifted so that its top level becomes a
%       third-level heading, nesting under the README's own "Getting
%       Started" heading whatever level the live script styled them at.
%
%   Input Arguments:
%       readmePath           - The README to update in place.
%       exportedMarkdownPath - Markdown produced by export(..., Run=true).

    arguments
        readmePath (1,1) string {mustBeFile}
        exportedMarkdownPath (1,1) string {mustBeFile}
    end

    START_MARKER = "<!-- livescript:start -->";
    END_MARKER = "<!-- livescript:end -->";
    TARGET_TOP_LEVEL = 3;

    readme = string(fileread(readmePath));
    exported = string(fileread(exportedMarkdownPath));

    startIndex = strfind(readme, START_MARKER);
    endIndex = strfind(readme, END_MARKER);
    if isempty(startIndex) || isempty(endIndex) || endIndex < startIndex
        error("openMINDS:Readme:MarkersNotFound", ...
            "README must contain %s followed by %s.", START_MARKER, END_MARKER)
    end

    exported = shiftHeadings(exported, TARGET_TOP_LEVEL);

    head = extractBefore(readme, startIndex + strlength(START_MARKER));
    tail = extractAfter(readme, endIndex - 1);

    updated = head + newline + strtrim(exported) + newline + tail;

    if ~strcmp(updated, readme)
        fileId = fopen(readmePath, "w");
        cleanup = onCleanup(@() fclose(fileId));
        fwrite(fileId, updated, "char");
    end
end

function text = shiftHeadings(text, targetTopLevel)
% Shift every heading so the shallowest one sits at targetTopLevel. Headings
% only begin a line, so anchor to line starts; a "#" inside a code block or
% mid-line is left alone.
    HEADING = "^(?<hashes>#{1,6}) ";

    found = regexp(text, HEADING, "names", "lineanchors");
    if isempty(found)
        return
    end

    shallowest = min(strlength([found.hashes]));
    shift = targetTopLevel - shallowest;
    if shift <= 0
        return
    end

    text = regexprep(text, HEADING, repmat("#", 1, shift) + "$1 ", "lineanchors");
end
