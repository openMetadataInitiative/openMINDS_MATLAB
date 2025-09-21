function formattedLinks = getFormattedTypeLinksForDisplay(typeNames, options)
% getFormattedTypeLinksForDisplay - Get a formatted link for a type name
%
%   Creates an html anchor <a> link which will display as a clickable
%   hyperlink in the MATLAB command window.

    arguments
        typeNames (1,:) string
        options.Join (1,1) logical = true
        options.JoinDelimiter = ", "
    end

    % Special mode, need to split. If type names are provided as a
    % comma-separated list.
    if isscalar(typeNames) && contains(typeNames, ',')
        typeNames = string(split(typeNames, ','));
    end
    
    numTypes = numel(typeNames);
    formattedLinks = repmat("", 1, numTypes);

    for i = 1:numTypes
        formattedLinks(i) = openminds.internal.utility.getSchemaDocLink(char(typeNames(i)));
    end

    if options.Join
        formattedLinks = strjoin(formattedLinks, options.JoinDelimiter);
    end
end
