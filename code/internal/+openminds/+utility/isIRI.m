function isValid = isIRI(value)
% isIRI Validates an Internationalized Resource Identifier (IRI)
%   isValid = isIRI(value) returns true if the input string 'value'
%   has the basic structure of an IRI as defined in RFC 3987 section 2.1,
%   and false otherwise.
%
%   This function uses a regular expression to check for:
%     - A scheme, which must start with a letter and can include letters,
%       digits, plus (+), hyphen (-), and period (.)
%     - An optional authority preceded by "//" (which should not include
%       the delimiters ?, or #)
%     - A path (which is any sequence of characters except '?' and '#')
%     - An optional query (preceded by '?')
%     - An optional fragment (preceded by '#')
%
%   Note: This validator provides a basic check and does not fully enforce
%   all details of RFC 3987 (for example, the precise allowed Unicode
%   ranges in each component).
%
%   Example:
%       validIRI = 'http://例え.テスト/path?query#fragment';
%       isValid = openminds.utility.isIRI(validIRI);
%
%   Author: ChatGPT o3-mini-high

    % Regular expression pattern for a simplified IRI structure:
    %   - (?<scheme>[A-Za-z][A-Za-z0-9+\-.]*):  --> scheme followed by ':'
    %   - (?://(?<authority>[^/?#]*))?           --> optional "//" and authority
    %   - (?<path>[^?#]*)                        --> path (no '?' or '#')
    %   - (?:\?(?<query>[^#]*))?                  --> optional query starting with '?'
    %   - (?:#(?<fragment>.*))?                   --> optional fragment starting with '#'
    %
    % Note: Double backslashes (\\) are used in MATLAB string literals.
    pattern = ['^(?<scheme>[A-Za-z][A-Za-z0-9+\\-.]*):', ...
               '(?://(?<authority>[^/?#]*))?', ...
               '(?<path>[^?#]*)', ...
               '(?:\\?(?<query>[^#]*))?', ...
               '(?:#(?<fragment>.*))?$', ...
              ];
    
    % Use regexp with the 'names' option to capture components
    tokens = regexp(value, pattern, 'names');
    
    % The IRI is considered valid if the regex returns non-empty tokens.
    isValid = ~isempty(tokens);
end
