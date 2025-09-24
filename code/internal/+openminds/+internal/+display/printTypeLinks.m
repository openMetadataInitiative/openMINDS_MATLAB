function printTypeLinks(typeNames, options)
    arguments
        typeNames (1,:) string
        options.prefix (1,1) string = missing
        options.Delimiter
    end
    
    typeLinks = openminds.internal.display.getFormattedTypeLinksForDisplay(...
        typeNames, "JoinDelimiter", options.Delimiter);

    if ~ismissing(options.prefix)
        fprintf('%s\n  %s\n\n', options.prefix, typeLinks)
    else
        disp(typeLinks)
    end
end
