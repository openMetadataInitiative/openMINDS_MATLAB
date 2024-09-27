function shortSchemaName = getSchemaShortName(fullSchemaName)
%getSchemaShortName Get short schema name from full schema name
% 
%   shortSchemaName = getSchemaShortName(fullSchemaName)
%
%   Example:
%   fullSchemaName = 'openminds.core.research.Subject';
%   shortSchemaName = om.MetadataSet.getSchemaShortName(fullSchemaName)
%   shortSchemaName =
% 
%     'Subject'

    expression = '(?<=\.)\w*$'; % Get every word after a . at the end of a string
    shortSchemaName = regexp(fullSchemaName, expression, 'match', 'once');
    if isempty(shortSchemaName)
        shortSchemaName = fullSchemaName;
    end
end