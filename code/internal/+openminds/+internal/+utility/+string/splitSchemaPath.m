function [schemaCategory, schemaName] = splitSchemaPath(schemaPathStr)

    schemaPathList = strsplit(schemaPathStr, '/');

    if numel(schemaPathList) > 1
        schemaCategory = schemaPathList{end-1};
    else
        schemaCategory = '';
    end
    
    filename = schemaPathList{end};
    filenameSplit = strsplit(filename, '.');
    schemaName = filenameSplit{1};

    % Some instances have dashes and this does not work...
    % schemaName = regexp(schemaPathList{end}, '^\w*(?=.)', 'match', 'once');
end
