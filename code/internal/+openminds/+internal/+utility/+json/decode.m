function s = decode(str)
%decode Decode json/jsonld strings

    % Find any property names starting with @ (syntax token?).
    % The regular expression matches any word prefixed by @, encapsulated
    % in "" and followed by a colon. This should hopefully only match
    % for json-ld specific property names / keywords.
    % See also: https://www.w3.org/TR/json-ld/#syntax-tokens-and-keywords

    jsonLdKeywords = unique( regexp(str, '(?<=\")\@\w*(?=\":)', 'match' ) );
    validMatlabNames = strrep(jsonLdKeywords, '@', 'at_');

    for i = 1:numel(jsonLdKeywords)
        str = strrep(str, jsonLdKeywords{i}, validMatlabNames{i});
    end

    s = jsondecode(str);
end
