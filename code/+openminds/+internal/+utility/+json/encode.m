function str = encode(s, options)
% ENCODE - Encode a MATLAB struct (with JSON-LD keyword shims) to JSON-LD text.
%
%   str = openminds.internal.utility.json.encode(s)
%   str = openminds.internal.utility.json.encode(s, 'PrettyPrint', true)
%   str = openminds.internal.utility.json.encode(s, 'ErrorOnUnknownAtPrefix', false)
%
%   This function:
%     1. Uses jsonencode to get a JSON string from a MATLAB struct whose field
%        names use 'at_' prefixes as stand-ins for JSON-LD '@' keywords.
%     2. Rewrites ONLY those object keys (not string values) that match the
%        allowed JSON-LD keyword set (obtained from
%        openminds.internal.serializer.jsonld.getJsonLDKeywords) from
%        "at_xxx" -> "@xxx".
%     4. Performs safety checks to ensure no unexpected at_-prefixed keys
%        remain (unless allowed), with optional error escalation.
%
%   Safety strategies:
%     - Key replacement only when pattern is:  "<quoted_name>" (optional space) :
%     - Only known JSON-LD keywords are converted.
%     - Detects and optionally errors on unknown at_-prefixed keys that
%       would otherwise be silently turned into JSON-LD-like constructs.
%
%   PARAMETERS (Name-Value):
%     PrettyPrint                (logical)  : jsonencode pretty print (default: true)
%     ErrorOnUnknownAtPrefix     (logical)  : If true, throw error if unknown at_* keys remain
%                                             (default: false)
%
%   See also: jsondecode, jsonencode

    arguments
        s struct
        options.PrettyPrint (1,1) logical = true
        options.ErrorOnUnknownAtPrefix (1,1) logical = false
    end

    % ----------------------------------------------------------------------
    % 1. Encode to JSON (MATLAB-compliant fieldnames)
    % ----------------------------------------------------------------------
    str = jsonencode(s, 'PrettyPrint', options.PrettyPrint);

    % ----------------------------------------------------------------------
    % 2. Prepare JSON-LD keyword mapping
    % ----------------------------------------------------------------------

    jsonLdKeywords = openminds.internal.serializer.jsonld.getJsonLDKeywords();
    matlabShimKeywords = strrep(jsonLdKeywords, '@', 'at_');  % simple 1–1 map

    % Put into a containers.Map for quick membership / lookup if needed
    keywordMap = containers.Map(matlabShimKeywords, jsonLdKeywords);

    % ----------------------------------------------------------------------
    % 3. Replace only KNOWN keyword shims in object key positions
    % ----------------------------------------------------------------------
    %
    % We look for patterns: "<matlabShim>" <optional whitespace> :
    % and replace ONLY the key portion.
    %
    % This avoids accidental replacements inside string literal values.
    %
    % We do this one keyword at a time to keep it simple and explicit; the
    % number of JSON-LD keywords is small so performance impact is minimal.
    
    for i = 1:numel(matlabShimKeywords)
        shim = matlabShimKeywords{i};
        jsonld = keywordMap(shim);

        % Pattern: "<shim>" (optional whitespace) :
        % Use reluctant whitespace match: \s*
        pattern = ['"' , shim , '"\s*:'];
        replacement = ['"' , jsonld , '":'];

        if contains(str, ['"' shim '"']) % quick pre-check to skip regex if absent
            str = regexprep(str, pattern, replacement);
        end
    end

    % ----------------------------------------------------------------------
    % 4. Detect unknown at_-prefixed keys (possible mistakes)
    % ----------------------------------------------------------------------
    %
    % Find any remaining object keys of the form "at_<name>" that are NOT
    % part of the known mapping. These could indicate:
    %   - A forgotten addition to jsonLdKeywords
    %   - A user property mistakenly starting with at_
    %   - A keyword we intentionally decided not to map (then whitelist it)
    %
    % We capture the key name via:
    %   "(at_[A-Za-z0-9_]+)"\s*:
    %
    unknownKeyPattern = '"(at_[A-Za-z0-9_]+)"\s*:';
    remainingMatches = regexp(str, unknownKeyPattern, 'tokens');

    if ~isempty(remainingMatches)
        remainingKeys = unique( string( cellfun(@(c) c{1}, remainingMatches, 'uni', false) ) );
        % Exclude those we expect (if any were intentionally left unmapped)
        knownSet = string(matlabShimKeywords);
        unknown = setdiff(remainingKeys, knownSet);

        if ~isempty(unknown)
            msg = sprintf(['encode: Detected one or more at_-prefixed keys in JSON output that are not in the JSON-LD keyword map:\n  %s\n' ...
                           'These were NOT converted to @-form. If intentional, ignore; otherwise rename or add handling.'], ...
                           strjoin(unknown, newline + "  "));
            if options.ErrorOnUnknownAtPrefix
                error('openMINDS:json:encode:UnknownAtPrefix', '%s', msg);
            else
                warning('openMINDS:json:encode:UnknownAtPrefix', '%s', msg);
            end
        end
    end

    % ----------------------------------------------------------------------
    % 5. Final newline guarantee
    % ----------------------------------------------------------------------
    if ~isempty(str) && ~isequal(str(end), newline)
        str = [str newline];
    end
end
