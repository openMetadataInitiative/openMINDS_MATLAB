function shortSchemaName = getSchemaShortName(fullSchemaName)
%getSchemaShortName Get short schema name from full schema name
% 
%   shortSchemaName = getSchemaShortName(fullSchemaName)
%
%   Example:
%   fullSchemaName = 'openminds.core.research.Subject';
%   shortSchemaName = openminds.internal.utility.getSchemaShortName(fullSchemaName)
%   shortSchemaName =
% 
%     'Subject'

    if iscell(fullSchemaName) && numel(fullSchemaName) > 1
        shortSchemaName = cellfun(@(c) openminds.internal.utility.getSchemaShortName(c), fullSchemaName);
        return

    elseif isstring(fullSchemaName) && numel(fullSchemaName) > 1
        shortSchemaName = arrayfun(@(str) openminds.internal.utility.getSchemaShortName(str), fullSchemaName);
        return
    end

    expression = '(?<=\.)\w*$'; % Get every word after a . at the end of a string
    shortSchemaName = regexp(fullSchemaName, expression, 'match', 'once');
    if isempty(shortSchemaName)
        shortSchemaName = fullSchemaName;
    end
end