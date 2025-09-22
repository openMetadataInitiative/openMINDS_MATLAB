function s = decode(str, options)
%DECODE - Decode openMINDS JSON-LD into MATLAB structs.
%
%   s = openminds.internal.utility.json.decode(str)
%   s = openminds.internal.utility.json.decode(str, 'AllowUnknownAtKeys', true)
%
%   This function:
%     - Converts JSON-LD reserved keyword object keys (@context, @id, @type,
%       @graph, @vocab) into MATLAB-valid field names (at_context, at_id, etc.)
%       BEFORE jsondecode (since MATLAB cannot have '@' in struct field names).
%     - Avoids altering occurrences of these tokens inside string values.
%     - Optionally emits warnings or errors for unexpected @-prefixed keys.
%
%   PARAMETERS (Name-Value):
%     ErrorOnUnknownAtKeys (logical): If true and an unknown @key is found
%                                    (when AllowUnknownAtKeys=false), throw error.
%
%   EXAMPLES:
%     data = openminds.internal.utility.json.decode(jsonText);
%
%   LIMITATIONS:
%     - Does not attempt general JSON-LD processing (framing, expansion).
%
%   See also: jsonencode, jsondecode

    arguments
        str (1,1) string
        options.ErrorOnUnknownAtKeys (1,1) logical = false
    end

    % ------------------------------------------------------------------
    % 1. Define allowed JSON-LD keywords (subset for openMINDS)
    % ------------------------------------------------------------------
    allowedKeywords = ["@context", "@id", "@type", "@graph", "@vocab"];

    % ------------------------------------------------------------------
    % 2. Regex to find ONLY unescaped object key names starting with "@"
    % ------------------------------------------------------------------
    % Pattern explanation:
    %   (?<!\\)"@([A-Za-z]+)"\s*:
    %     (?<!\\)    : preceding quote is not escaped
    %     "@         : literal "@ following opening quote
    %     ([A-Za-z]+): capture the keyword characters (letters only)
    %     "\s*:      : closing quote, optional whitespace, colon
    keyPattern = '(?<!\\)"@([A-Za-z]+)"\s*:';
    [tokens, starts, ends] = regexp(str, keyPattern, 'tokens', 'start', 'end');

    unknownKeywords = string.empty;
    
    str = char(str);

    if ~isempty(tokens)
        newParts = {};
        lastIdx = 1;

        for i = 1:numel(tokens)
            matchSegment = str(starts(i):ends(i));
            bareKey = tokens{i}{1};      % without '@'
            fullKey = "@" + bareKey;
            
            isAllowed = ismember(fullKey, allowedKeywords);
            if ~isAllowed
                unknownKeywords(end+1) = fullKey; %#ok<AGROW>
            end

            matlabKey = "at_" + bareKey;

            % Replace only the first occurrence of @<bareKey> inside this key segment
            if isAllowed
                replacedSegment = regexprep(matchSegment, ['@' bareKey], matlabKey, 'once');
            else
                replacedSegment = matchSegment;
            end

            newParts(end+1) = extractBetween(str, lastIdx, starts(i)-1); %#ok<AGROW> % ExtractBetween returns cell
            newParts{end+1} = replacedSegment; %#ok<AGROW>
            lastIdx = ends(i)+1;
        end

        newParts{end+1} = extractAfter(str, lastIdx-1);
        str = strjoin(newParts, "");
    end


    % ------------------------------------------------------------------
    % 3. Handle unknown keywords (if any)
    % ------------------------------------------------------------------
    if ~isempty(unknownKeywords)
        msg = sprintf(['decode: Found unknown @-prefixed keys (not in allowed set):\n  %s\n' ...
                       'If this is intentional, ignore this warning.'], strjoin(unique(unknownKeywords), newline + "  "));
        if options.ErrorOnUnknownAtKeys
            error('openMINDS:json:decode:UnknownAtKeys', '%s', msg);
        else
            warning('openMINDS:json:decode:UnknownAtKeys', '%s', msg);
        end
    end

    % ------------------------------------------------------------------
    % 4. Decode JSON
    % ------------------------------------------------------------------
    s = jsondecode(str);
end
