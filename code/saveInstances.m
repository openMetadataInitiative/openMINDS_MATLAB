function str = saveInstances(instance, filePath, options)
    
    arguments
        instance openminds.abstract.Schema
        filePath (1,1) string = ""
        options.OutputFormat (1,1) string = "jsonld"
        options.RecursionDepth = 1
    end

    import openminds.internal.serializer.JsonLdSerializer
    
    switch options.OutputFormat
        case "jsonld"
            str = JsonLdSerializer(instance, options.RecursionDepth).convert();
            
            if ~iscell(str); str = {str}; end
            
            str = strjoin(str, '\n');
            if filePath==""
                disp(str)
            else
                openminds.internal.utility.filewrite(filePath, str)
            end
            
        otherwise
            error('Unkown output format')
    end

    if ~nargout
        clear str
    end
end

